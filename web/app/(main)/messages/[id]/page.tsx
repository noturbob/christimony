"use client";

import { Fragment, useCallback, useEffect, useRef, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth-context";
import {
  getConversations,
  getMessages,
  markConversationRead,
  sendMessage,
  ConversationSummary,
  Message,
  MESSAGES_PAGE_SIZE,
} from "@/lib/conversations";
import { SafetyActions } from "@/components/safety-actions";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

const POLL_INTERVAL_MS = 5000;
const MAX_BODY = 2000;

// Merge by id so polling and "load earlier" never duplicate a message, and a
// re-fetched copy (e.g. now with read_at set) replaces the stale one.
function merge(current: Message[], incoming: Message[]) {
  const byId = new Map(current.map((m) => [m.id, m]));
  for (const m of incoming) byId.set(m.id, m);
  return [...byId.values()].sort((a, b) => a.id - b.id);
}

function dayLabel(iso: string) {
  const d = new Date(iso);
  const today = new Date();
  const yesterday = new Date();
  yesterday.setDate(today.getDate() - 1);
  if (d.toDateString() === today.toDateString()) return "Today";
  if (d.toDateString() === yesterday.toDateString()) return "Yesterday";
  return d.toLocaleDateString(undefined, { weekday: "short", month: "short", day: "numeric" });
}

export default function MessageThreadPage() {
  const { account } = useAuth();
  const router = useRouter();
  const params = useParams();
  const conversationId = Number(params.id);

  const [conversation, setConversation] = useState<ConversationSummary | null>(null);
  const [unavailable, setUnavailable] = useState(false);
  const [messages, setMessages] = useState<Message[]>([]);
  const [loadingMessages, setLoadingMessages] = useState(true);
  const [hasEarlier, setHasEarlier] = useState(false);
  const [loadingEarlier, setLoadingEarlier] = useState(false);
  const [draft, setDraft] = useState("");
  const [sending, setSending] = useState(false);
  const [error, setError] = useState("");
  const bottomRef = useRef<HTMLDivElement>(null);

  const accountId = account?.id;

  // Reading is explicit now (GET no longer marks read), and only while the
  // thread is actually on screen.
  const markReadIfNeeded = useCallback(
    (batch: Message[]) => {
      if (document.hidden) return;
      if (batch.some((m) => m.sender_account_id !== accountId && !m.read_at)) {
        markConversationRead(conversationId).catch(() => {});
      }
    },
    [accountId, conversationId]
  );

  useEffect(() => {
    if (!accountId) return;
    // No GET /conversations/:id -- the list is also how we learn the thread
    // is gone (blocked/deleted profiles drop out of it).
    getConversations()
      .then((all) => {
        const found = all.find((c) => c.id === conversationId);
        if (found) setConversation(found);
        else setUnavailable(true);
      })
      .catch(() => {});
  }, [accountId, conversationId]);

  useEffect(() => {
    if (!accountId || unavailable) return;

    let cancelled = false;
    let first = true;
    function poll() {
      if (!first && document.hidden) return;
      // ponytail: polls only the newest page; a burst of >30 messages within
      // one interval would leave a gap until "load earlier". ActionCable fixes it.
      getMessages(conversationId)
        .then((data) => {
          if (cancelled) return;
          if (first) setHasEarlier(data.length === MESSAGES_PAGE_SIZE);
          first = false;
          setMessages((prev) => merge(prev, data));
          markReadIfNeeded(data);
        })
        .catch(() => {})
        .finally(() => {
          if (!cancelled) setLoadingMessages(false);
        });
    }

    poll();
    const interval = setInterval(poll, POLL_INTERVAL_MS);
    document.addEventListener("visibilitychange", poll);
    return () => {
      cancelled = true;
      clearInterval(interval);
      document.removeEventListener("visibilitychange", poll);
    };
  }, [accountId, conversationId, unavailable, markReadIfNeeded]);

  // Only follow the bottom when a newer message arrives -- not on polls that
  // changed nothing, and not when older history is prepended.
  const lastId = messages.at(-1)?.id;
  useEffect(() => {
    if (lastId) bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [lastId]);

  async function loadEarlier() {
    if (!messages[0]) return;
    setLoadingEarlier(true);
    try {
      const older = await getMessages(conversationId, messages[0].id);
      setHasEarlier(older.length === MESSAGES_PAGE_SIZE);
      setMessages((prev) => merge(prev, older));
    } catch {
      // Leave the button in place to retry.
    } finally {
      setLoadingEarlier(false);
    }
  }

  async function handleSend(e: React.FormEvent) {
    e.preventDefault();
    if (!draft.trim()) return;
    setSending(true);
    setError("");
    try {
      const message = await sendMessage(conversationId, draft.trim());
      setMessages((prev) => merge(prev, [message]));
      setDraft("");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to send message");
    } finally {
      setSending(false);
    }
  }

  if (!account) return null;

  if (unavailable) {
    return (
      <div className="max-w-sm mx-auto px-8 py-20 text-center space-y-4">
        <h1 className="font-display text-3xl">This conversation isn&apos;t available.</h1>
        <Link href="/messages"><Button variant="outline">Back to Messages</Button></Link>
      </div>
    );
  }

  const other = conversation?.other_profile;

  return (
    <div className="max-w-3xl mx-auto w-full px-6 py-6 flex flex-col min-h-[80vh]">
      <div className="flex items-center justify-between gap-4 mb-4">
        <div className="flex items-center gap-3 min-w-0">
          <Link href="/messages" className="text-sm text-muted-foreground hover:text-foreground">←</Link>
          {other && (
            <Link href={`/profiles/${other.id}`} className="font-display text-xl truncate hover:text-primary">
              {other.name}
            </Link>
          )}
        </div>
        {other && (
          <SafetyActions profileId={other.id} profileName={other.name} onBlocked={() => router.replace("/messages")} />
        )}
      </div>

      <div className="flex-1 space-y-3 overflow-y-auto">
        {hasEarlier && (
          <div className="flex justify-center">
            <button
              onClick={loadEarlier}
              disabled={loadingEarlier}
              className="text-xs text-muted-foreground underline underline-offset-4 hover:text-foreground"
            >
              {loadingEarlier ? "Loading..." : "Load earlier messages"}
            </button>
          </div>
        )}
        {loadingMessages ? (
          <p className="text-muted-foreground text-center mt-10">Loading conversation...</p>
        ) : messages.length === 0 ? (
          <p className="text-muted-foreground text-center mt-10">Say hello — this is the start of your conversation.</p>
        ) : (
          messages.map((m, i) => {
            const isMine = m.sender_account_id === account.id;
            const day = dayLabel(m.sent_at);
            const newDay = i === 0 || dayLabel(messages[i - 1].sent_at) !== day;
            return (
              <Fragment key={m.id}>
                {newDay && (
                  <p className="text-center text-[11px] uppercase tracking-wide text-muted-foreground pt-3">{day}</p>
                )}
                <div className={`flex ${isMine ? "justify-end" : "justify-start"}`}>
                  <div
                    className={`max-w-[75%] rounded-2xl px-4 py-2 text-sm ${
                      isMine
                        ? "bg-primary text-primary-foreground rounded-br-sm"
                        : "bg-secondary text-secondary-foreground rounded-bl-sm"
                    }`}
                  >
                    <p className="whitespace-pre-wrap break-words">{m.body}</p>
                    <p className="text-[10px] opacity-60 text-right mt-0.5">
                      {new Date(m.sent_at).toLocaleTimeString(undefined, { hour: "numeric", minute: "2-digit" })}
                    </p>
                  </div>
                </div>
              </Fragment>
            );
          })
        )}
        <div ref={bottomRef} />
      </div>

      {error && <p className="text-sm text-destructive mt-2">{error}</p>}

      <form onSubmit={handleSend} className="flex gap-2 mt-4 pt-4 border-t border-border">
        <Input
          placeholder="Write a message..."
          value={draft}
          maxLength={MAX_BODY}
          onChange={(e) => setDraft(e.target.value)}
          className="rounded-full"
        />
        <Button type="submit" className="rounded-full" disabled={sending || !draft.trim()}>
          Send
        </Button>
      </form>
    </div>
  );
}

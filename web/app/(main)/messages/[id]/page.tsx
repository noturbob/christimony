"use client";

import { useEffect, useRef, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth-context";
import { getMessages, sendMessage, Message } from "@/lib/conversations";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export default function MessageThreadPage() {
  const { account, token, loading } = useAuth();
  const router = useRouter();
  const params = useParams();
  const conversationId = Number(params.id);

  const [messages, setMessages] = useState<Message[]>([]);
  const [loadingMessages, setLoadingMessages] = useState(true);
  const [draft, setDraft] = useState("");
  const [sending, setSending] = useState(false);
  const [error, setError] = useState("");
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!loading && !account) router.push("/login");
  }, [loading, account, router]);

  useEffect(() => {
    if (!token) return;
    getMessages(token, conversationId)
      .then(setMessages)
      .finally(() => setLoadingMessages(false));
  }, [token, conversationId]);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [messages]);

  async function handleSend(e: React.FormEvent) {
    e.preventDefault();
    if (!token || !draft.trim()) return;
    setSending(true);
    setError("");
    try {
      const message = await sendMessage(token, conversationId, draft.trim());
      setMessages((prev) => [...prev, message]);
      setDraft("");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to send message");
    } finally {
      setSending(false);
    }
  }

  if (loading) return <p className="p-8">Loading...</p>;
  if (!account) return null;

  return (
    <div className="max-w-3xl mx-auto w-full px-6 py-6 flex flex-col min-h-[80vh]">
      <Link href="/messages" className="text-sm text-muted-foreground hover:text-foreground mb-4">← Matches</Link>

      <div className="flex-1 space-y-3 overflow-y-auto">
        {loadingMessages ? (
          <p className="text-muted-foreground text-center mt-10">Loading conversation...</p>
        ) : messages.length === 0 ? (
          <p className="text-muted-foreground text-center mt-10">Say hello — this is the start of your conversation.</p>
        ) : (
          messages.map((m) => {
            const isMine = m.sender_account_id === account.id;
            return (
              <div key={m.id} className={`flex ${isMine ? "justify-end" : "justify-start"}`}>
                <div
                  className={`max-w-[75%] rounded-2xl px-4 py-2 text-sm ${
                    isMine
                      ? "bg-primary text-primary-foreground rounded-br-sm"
                      : "bg-secondary text-secondary-foreground rounded-bl-sm"
                  }`}
                >
                  {m.body}
                </div>
              </div>
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
"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useAuth } from "@/lib/auth-context";
import { getConversations, ConversationSummary } from "@/lib/conversations";

export default function MessagesInboxPage() {
  const { account } = useAuth();
  const [conversations, setConversations] = useState<ConversationSummary[]>([]);
  const [loadingData, setLoadingData] = useState(true);

  useEffect(() => {
    if (!account) return;
    getConversations().then(setConversations).finally(() => setLoadingData(false));
  }, [account]);

  if (!account) return null;

  return (
    <div className="max-w-md mx-auto px-4 pt-8">
      <h1 className="font-display text-2xl mb-6">Messages</h1>

      {loadingData ? (
        <p className="text-muted-foreground text-center py-20">Loading...</p>
      ) : conversations.length === 0 ? (
        <div className="text-center py-20 space-y-3">
          <p className="text-muted-foreground text-sm">
            No conversations yet — they start once you match with someone.
          </p>
        </div>
      ) : (
        <div className="space-y-1">
          {conversations.map((c) => (
            <Link
              key={c.id}
              href={`/messages/${c.id}`}
              className="flex items-center gap-4 py-3 border-b border-border"
            >
              <div className="relative h-12 w-12 rounded-full bg-secondary overflow-hidden flex items-center justify-center shrink-0">
                {c.other_profile.cover_photo_url ? (
                  /* eslint-disable-next-line @next/next/no-img-element */
                  <img src={c.other_profile.cover_photo_url} alt="" className="w-full h-full object-cover" />
                ) : (
                  <span className="font-display text-lg text-primary/50">{c.other_profile.name.charAt(0)}</span>
                )}
                {c.unread_count > 0 && (
                  <span className="absolute -top-0.5 -right-0.5 h-3 w-3 rounded-full bg-accent border-2 border-background" />
                )}
              </div>
              <div className="flex-1 min-w-0">
                <p className={`font-medium ${c.unread_count > 0 ? "" : ""}`}>{c.other_profile.name}</p>
                <p className={`text-sm truncate ${c.unread_count > 0 ? "text-foreground font-medium" : "text-muted-foreground"}`}>
                  {c.last_message ? c.last_message.body : "Say hello 👋"}
                </p>
              </div>
              {c.last_message && (
                <span className="text-xs text-muted-foreground shrink-0">
                  {new Date(c.last_message.sent_at).toLocaleDateString()}
                </span>
              )}
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}

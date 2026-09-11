"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth-context";
import { getMatches, Match } from "@/lib/profiles";
import { createConversation } from "@/lib/conversations";
import { Button } from "@/components/ui/button";

export default function MatchesPage() {
  const { account } = useAuth();
  const router = useRouter();
  const [matches, setMatches] = useState<Match[]>([]);
  const [loadingMatches, setLoadingMatches] = useState(true);
  const [openingId, setOpeningId] = useState<number | null>(null);

  useEffect(() => {
    if (!account) return;
    getMatches()
      .then(setMatches)
      .finally(() => setLoadingMatches(false));
  }, [account]);

  async function handleMessage(matchId: number) {
    setOpeningId(matchId);
    try {
      const conversation = await createConversation(matchId);
      router.push(`/messages/${conversation.id}`);
    } catch {
      setOpeningId(null);
    }
  }

  if (!account) return null;

  return (
    <div className="max-w-3xl mx-auto w-full px-6 py-12 md:py-16 space-y-10 md:space-y-12">
      <div className="text-center md:text-left space-y-3">
        <h1 className="font-display text-4xl md:text-5xl">Your matches</h1>
        <p className="text-muted-foreground text-base md:text-lg">People who liked you back.</p>
      </div>

      {loadingMatches ? (
        <p className="text-muted-foreground">Loading...</p>
      ) : matches.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border p-12 text-center">
          <p className="text-muted-foreground">No matches yet — keep browsing.</p>
          <Link href="/discover" className="inline-block mt-5">
            <Button size="lg" className="rounded-full">Browse profiles</Button>
          </Link>
        </div>
      ) : (
        <div className="space-y-4">
          {matches.map((m) => {
            const other = m.my_profile_id === m.profile_a.id ? m.profile_b : m.profile_a;
            return (
              <div key={m.id} className="rounded-2xl border border-border bg-card p-6 flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="h-12 w-12 rounded-full bg-secondary overflow-hidden flex items-center justify-center shrink-0">
                    {other.cover_photo_url ? (
                      /* eslint-disable-next-line @next/next/no-img-element */
                      <img src={other.cover_photo_url} alt="" className="w-full h-full object-cover" />
                    ) : (
                      <span className="font-display text-lg text-primary/50">{other.name.charAt(0)}</span>
                    )}
                  </div>
                  <div>
                    <p className="font-medium">{other.name}</p>
                    <p className="text-xs text-muted-foreground">
                      {other.city && `${other.city} · `}
                      Matched {new Date(m.matched_at).toLocaleDateString()}
                    </p>
                  </div>
                </div>
                <Button
                  variant="outline"
                  className="rounded-full"
                  size="sm"
                  disabled={openingId === m.id}
                  onClick={() => handleMessage(m.id)}
                >
                  {openingId === m.id ? "Opening..." : "Message"}
                </Button>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

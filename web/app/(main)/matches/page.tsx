"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth-context";
import { getMatches, getMyProfiles, Match, Profile } from "@/lib/profiles";
import { createConversation } from "@/lib/conversations";
import { Button } from "@/components/ui/button";

export default function MatchesPage() {
  const { account, token, loading } = useAuth();
  const router = useRouter();
  const [matches, setMatches] = useState<Match[]>([]);
  const [myProfileIds, setMyProfileIds] = useState<number[]>([]);
  const [loadingMatches, setLoadingMatches] = useState(true);
  const [openingId, setOpeningId] = useState<number | null>(null);

  useEffect(() => {
    if (!loading && !account) router.push("/login");
  }, [loading, account, router]);

  useEffect(() => {
    if (!token) return;
    Promise.all([getMatches(token), getMyProfiles(token)])
      .then(([matchResults, profileResults]) => {
        setMatches(matchResults);
        setMyProfileIds(profileResults.map((p: Profile) => p.id));
      })
      .finally(() => setLoadingMatches(false));
  }, [token]);

  async function handleMessage(matchId: number) {
    if (!token) return;
    setOpeningId(matchId);
    try {
      const conversation = await createConversation(token, matchId);
      router.push(`/messages/${conversation.id}`);
    } catch (err) {
      setOpeningId(null);
    }
  }

  if (loading) return <p className="p-8">Loading...</p>;
  if (!account) return null;

  return (
    <div className="max-w-3xl mx-auto px-6 py-10 space-y-6">
      <div>
        <h1 className="font-display text-3xl">Your matches</h1>
        <p className="text-muted-foreground mt-1">People who liked you back.</p>
      </div>

      {loadingMatches ? (
        <p className="text-muted-foreground">Loading...</p>
      ) : matches.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border p-10 text-center">
          <p className="text-muted-foreground">No matches yet — keep browsing.</p>
          <Link href="/feed" className="inline-block mt-4">
            <Button className="rounded-full">Browse profiles</Button>
          </Link>
        </div>
      ) : (
        <div className="space-y-3">
          {matches.map((m) => {
            const other = myProfileIds.includes(m.profile_a.id) ? m.profile_b : m.profile_a;
            return (
              <div key={m.id} className="rounded-2xl border border-border bg-card p-5 flex items-center justify-between">
                <div className="flex items-center gap-4">
                  <div className="h-12 w-12 rounded-full bg-secondary flex items-center justify-center shrink-0">
                    <span className="font-display text-lg text-primary/50">{other.name.charAt(0)}</span>
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
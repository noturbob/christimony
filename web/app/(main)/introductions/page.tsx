"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { getMyProfiles, Profile } from "@/lib/profiles";
import { getIntroductions, acceptIntroduction, declineIntroduction, Introduction } from "@/lib/introductions";
import { Button } from "@/components/ui/button";

export default function IntroductionsPage() {
  const { account, token, loading } = useAuth();
  const router = useRouter();

  const [introductions, setIntroductions] = useState<Introduction[]>([]);
  const [myProfiles, setMyProfiles] = useState<Profile[]>([]);
  const [loadingData, setLoadingData] = useState(true);
  const [actingOn, setActingOn] = useState<number | null>(null);
  const [error, setError] = useState("");

  useEffect(() => {
    if (!loading && !account) router.push("/login");
  }, [loading, account, router]);

  function loadAll() {
    if (!token) return;
    setLoadingData(true);
    Promise.all([getIntroductions(token), getMyProfiles(token)])
      .then(([intros, profiles]) => {
        setIntroductions(intros);
        setMyProfiles(profiles);
      })
      .finally(() => setLoadingData(false));
  }

  useEffect(loadAll, [token]);

  const myWardIds = new Set(myProfiles.filter((p) => p.profile_type === "ward").map((p) => p.id));

  function myWardIn(intro: Introduction) {
    return myWardIds.has(intro.ward_a.id) ? intro.ward_a : intro.ward_b;
  }

  function otherWardIn(intro: Introduction) {
    return myWardIds.has(intro.ward_a.id) ? intro.ward_b : intro.ward_a;
  }

  async function handleAccept(intro: Introduction) {
    if (!token) return;
    setError("");
    setActingOn(intro.id);
    try {
      const updated = await acceptIntroduction(token, intro.id, myWardIn(intro).id);
      setIntroductions((prev) => prev.map((i) => (i.id === intro.id ? { ...i, status: updated.status } : i)));
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to accept");
    } finally {
      setActingOn(null);
    }
  }

  async function handleDecline(intro: Introduction) {
    if (!token) return;
    setError("");
    setActingOn(intro.id);
    try {
      const updated = await declineIntroduction(token, intro.id, myWardIn(intro).id);
      setIntroductions((prev) => prev.map((i) => (i.id === intro.id ? { ...i, status: updated.status } : i)));
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to decline");
    } finally {
      setActingOn(null);
    }
  }

  function statusLabel(intro: Introduction, myWardId: number) {
    if (intro.status === "accepted") return "Both accepted — check Matches";
    if (intro.status === "declined") return "Declined";
    if (intro.status === "pending_both") return "Awaiting a response from both sides";
    if (intro.status === "pending_a") return myWardId === intro.ward_a.id ? "Waiting on you" : "Waiting on the other family";
    if (intro.status === "pending_b") return myWardId === intro.ward_b.id ? "Waiting on you" : "Waiting on the other family";
    return intro.status;
  }

  function canRespond(intro: Introduction, myWardId: number) {
    if (intro.status === "pending_both") return true;
    if (intro.status === "pending_a") return myWardId === intro.ward_a.id;
    if (intro.status === "pending_b") return myWardId === intro.ward_b.id;
    return false;
  }

  if (loading) return <p className="p-8">Loading...</p>;
  if (!account) return null;

  return (
    <div className="max-w-3xl mx-auto px-6 py-10 space-y-6">
      <div>
        <h1 className="font-display text-3xl">Introductions</h1>
        <p className="text-muted-foreground mt-1">
          When you and another parent both express interest, your children are introduced here —
          nothing opens between them until they each say yes.
        </p>
      </div>

      {error && <p className="text-sm text-destructive">{error}</p>}

      {loadingData ? (
        <p className="text-muted-foreground">Loading...</p>
      ) : introductions.length === 0 ? (
        <div className="rounded-2xl border border-dashed border-border p-10 text-center">
          <p className="text-muted-foreground">No introductions yet.</p>
        </div>
      ) : (
        <div className="space-y-3">
          {introductions.map((intro) => {
            const mine = myWardIn(intro);
            const other = otherWardIn(intro);
            return (
              <div key={intro.id} className="rounded-2xl border border-border bg-card p-5 space-y-4">
                <div className="flex items-center gap-4">
                  <div className="h-12 w-12 rounded-full bg-secondary flex items-center justify-center shrink-0">
                    <span className="font-display text-lg text-primary/50">{other.name.charAt(0)}</span>
                  </div>
                  <div>
                    <p className="font-medium">{other.name}</p>
                    <p className="text-xs text-muted-foreground">
                      {other.city && `${other.city} · `}For {mine.name}
                    </p>
                  </div>
                </div>

                <p className="text-sm text-muted-foreground">{statusLabel(intro, mine.id)}</p>

                {canRespond(intro, mine.id) && (
                  <div className="flex gap-2">
                    <Button
                      className="rounded-full"
                      size="sm"
                      disabled={actingOn === intro.id}
                      onClick={() => handleAccept(intro)}
                    >
                      Accept
                    </Button>
                    <Button
                      variant="outline"
                      className="rounded-full"
                      size="sm"
                      disabled={actingOn === intro.id}
                      onClick={() => handleDecline(intro)}
                    >
                      Decline
                    </Button>
                  </div>
                )}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}
"use client";

import { useEffect, useState } from "react";
import { useParams, useSearchParams } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { getProfile, getMyProfiles, sendInterest, Profile } from "@/lib/profiles";
import { getVouches, Vouch } from "@/lib/vouches";
import { PhotoCarousel } from "@/components/photo-carousel";
import { Button } from "@/components/ui/button";

export default function ProfileDetailPage() {
  const { account } = useAuth();
  const params = useParams();
  const searchParams = useSearchParams();
  const profileId = Number(params.id);

  const [profile, setProfile] = useState<Profile | null>(null);
  const [myProfiles, setMyProfiles] = useState<Profile[]>([]);
  const [activeProfileId, setActiveProfileId] = useState<number | null>(null);
  const [vouches, setVouches] = useState<Vouch[]>([]);
  const [loadingData, setLoadingData] = useState(true);

  const [interestSent, setInterestSent] = useState(false);
  const [matchMessage, setMatchMessage] = useState("");
  const [sendingInterest, setSendingInterest] = useState(false);

  useEffect(() => {
    if (!account) return;
    Promise.all([
      getProfile(profileId),
      getMyProfiles(),
      getVouches(profileId),
    ]).then(([p, mine, v]) => {
      setProfile(p);
      setMyProfiles(mine);
      setVouches(v);
      const preselected = Number(searchParams.get("as"));
      setActiveProfileId(preselected && mine.some((m) => m.id === preselected) ? preselected : mine[0]?.id ?? null);
    }).finally(() => setLoadingData(false));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [account, profileId]);

  async function handleSendInterest() {
    if (!activeProfileId) return;
    setSendingInterest(true);
    setMatchMessage("");
    try {
      const result = await sendInterest(activeProfileId, profileId);
      setInterestSent(true);
      if (result.match) setMatchMessage("It's a match — say hello.");
    } catch (err) {
      setMatchMessage(err instanceof Error ? err.message : "Failed to send interest");
    } finally {
      setSendingInterest(false);
    }
  }

  if (loadingData) return <p className="p-8">Loading...</p>;
  if (!account || !profile) return null;

  return (
    <div className="max-w-3xl mx-auto px-6 py-10 space-y-8">
      <div className="rounded-2xl border border-border bg-card overflow-hidden">
        <div className="max-w-sm mx-auto">
          <PhotoCarousel photos={profile.photos} fallbackLetter={profile.name.charAt(0)} />
        </div>
        <div className="p-6 space-y-4">
          <div>
            <h1 className="font-display text-3xl">
              {profile.name}
              {profile.age ? <span className="text-muted-foreground font-normal">, {profile.age}</span> : null}
            </h1>
            <p className="text-muted-foreground mt-1">
              {[profile.city, profile.denomination, profile.profession].filter(Boolean).join(" · ")}
            </p>
          </div>

          {profile.bio && <p className="leading-relaxed">{profile.bio}</p>}

          {profile.prompts.length > 0 && (
            <div className="space-y-3 pt-2">
              {profile.prompts.map((prompt) => (
                <div key={prompt.id} className="rounded-2xl bg-secondary/40 p-4">
                  <p className="text-xs text-muted-foreground uppercase tracking-wide mb-1">{prompt.question}</p>
                  <p className="text-sm leading-relaxed font-display text-lg">{prompt.answer}</p>
                </div>
              ))}
            </div>
          )}

          <div className="grid grid-cols-2 gap-4 text-sm pt-2 border-t border-border">
            {profile.education && (
              <div>
                <p className="text-muted-foreground text-xs">Education</p>
                <p>{profile.education}</p>
              </div>
            )}
            {profile.gender && (
              <div>
                <p className="text-muted-foreground text-xs">Gender</p>
                <p className="capitalize">{profile.gender}</p>
              </div>
            )}
          </div>

          {myProfiles.length > 0 && (
            <div className="pt-4 border-t border-border space-y-3">
              {myProfiles.length > 1 && (
                <div>
                  <label className="text-xs text-muted-foreground block mb-1">Sending interest as</label>
                  <select
                    value={activeProfileId ?? ""}
                    onChange={(e) => setActiveProfileId(Number(e.target.value))}
                    className="rounded-full border border-input bg-background px-4 py-2 text-sm"
                  >
                    {myProfiles.map((p) => (
                      <option key={p.id} value={p.id}>{p.name}</option>
                    ))}
                  </select>
                </div>
              )}
              {matchMessage && (
                <p className="rounded-full bg-accent/10 text-accent px-5 py-3 text-sm font-medium">
                  {matchMessage}
                </p>
              )}
              <Button
                className="rounded-full"
                variant={interestSent ? "secondary" : "default"}
                disabled={interestSent || sendingInterest}
                onClick={handleSendInterest}
              >
                {interestSent ? "Interest sent" : sendingInterest ? "Sending..." : "Send interest"}
              </Button>
            </div>
          )}
        </div>
      </div>

      <div className="space-y-4">
        <h2 className="font-display text-xl">Vouches</h2>
        {vouches.length === 0 ? (
          <p className="text-muted-foreground text-sm">No one has vouched for {profile.name} yet.</p>
        ) : (
          <div className="space-y-2">
            {vouches.map((v) => (
              <div key={v.id} className="rounded-xl border border-border bg-card px-4 py-3 text-sm flex items-center justify-between">
                <span>{v.voucher_name} <span className="text-muted-foreground capitalize">· {v.voucher_role}</span></span>
                <span className="text-xs text-muted-foreground capitalize">{v.status}</span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

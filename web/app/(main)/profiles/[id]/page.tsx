"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter, useSearchParams } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { getProfile, getMyProfiles, sendInterest, Profile } from "@/lib/profiles";
import { getVouches, createVouch, Vouch } from "@/lib/vouches";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";

export default function ProfileDetailPage() {
  const { account, token, loading } = useAuth();
  const router = useRouter();
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

  const [voucherName, setVoucherName] = useState("");
  const [voucherRole, setVoucherRole] = useState("pastor");
  const [submittingVouch, setSubmittingVouch] = useState(false);

  useEffect(() => {
    if (!loading && !account) router.push("/login");
  }, [loading, account, router]);

  useEffect(() => {
    if (!token) return;
    Promise.all([
      getProfile(token, profileId),
      getMyProfiles(token),
      getVouches(token, profileId),
    ]).then(([p, mine, v]) => {
      setProfile(p);
      setMyProfiles(mine);
      setVouches(v);
      const preselected = Number(searchParams.get("as"));
      setActiveProfileId(preselected && mine.some((m) => m.id === preselected) ? preselected : mine[0]?.id ?? null);
    }).finally(() => setLoadingData(false));
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [token, profileId]);

  async function handleSendInterest() {
    if (!token || !activeProfileId) return;
    setSendingInterest(true);
    setMatchMessage("");
    try {
      const result = await sendInterest(token, activeProfileId, profileId);
      setInterestSent(true);
      if (result.match) setMatchMessage("It's a match — say hello.");
    } catch (err) {
      setMatchMessage(err instanceof Error ? err.message : "Failed to send interest");
    } finally {
      setSendingInterest(false);
    }
  }

  async function handleVouch(e: React.FormEvent) {
    e.preventDefault();
    if (!token || !voucherName.trim()) return;
    setSubmittingVouch(true);
    try {
      const vouch = await createVouch(token, profileId, { voucher_name: voucherName, voucher_role: voucherRole });
      setVouches((prev) => [...prev, vouch]);
      setVoucherName("");
    } finally {
      setSubmittingVouch(false);
    }
  }

  if (loading || loadingData) return <p className="p-8">Loading...</p>;
  if (!account || !profile) return null;

  return (
    <div className="max-w-3xl mx-auto px-6 py-10 space-y-8">
      <div className="rounded-2xl border border-border bg-card overflow-hidden">
        <div className="aspect-[16/7] bg-secondary flex items-center justify-center">
          <span className="font-display text-6xl text-primary/30">{profile.name.charAt(0)}</span>
        </div>
        <div className="p-6 space-y-4">
          <div>
            <h1 className="font-display text-3xl">{profile.name}</h1>
            <p className="text-muted-foreground mt-1">
              {[profile.city, profile.denomination, profile.profession].filter(Boolean).join(" · ")}
            </p>
          </div>

          {profile.bio && <p className="leading-relaxed">{profile.bio}</p>}

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
                <p>{profile.gender}</p>
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

        <form onSubmit={handleVouch} className="rounded-2xl border border-border bg-card p-5 space-y-3">
          <p className="text-sm font-medium">Vouch for {profile.name}</p>
          <div className="grid sm:grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label htmlFor="voucherName">Your name</Label>
              <Input id="voucherName" value={voucherName} onChange={(e) => setVoucherName(e.target.value)} required />
            </div>
            <div className="space-y-1">
              <Label htmlFor="voucherRole">Your role</Label>
              <select
                id="voucherRole"
                value={voucherRole}
                onChange={(e) => setVoucherRole(e.target.value)}
                className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
              >
                <option value="pastor">Pastor</option>
                <option value="elder">Elder</option>
                <option value="family_friend">Family friend</option>
                <option value="other">Other</option>
              </select>
            </div>
          </div>
          <Button type="submit" size="sm" className="rounded-full" disabled={submittingVouch}>
            {submittingVouch ? "Submitting..." : "Submit vouch"}
          </Button>
        </form>
      </div>
    </div>
  );
}
"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { ChevronRight, LogOut } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { getMyProfiles, Profile } from "@/lib/profiles";
import { Button } from "@/components/ui/button";

export default function ProfileHubPage() {
  const { account, logout } = useAuth();
  const router = useRouter();
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [loadingProfiles, setLoadingProfiles] = useState(true);

  useEffect(() => {
    if (!account) return;
    getMyProfiles().then(setProfiles).finally(() => setLoadingProfiles(false));
  }, [account]);

  if (!account) return null;

  return (
    <div className="max-w-md mx-auto w-full px-6 py-12 space-y-10">
      <div className="space-y-2">
        <h1 className="font-display text-4xl md:text-5xl">Profile</h1>
        <p className="text-muted-foreground text-base">{account.email ?? account.phone}</p>
      </div>

      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">Your profiles</h2>
          <Link href="/profiles/new" className="text-sm text-primary font-medium">+ New</Link>
        </div>

        {loadingProfiles ? (
          <p className="text-muted-foreground text-sm">Loading...</p>
        ) : profiles.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border p-10 text-center">
            <p className="text-muted-foreground text-sm mb-5">
              {account.account_type === "parent"
                ? "Create a profile for yourself, or on behalf of your child."
                : "Create your profile to start browsing."}
            </p>
            <Link href="/profiles/new">
              <Button size="lg" className="rounded-full">Create a profile</Button>
            </Link>
          </div>
        ) : (
          <div className="space-y-3">
            {profiles.map((p) => (
              <Link
                key={p.id}
                href={`/profiles/${p.id}/edit`}
                className="flex items-center gap-4 rounded-2xl border border-border bg-card p-5"
              >
                <div className="h-12 w-12 rounded-full bg-secondary overflow-hidden flex items-center justify-center shrink-0">
                  {p.photos[0] ? (
                    /* eslint-disable-next-line @next/next/no-img-element */
                    <img src={p.photos[0].thumb_url} alt="" className="w-full h-full object-cover" />
                  ) : (
                    <span className="font-display text-lg text-primary/50">{p.name.charAt(0)}</span>
                  )}
                </div>
                <div className="flex-1">
                  <p className="font-medium">{p.name}</p>
                  <p className="text-xs text-muted-foreground capitalize">
                    {p.profile_type} profile{p.city ? ` · ${p.city}` : ""}
                    {p.status === "draft" ? " · draft" : ""}
                  </p>
                </div>
                <ChevronRight size={18} className="text-muted-foreground" />
              </Link>
            ))}
          </div>
        )}
      </div>

      <div className="space-y-3">
        <h2 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">Account</h2>
        <Link href="/verification" className="flex items-center justify-between rounded-2xl border border-border bg-card p-5">
          <span className="font-medium">Verification</span>
          <ChevronRight size={18} className="text-muted-foreground" />
        </Link>
        <Link href="/subscription" className="flex items-center justify-between rounded-2xl border border-border bg-card p-5">
          <span className="font-medium">Membership</span>
          <ChevronRight size={18} className="text-muted-foreground" />
        </Link>
        <button
          onClick={() => {
            logout();
            router.push("/login");
          }}
          className="w-full flex items-center justify-between rounded-2xl border border-border bg-card p-5 text-destructive"
        >
          <span className="font-medium flex items-center gap-2"><LogOut size={16} /> Log out</span>
        </button>
      </div>
    </div>
  );
}

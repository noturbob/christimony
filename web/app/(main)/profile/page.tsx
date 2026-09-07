"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { ChevronRight, LogOut } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { getMyProfiles, Profile } from "@/lib/profiles";
import { Button } from "@/components/ui/button";

export default function ProfileHubPage() {
  const { account, token, loading, logout } = useAuth();
  const router = useRouter();
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [loadingProfiles, setLoadingProfiles] = useState(true);

  useEffect(() => {
    if (!loading && !account) router.push("/login");
  }, [loading, account, router]);

  useEffect(() => {
    if (token) {
      getMyProfiles(token).then(setProfiles).finally(() => setLoadingProfiles(false));
    }
  }, [token]);

  if (loading) return <p className="p-8">Loading...</p>;
  if (!account) return null;

  return (
    <div className="max-w-md mx-auto px-6 pt-10 pb-6 space-y-8">
      <div>
        <h1 className="font-display text-3xl">Profile</h1>
        <p className="text-muted-foreground mt-1">{account.email}</p>
      </div>

      <div className="space-y-3">
        <div className="flex items-center justify-between">
          <h2 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">Your profiles</h2>
          <Link href="/profiles/new" className="text-sm text-primary font-medium">+ New</Link>
        </div>

        {loadingProfiles ? (
          <p className="text-muted-foreground text-sm">Loading...</p>
        ) : profiles.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border p-8 text-center">
            <p className="text-muted-foreground text-sm mb-4">
              {account.account_type === "parent"
                ? "Create a profile for yourself, or on behalf of your child."
                : "Create your profile to start browsing."}
            </p>
            <Link href="/profiles/new">
              <Button className="rounded-full">Create a profile</Button>
            </Link>
          </div>
        ) : (
          <div className="space-y-2">
            {profiles.map((p) => (
              <Link
                key={p.id}
                href={`/profiles/${p.id}/edit`}
                className="flex items-center gap-4 rounded-2xl border border-border bg-card p-4"
              >
                <div className="h-12 w-12 rounded-full bg-secondary flex items-center justify-center shrink-0">
                  <span className="font-display text-lg text-primary/50">{p.name.charAt(0)}</span>
                </div>
                <div className="flex-1">
                  <p className="font-medium">{p.name}</p>
                  <p className="text-xs text-muted-foreground capitalize">
                    {p.profile_type} profile{p.city ? ` · ${p.city}` : ""}
                  </p>
                </div>
                <ChevronRight size={18} className="text-muted-foreground" />
              </Link>
            ))}
          </div>
        )}
      </div>

      <div className="space-y-2">
        <h2 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">Account</h2>
        <Link href="/verification" className="flex items-center justify-between rounded-2xl border border-border bg-card p-4">
          <span className="font-medium">Verification</span>
          <ChevronRight size={18} className="text-muted-foreground" />
        </Link>
        <Link href="/subscription" className="flex items-center justify-between rounded-2xl border border-border bg-card p-4">
          <span className="font-medium">Membership</span>
          <ChevronRight size={18} className="text-muted-foreground" />
        </Link>
        <button
          onClick={logout}
          className="w-full flex items-center justify-between rounded-2xl border border-border bg-card p-4 text-destructive"
        >
          <span className="font-medium flex items-center gap-2"><LogOut size={16} /> Log out</span>
        </button>
      </div>
    </div>
  );
}
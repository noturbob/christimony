"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth-context";
import { getMyProfiles, Profile } from "@/lib/profiles";
import { Button } from "@/components/ui/button";

export default function DashboardPage() {
  const { account, token, loading } = useAuth();
  const router = useRouter();
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [loadingProfiles, setLoadingProfiles] = useState(true);

  useEffect(() => {
    if (!loading && !account) router.push("/login");
  }, [loading, account, router]);

  useEffect(() => {
    if (token) {
      getMyProfiles(token)
        .then(setProfiles)
        .finally(() => setLoadingProfiles(false));
    }
  }, [token]);

  if (loading) return <p className="p-8">Loading...</p>;
  if (!account) return null;

  return (
    <div className="max-w-5xl mx-auto px-6 py-10 space-y-10">
      <div>
        <h1 className="font-display text-3xl">Welcome, {account.email}</h1>
        <p className="text-muted-foreground mt-1 capitalize">{account.account_type} account</p>
      </div>

      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="font-display text-xl">Your profiles</h2>
          <Link href="/profiles/new">
            <Button className="rounded-full">+ New profile</Button>
          </Link>
        </div>

        {loadingProfiles ? (
          <p className="text-muted-foreground">Loading...</p>
        ) : profiles.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border p-10 text-center">
            <p className="text-muted-foreground">
              {account.account_type === "parent"
                ? "Create a profile for yourself, or on behalf of your child, to get started."
                : "Create your profile to start browsing and matching."}
            </p>
          </div>
        ) : (
          <div className="grid gap-4 sm:grid-cols-2">
            {profiles.map((p) => (
              <div key={p.id} className="rounded-2xl border border-border bg-card p-5 flex items-center justify-between gap-4">
                <div className="flex items-center gap-4">
                  <div className="h-14 w-14 rounded-full bg-secondary flex items-center justify-center shrink-0">
                    <span className="font-display text-xl text-primary/50">{p.name.charAt(0)}</span>
                  </div>
                  <div>
                    <p className="font-medium">{p.name}</p>
                    <p className="text-sm text-muted-foreground capitalize">{p.profile_type} profile{p.city ? ` · ${p.city}` : ""}</p>
                  </div>
                </div>
                <Link href={`/profiles/${p.id}/edit`}>
                  <Button variant="outline" size="sm" className="rounded-full shrink-0">Edit</Button>
                </Link>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { useAuth } from "@/lib/auth-context";
import { getFeed, getMyProfiles, Profile } from "@/lib/profiles";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export default function FeedPage() {
  const { account, token, loading } = useAuth();
  const router = useRouter();

  const [myProfiles, setMyProfiles] = useState<Profile[]>([]);
  const [activeProfileId, setActiveProfileId] = useState<number | null>(null);
  const [feed, setFeed] = useState<Profile[]>([]);
  const [cityFilter, setCityFilter] = useState("");
  const [loadingFeed, setLoadingFeed] = useState(true);

  useEffect(() => {
    if (!loading && !account) router.push("/login");
  }, [loading, account, router]);

  useEffect(() => {
    if (!token) return;
    getMyProfiles(token).then((profiles) => {
      setMyProfiles(profiles);
      if (profiles.length > 0) setActiveProfileId(profiles[0].id);
    });
  }, [token]);

  async function loadFeed() {
    if (!token) return;
    setLoadingFeed(true);
    try {
      const results = await getFeed(token, cityFilter ? { city: cityFilter } : undefined);
      setFeed(results);
    } finally {
      setLoadingFeed(false);
    }
  }

  useEffect(() => {
    if (token) loadFeed();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [token]);

  if (loading) return <p className="p-8">Loading...</p>;
  if (!account) return null;

  if (myProfiles.length === 0) {
    return (
      <div className="flex items-center justify-center p-8 text-center min-h-[60vh]">
        <div className="max-w-sm space-y-4">
          <h1 className="font-display text-2xl">One step first</h1>
          <p className="text-muted-foreground">Create a profile before you start browsing.</p>
          <Link href="/profiles/new">
            <Button className="rounded-full">Create a profile</Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-5xl mx-auto px-6 py-10 space-y-8">
      <div className="flex flex-wrap items-end justify-between gap-4">
        <div>
          <h1 className="font-display text-3xl">Browse</h1>
          <p className="text-muted-foreground mt-1">People seeking the same thing you are.</p>
        </div>

        <div className="flex items-end gap-3">
          {myProfiles.length > 1 && (
            <div>
              <label className="text-xs text-muted-foreground block mb-1">Browsing as</label>
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
          <div className="flex gap-2">
            <Input
              placeholder="Filter by city"
              value={cityFilter}
              onChange={(e) => setCityFilter(e.target.value)}
              className="rounded-full"
            />
            <Button onClick={loadFeed} variant="outline" className="rounded-full">Filter</Button>
          </div>
        </div>
      </div>

      {loadingFeed ? (
        <p className="text-muted-foreground">Loading...</p>
      ) : feed.length === 0 ? (
        <p className="text-muted-foreground">No profiles found.</p>
      ) : (
        <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
          {feed.map((p) => (
            <Link
              key={p.id}
              href={`/profiles/${p.id}${activeProfileId ? `?as=${activeProfileId}` : ""}`}
              className="rounded-2xl border border-border bg-card overflow-hidden flex flex-col hover:shadow-md transition-shadow"
            >
              <div className="aspect-[4/5] bg-secondary flex items-center justify-center">
                <span className="font-display text-5xl text-primary/30">{p.name.charAt(0)}</span>
              </div>
              <div className="p-5 flex-1 flex flex-col gap-2">
                <h3 className="font-display text-xl">{p.name}</h3>
                <p className="text-sm text-muted-foreground">
                  {[p.city, p.denomination].filter(Boolean).join(" · ")}
                </p>
                {p.bio && <p className="text-sm line-clamp-2">{p.bio}</p>}
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
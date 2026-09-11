"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { X, Heart } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { getFeed, getMyProfiles, sendInterest, Profile } from "@/lib/profiles";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PhotoCarousel } from "@/components/photo-carousel";

export default function DiscoverPage() {
  const { account } = useAuth();

  const [myProfiles, setMyProfiles] = useState<Profile[]>([]);
  const [activeProfileId, setActiveProfileId] = useState<number | null>(null);
  const [queue, setQueue] = useState<Profile[]>([]);
  const [index, setIndex] = useState(0);
  const [cityFilter, setCityFilter] = useState("");
  const [showFilter, setShowFilter] = useState(false);
  const [loadingFeed, setLoadingFeed] = useState(true);
  const [acting, setActing] = useState(false);
  const [matchOverlay, setMatchOverlay] = useState<Profile | null>(null);

  useEffect(() => {
    if (!account) return;
    getMyProfiles().then((profiles) => {
      setMyProfiles(profiles);
      if (profiles.length > 0) setActiveProfileId(profiles[0].id);
    });
  }, [account]);

  async function loadFeed() {
    setLoadingFeed(true);
    try {
      const page = await getFeed(cityFilter ? { city: cityFilter } : undefined);
      setQueue(page.profiles);
      setIndex(0);
    } finally {
      setLoadingFeed(false);
    }
  }

  useEffect(() => {
    // eslint-disable-next-line react-hooks/set-state-in-effect -- loadFeed sets loading state before its fetch; this is the intentional initial-load-on-mount pattern
    if (account) loadFeed();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [account]);

  const current = queue[index];

  async function handleLike() {
    if (!activeProfileId || !current || acting) return;
    setActing(true);
    try {
      const result = await sendInterest(activeProfileId, current.id);
      if (result.match) {
        setMatchOverlay(current);
      } else {
        setIndex((i) => i + 1);
      }
    } catch {
      setIndex((i) => i + 1);
    } finally {
      setActing(false);
    }
  }

  function handlePass() {
    if (acting) return;
    setIndex((i) => i + 1);
  }

  function closeOverlay() {
    setMatchOverlay(null);
    setIndex((i) => i + 1);
  }

  if (!account) return null;

  if (myProfiles.length === 0) {
    return (
      <div className="flex items-center justify-center min-h-[70vh] px-8 text-center">
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
    <div className="max-w-md mx-auto px-4 pt-8">
      <div className="flex items-center justify-between mb-4">
        <h1 className="font-display text-2xl">Discover</h1>
        <div className="flex items-center gap-2">
          {myProfiles.length > 1 && (
            <select
              value={activeProfileId ?? ""}
              onChange={(e) => setActiveProfileId(Number(e.target.value))}
              className="rounded-full border border-input bg-background px-3 py-1.5 text-xs"
            >
              {myProfiles.map((p) => (
                <option key={p.id} value={p.id}>{p.name}</option>
              ))}
            </select>
          )}
          <button
            onClick={() => setShowFilter((s) => !s)}
            className="text-xs text-muted-foreground underline underline-offset-4"
          >
            Filter
          </button>
        </div>
      </div>

      {showFilter && (
        <div className="flex gap-2 mb-4">
          <Input
            placeholder="Filter by city"
            value={cityFilter}
            onChange={(e) => setCityFilter(e.target.value)}
            className="rounded-full"
          />
          <Button onClick={loadFeed} variant="outline" className="rounded-full shrink-0">Apply</Button>
        </div>
      )}

      {loadingFeed ? (
        <p className="text-muted-foreground text-center py-20">Loading...</p>
      ) : !current ? (
        <div className="text-center py-20 space-y-3">
          <p className="font-display text-xl">That&apos;s everyone for now</p>
          <p className="text-muted-foreground text-sm">Check back soon, or try a different filter.</p>
        </div>
      ) : (
        <div className="rounded-3xl border border-border bg-card overflow-hidden shadow-sm">
          <PhotoCarousel photos={current.photos} fallbackLetter={current.name.charAt(0)} />
          <div className="p-6 space-y-4">
            <div>
              <h2 className="font-display text-2xl">
                {current.name}
                {current.age ? <span className="text-muted-foreground font-normal">, {current.age}</span> : null}
              </h2>
              <p className="text-muted-foreground text-sm mt-1">
                {[current.city, current.denomination, current.profession].filter(Boolean).join(" · ")}
              </p>
            </div>

            {current.prompts.length > 0 && (
              <div className="rounded-2xl bg-secondary/40 p-4">
                <p className="text-xs text-muted-foreground uppercase tracking-wide mb-1">{current.prompts[0].question}</p>
                <p className="text-sm leading-relaxed font-display text-lg">{current.prompts[0].answer}</p>
              </div>
            )}

            {current.bio && (
              <div className="rounded-2xl bg-secondary/40 p-4">
                <p className="text-xs text-muted-foreground uppercase tracking-wide mb-1">About</p>
                <p className="text-sm leading-relaxed">{current.bio}</p>
              </div>
            )}

            {current.education && (
              <div className="rounded-2xl bg-secondary/40 p-4">
                <p className="text-xs text-muted-foreground uppercase tracking-wide mb-1">Education</p>
                <p className="text-sm">{current.education}</p>
              </div>
            )}
          </div>
        </div>
      )}

      {current && (
        <div className="flex items-center justify-center gap-6 py-8">
          <button
            onClick={handlePass}
            disabled={acting}
            className="h-16 w-16 rounded-full border border-border bg-card flex items-center justify-center hover:bg-secondary transition-colors"
          >
            <X size={26} className="text-muted-foreground" />
          </button>
          <button
            onClick={handleLike}
            disabled={acting}
            className="h-16 w-16 rounded-full bg-primary flex items-center justify-center hover:opacity-90 transition-opacity"
          >
            <Heart size={26} className="text-primary-foreground" fill="currentColor" />
          </button>
        </div>
      )}

      {matchOverlay && (
        <div className="fixed inset-0 z-30 bg-primary text-primary-foreground flex flex-col items-center justify-center px-8 text-center gap-6">
          <Heart size={56} fill="currentColor" />
          <h2 className="font-display text-4xl">It&apos;s a match!</h2>
          <p className="opacity-80">You and {matchOverlay.name} liked each other.</p>
          <div className="flex flex-col gap-3 w-full max-w-xs mt-4">
            <Link href="/matches" onClick={closeOverlay}>
              <Button size="lg" variant="secondary" className="rounded-full w-full">See your matches</Button>
            </Link>
            <button onClick={closeOverlay} className="text-sm opacity-70 underline underline-offset-4">
              Keep browsing
            </button>
          </div>
        </div>
      )}
    </div>
  );
}

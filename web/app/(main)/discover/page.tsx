"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { AnimatePresence, motion } from "motion/react";
import { X, Heart } from "lucide-react";
import { useAuth } from "@/lib/auth-context";
import { getFeed, getMyProfiles, sendInterest, Profile } from "@/lib/profiles";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { PhotoCarousel } from "@/components/photo-carousel";
import { SkeletonCard } from "@/components/skeleton-card";
import { SwipeCard } from "@/components/swipe-card";

function ProfileCardBody({ profile }: { profile: Profile }) {
  return (
    <>
      <PhotoCarousel photos={profile.photos} fallbackLetter={profile.name.charAt(0)} />
      <div className="p-6 space-y-4">
        <div>
          <h2 className="font-display text-2xl">
            {profile.name}
            {profile.age ? <span className="text-muted-foreground font-normal">, {profile.age}</span> : null}
          </h2>
          <p className="text-muted-foreground text-sm mt-1">
            {[profile.city, profile.denomination, profile.profession].filter(Boolean).join(" · ")}
          </p>
        </div>

        {profile.prompts.length > 0 && (
          <div className="rounded-2xl bg-secondary/40 p-4">
            <p className="text-xs text-muted-foreground uppercase tracking-wide mb-1">{profile.prompts[0].question}</p>
            <p className="text-sm leading-relaxed font-display text-lg">{profile.prompts[0].answer}</p>
          </div>
        )}

        {profile.bio && (
          <div className="rounded-2xl bg-secondary/40 p-4">
            <p className="text-xs text-muted-foreground uppercase tracking-wide mb-1">About</p>
            <p className="text-sm leading-relaxed">{profile.bio}</p>
          </div>
        )}

        {profile.education && (
          <div className="rounded-2xl bg-secondary/40 p-4">
            <p className="text-xs text-muted-foreground uppercase tracking-wide mb-1">Education</p>
            <p className="text-sm">{profile.education}</p>
          </div>
        )}
      </div>
    </>
  );
}

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
  const [canUndo, setCanUndo] = useState(false);

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
  const next = queue[index + 1];

  async function performLike() {
    if (!activeProfileId || !current || acting) return;
    setActing(true);
    setCanUndo(false);
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

  function performPass() {
    if (acting) return;
    setIndex((i) => i + 1);
    // Passing never calls the API (there's no "unlike" endpoint to undo a
    // like against), so only a pass can be safely undone.
    setCanUndo(true);
  }

  function handleUndo() {
    if (!canUndo || index === 0) return;
    setIndex((i) => i - 1);
    setCanUndo(false);
  }

  function closeOverlay() {
    setMatchOverlay(null);
    setIndex((i) => i + 1);
  }

  if (!account) return null;

  if (myProfiles.length === 0) {
    return (
      <div className="flex items-center justify-center min-h-[70vh] px-8 text-center">
        <div className="max-w-sm space-y-5">
          <h1 className="font-display text-3xl">One step first</h1>
          <p className="text-muted-foreground text-base">Create a profile before you start browsing.</p>
          <Link href="/profiles/new">
            <Button size="lg" className="rounded-full">Create a profile</Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="max-w-md mx-auto w-full px-4 py-10">
      <div className="flex items-center justify-between mb-6">
        <h1 className="font-display text-4xl md:text-5xl">Discover</h1>
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
        <SkeletonCard />
      ) : !current ? (
        <div className="text-center py-20 space-y-3">
          <p className="font-display text-2xl">That&apos;s everyone for now</p>
          <p className="text-muted-foreground text-base">Check back soon, or try a different filter.</p>
        </div>
      ) : (
        // A fixed frame instead of one that grows with content -- that way
        // the like/pass buttons below always sit in the same place, no
        // matter how much bio/prompt/education text a profile has. Each
        // card scrolls its own content internally (see SwipeCard) rather
        // than stretching the page.
        //
        // Both cards split "transform" (position/scale) from "rounded
        // corners + clipping" across two nested elements -- Chromium
        // doesn't reliably clip rounded corners on a transformed element,
        // so the outer div here only handles the scale/offset, and the
        // inner one (no transform of its own) does the actual rounding.
        <div className="relative h-[70vh] min-h-[460px] max-h-[640px]">
          {next && (
            <div className="absolute inset-0 scale-[0.96] translate-y-2">
              <div className="h-full rounded-3xl border border-border bg-card shadow-sm opacity-70 overflow-hidden">
                <ProfileCardBody profile={next} />
              </div>
            </div>
          )}
          <AnimatePresence>
            <SwipeCard
              key={current.id}
              onSwiped={(direction) => (direction === "like" ? performLike() : performPass())}
              disabled={acting}
              className="absolute inset-0 rounded-3xl border border-border bg-card shadow-sm cursor-grab active:cursor-grabbing"
            >
              <ProfileCardBody profile={current} />
            </SwipeCard>
          </AnimatePresence>
        </div>
      )}

      {current && (
        <div className="flex items-center justify-center gap-4 py-8">
          {canUndo && (
            <motion.button
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              onClick={handleUndo}
              className="h-11 w-11 rounded-full border border-border bg-card flex items-center justify-center text-muted-foreground text-xs font-medium"
              aria-label="Undo"
            >
              ↺
            </motion.button>
          )}
          <button
            onClick={performPass}
            disabled={acting}
            className="h-16 w-16 rounded-full border border-border bg-card flex items-center justify-center hover:bg-secondary transition-colors"
          >
            <X size={26} className="text-muted-foreground" />
          </button>
          <button
            onClick={performLike}
            disabled={acting}
            className="h-16 w-16 rounded-full bg-primary flex items-center justify-center hover:opacity-90 transition-opacity"
          >
            <Heart size={26} className="text-primary-foreground" fill="currentColor" />
          </button>
        </div>
      )}

      {matchOverlay && (
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          className="fixed inset-0 z-30 bg-primary text-primary-foreground flex flex-col items-center justify-center px-8 text-center gap-6"
        >
          <motion.div
            initial={{ scale: 0.6, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            transition={{ type: "spring", stiffness: 260, damping: 20 }}
          >
            <Heart size={56} fill="currentColor" />
          </motion.div>
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
        </motion.div>
      )}
    </div>
  );
}

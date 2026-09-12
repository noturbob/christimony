"use client";

import { useRef } from "react";
import { useGSAP } from "@gsap/react";
import { ensureGsapRegistered, gsap } from "@/lib/gsap";
import { DENOMINATIONS } from "./shared";

// Seamless infinite marquee: two identical copies of the list sit side
// by side and the whole track scrolls left by exactly one copy's width,
// then resets to 0 -- imperceptible because the two copies are pixel
// identical at that point.
export function Marquee() {
  const trackRef = useRef<HTMLDivElement>(null);

  useGSAP(
    () => {
      if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
      ensureGsapRegistered();

      const track = trackRef.current;
      if (!track) return;

      const width = track.scrollWidth / 2;
      const tween = gsap.to(track, {
        x: -width,
        duration: 32,
        ease: "none",
        repeat: -1,
      });

      const onEnter = () => tween.pause();
      const onLeave = () => {
        if (document.visibilityState === "visible") tween.play();
      };
      track.addEventListener("mouseenter", onEnter);
      track.addEventListener("mouseleave", onLeave);

      // The tween runs on a 32s loop that never naturally settles, so
      // without this it keeps ticking (and asking the compositor for a
      // frame) for as long as the page is open, even scrolled far out of
      // view or backgrounded -- pure overhead competing with whatever
      // scroll/animation work is actually on screen. Pause it whenever
      // it's not visible and resume only if the mouse isn't currently
      // hovering it.
      const io = new IntersectionObserver(([entry]) => {
        if (entry.isIntersecting) {
          if (document.visibilityState === "visible") tween.play();
        } else {
          tween.pause();
        }
      });
      io.observe(track);

      const onVisibilityChange = () => {
        if (document.visibilityState === "visible") {
          const rect = track.getBoundingClientRect();
          if (rect.bottom > 0 && rect.top < window.innerHeight) tween.play();
        } else {
          tween.pause();
        }
      };
      document.addEventListener("visibilitychange", onVisibilityChange);

      return () => {
        track.removeEventListener("mouseenter", onEnter);
        track.removeEventListener("mouseleave", onLeave);
        document.removeEventListener("visibilitychange", onVisibilityChange);
        io.disconnect();
      };
    },
    { scope: trackRef }
  );

  const items = [...DENOMINATIONS, ...DENOMINATIONS];

  return (
    <div data-testid="denomination-marquee" className="overflow-hidden border-y border-[#e2dacb] bg-[#faf6ef] py-6">
      <div ref={trackRef} className="flex w-max items-center gap-10 whitespace-nowrap">
        {items.map((name, i) => (
          <span key={`${name}-${i}`} className="flex items-center gap-10 text-sm font-medium text-[#1b1b18]/40">
            {name}
            <span className="text-[#7a2e2e]/40">✦</span>
          </span>
        ))}
      </div>
    </div>
  );
}

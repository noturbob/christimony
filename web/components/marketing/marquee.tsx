"use client";

import { useRef } from "react";
import { useGSAP } from "@gsap/react";
import { cancelIdle, ensureGsapRegistered, gsap, scheduleIdle, ScrollTrigger } from "@/lib/gsap";
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

      let tween: gsap.core.Tween | undefined;
      let io: IntersectionObserver | undefined;
      let onEnter: (() => void) | undefined;
      let onLeave: (() => void) | undefined;
      let onVisibilityChange: (() => void) | undefined;
      let velocity: ScrollTrigger | undefined;

      // Reading scrollWidth forces layout, and building the tween is one
      // more thing competing for the main thread during the critical
      // first paint -- defer it to idle instead of piling it on top of
      // hydration and the preloader's own intro.
      const idle = scheduleIdle(() => {
        const width = track.scrollWidth / 2;
        tween = gsap.to(track, {
          x: -width,
          duration: 32,
          ease: "none",
          repeat: -1,
        });
        // ponytail: start 100 loops in so a negative timeScale (scrolling up)
        // has room to run backwards; ~50 min of reverse before it bottoms out.
        tween.totalTime(tween.duration() * 100);

        // Scroll velocity pushes the marquee along -- and scrolling up runs it
        // backwards. Pointer-fine only, same reasoning as the other scrubs.
        if (window.matchMedia("(pointer: fine)").matches) {
          velocity = ScrollTrigger.create({
            trigger: track,
            start: "top bottom",
            end: "bottom top",
            onUpdate: (self) => {
              const boost = gsap.utils.clamp(1, 7, 1 + Math.abs(self.getVelocity()) / 350);
              gsap.to(tween!, {
                timeScale: self.direction * boost,
                duration: 0.25,
                overwrite: true,
                onComplete: () => void gsap.to(tween!, { timeScale: self.direction, duration: 1, ease: "power2.out" }),
              });
            },
          });
        }

        onEnter = () => tween?.pause();
        onLeave = () => {
          if (document.visibilityState === "visible") tween?.play();
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
        io = new IntersectionObserver(([entry]) => {
          if (entry.isIntersecting) {
            if (document.visibilityState === "visible") tween?.play();
          } else {
            tween?.pause();
          }
        });
        io.observe(track);

        onVisibilityChange = () => {
          if (document.visibilityState === "visible") {
            const rect = track.getBoundingClientRect();
            if (rect.bottom > 0 && rect.top < window.innerHeight) tween?.play();
          } else {
            tween?.pause();
          }
        };
        document.addEventListener("visibilitychange", onVisibilityChange);
      });

      return () => {
        cancelIdle(idle);
        if (onEnter) track.removeEventListener("mouseenter", onEnter);
        if (onLeave) track.removeEventListener("mouseleave", onLeave);
        if (onVisibilityChange) document.removeEventListener("visibilitychange", onVisibilityChange);
        io?.disconnect();
        velocity?.kill();
        tween?.kill();
      };
    },
    { scope: trackRef }
  );

  const items = [...DENOMINATIONS, ...DENOMINATIONS];

  return (
    <div data-testid="denomination-marquee" className="overflow-hidden border-y border-[var(--line)] py-7 lg:py-9">
      <div ref={trackRef} className="flex w-max items-center gap-10 whitespace-nowrap">
        {items.map((name, i) => (
          <span
            key={`${name}-${i}`}
            className="flex items-center gap-10 text-[34px] font-medium tracking-[-0.03em] text-[var(--chalk)]/35 transition-colors duration-300 hover:text-[var(--chalk)] lg:text-[44px]"
          >
            {name}
            <span className="text-[0.5em] text-[var(--sage)]">✦</span>
          </span>
        ))}
      </div>
    </div>
  );
}

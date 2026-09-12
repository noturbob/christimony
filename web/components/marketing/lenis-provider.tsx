"use client";

import { useEffect } from "react";
import Lenis from "lenis";
import { gsap, ScrollTrigger, ensureGsapRegistered } from "@/lib/gsap";

// Drives smooth scroll for the whole marketing page and keeps
// ScrollTrigger's internal scroll position in sync with it -- without
// this, ScrollTrigger measures the native scrollTop, which Lenis
// intercepts, and every pinned/scrubbed animation on the page drifts out
// of sync with what's on screen.
export function LenisProvider({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    ensureGsapRegistered();

    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      return;
    }

    // Lenis only smooths wheel input: `syncTouch` defaults to false (verified
    // in lenis 1.3.26's constructor), so on a touch device it hands the
    // gesture straight back to the platform's own momentum scrolling and
    // changes nothing the user can see. What it still costs there is real:
    // a gsap.ticker rAF that keeps the main thread waking every frame for
    // the life of the page, a composedPath() walk plus an ancestor scan on
    // every touchmove, and a second ScrollTrigger.update() per scroll event
    // on top of the one ScrollTrigger already does for itself. All of that
    // lands on the one thread a phone also needs for the scroll it's doing.
    if (window.matchMedia("(pointer: coarse)").matches) {
      return;
    }

    const lenis = new Lenis({ duration: 1.1, smoothWheel: true });
    lenis.on("scroll", ScrollTrigger.update);

    function raf(time: number) {
      // gsap.ticker reports elapsed time in seconds; Lenis expects
      // a millisecond timestamp like requestAnimationFrame provides.
      lenis.raf(time * 1000);
    }
    gsap.ticker.add(raf);
    gsap.ticker.lagSmoothing(0);

    return () => {
      gsap.ticker.remove(raf);
      // Back to GSAP's defaults -- lagSmoothing is disabled only because
      // Lenis needs the true elapsed time; leaving it off after this
      // provider unmounts would let every other animation in the app jump
      // forward after a main-thread stall instead of easing through it.
      gsap.ticker.lagSmoothing(500, 33);
      lenis.destroy();
    };
  }, []);

  return <>{children}</>;
}

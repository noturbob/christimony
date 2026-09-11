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
      lenis.destroy();
    };
  }, []);

  return <>{children}</>;
}

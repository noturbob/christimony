"use client";

import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { SplitText } from "gsap/SplitText";

let registered = false;

// Registers GSAP plugins exactly once, client-side only. Every marketing
// component that needs ScrollTrigger/SplitText should call this at the
// top of its effect before using them -- calling it more than once is a
// no-op (gsap.registerPlugin is itself idempotent), this just avoids the
// import cost on routes that never render marketing content.
export function ensureGsapRegistered() {
  if (registered) return;
  gsap.registerPlugin(ScrollTrigger, SplitText);
  registered = true;
}

// Marketing sections each do some amount of layout-thrashing setup on
// mount (SplitText measures every line/word, ScrollTrigger reads trigger
// positions). Left to run synchronously, every section's setup lands in
// the same tick as hydration and the Preloader's own intro animation,
// which is fine on fast engines but visibly stalls slower ones (iOS
// Safari's JavaScriptCore in particular) -- the preloader's ticker
// starves, its scroll-lock outlives its own animation, and iOS's chrome
// (held open the whole time, since it can only collapse on a real scroll
// gesture) snaps shut all at once the moment the lock finally lifts.
// Deferring this work to idle time instead lets the browser paint and
// finish the preloader first, and naturally spreads each section's setup
// across separate idle slices instead of one long blocking task.
export function scheduleIdle(callback: () => void): number {
  if (typeof window.requestIdleCallback === "function") {
    return window.requestIdleCallback(callback);
  }
  return window.setTimeout(callback, 1) as unknown as number;
}

export function cancelIdle(handle: number) {
  if (typeof window.cancelIdleCallback === "function") {
    window.cancelIdleCallback(handle);
  } else {
    window.clearTimeout(handle);
  }
}

export { gsap, ScrollTrigger, SplitText };

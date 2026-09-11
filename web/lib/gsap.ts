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

export { gsap, ScrollTrigger, SplitText };

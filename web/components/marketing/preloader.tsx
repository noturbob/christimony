"use client";

import { useEffect, useRef, useState } from "react";
import { gsap } from "@/lib/gsap";

const SESSION_KEY = "christimony-preloader-shown";

// Renders nothing during SSR (avoids a hydration mismatch from reading
// sessionStorage) and flips on in an effect if this session hasn't seen
// it yet -- once per browser session, not once per page load.
export function Preloader() {
  const [visible, setVisible] = useState(false);
  const rootRef = useRef<HTMLDivElement>(null);
  const counterRef = useRef<HTMLSpanElement>(null);

  useEffect(() => {
    if (sessionStorage.getItem(SESSION_KEY)) return;
    // eslint-disable-next-line react-hooks/set-state-in-effect -- one-time read of an external source (sessionStorage) that can't happen during SSR/render
    setVisible(true);
  }, []);

  useEffect(() => {
    if (!visible) return;
    sessionStorage.setItem(SESSION_KEY, "1");

    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      // eslint-disable-next-line react-hooks/set-state-in-effect -- bailing out of the animation entirely based on an external media query
      setVisible(false);
      return;
    }

    document.body.style.overflow = "hidden";

    const counter = { value: 0 };
    const tl = gsap.timeline({
      onComplete: () => {
        document.body.style.overflow = "";
        setVisible(false);
      },
    });

    tl.to(counter, {
      value: 100,
      duration: 1.1,
      ease: "power2.inOut",
      onUpdate: () => {
        if (counterRef.current) counterRef.current.textContent = String(Math.round(counter.value));
      },
    }).to(rootRef.current, { yPercent: -100, duration: 0.7, ease: "power4.inOut" }, "+=0.1");

    return () => {
      document.body.style.overflow = "";
      tl.kill();
    };
  }, [visible]);

  if (!visible) return null;

  return (
    <div
      ref={rootRef}
      className="fixed inset-0 z-[100] flex items-center justify-center bg-[#24463b] text-[#faf6ef]"
    >
      <div className="flex items-center gap-4">
        <span className="font-display text-2xl tracking-tight">Christimony</span>
        <span className="font-mono text-sm tabular-nums opacity-60">
          <span ref={counterRef}>0</span>%
        </span>
      </div>
    </div>
  );
}

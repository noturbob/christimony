"use client";

import { useRef } from "react";
import { useGSAP } from "@gsap/react";
import { ensureGsapRegistered, gsap, SplitText } from "@/lib/gsap";
import { DiamondGlyph } from "../icons";

export function QuoteSection() {
  const quoteRef = useRef<HTMLQuoteElement>(null);

  useGSAP(
    () => {
      if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
      ensureGsapRegistered();

      const split = SplitText.create(quoteRef.current, { type: "words" });

      gsap.set(split.words, { opacity: 0.15 });
      gsap.to(split.words, {
        opacity: 1,
        stagger: 0.06,
        ease: "none",
        scrollTrigger: {
          trigger: quoteRef.current,
          start: "top 75%",
          end: "bottom 45%",
          scrub: 0.4,
        },
      });

      return () => split.revert();
    },
    { scope: quoteRef }
  );

  return (
    <section data-testid="denomination-quote-section" className="border-y border-[#e2dacb] bg-[#e2dacb]/45 px-5 py-24 text-center lg:py-36">
      <div className="mx-auto max-w-[980px]">
        <DiamondGlyph data-testid="quote-sparkle-icon" className="mx-auto mb-7 size-3.5 text-[#7a2e2e]" />

        <blockquote
          ref={quoteRef}
          data-testid="denomination-quote"
          className="font-heading text-[clamp(2.5rem,5.1vw,5rem)] leading-[0.98] tracking-[-0.06em]"
        >
          &quot;Your denomination is not a footnote. It can be part of the <em className="font-normal text-[#7a2e2e]">foundation.</em>&quot;
        </blockquote>

        <p data-testid="denomination-quote-caption" className="mt-7 text-xs font-semibold uppercase tracking-[0.2em] text-[#1b1b18]/50">
          Catholic · Orthodox · Pentecostal · Baptist · and more
        </p>
      </div>
    </section>
  );
}

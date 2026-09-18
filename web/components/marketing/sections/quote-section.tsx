"use client";

import { useRef } from "react";
import { useGSAP } from "@gsap/react";
import { cancelIdle, ensureGsapRegistered, gsap, scheduleIdle, SplitText } from "@/lib/gsap";
import { DiamondGlyph } from "../icons";

export function QuoteSection() {
  const quoteRef = useRef<HTMLQuoteElement>(null);

  useGSAP(
    () => {
      if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
      ensureGsapRegistered();

      let split: ReturnType<typeof SplitText.create> | undefined;
      const idle = scheduleIdle(() => {
        split = SplitText.create(quoteRef.current, { type: "words" });

        gsap.set(split.words, { opacity: 0.12 });
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
      });

      return () => {
        cancelIdle(idle);
        split?.revert();
      };
    },
    { scope: quoteRef }
  );

  return (
    <section data-testid="denomination-quote-section" className="border-y border-[var(--line)] px-5 py-28 lg:py-44">
      <div className="mx-auto max-w-[1216px]">
        <DiamondGlyph data-testid="quote-sparkle-icon" className="mb-8 size-4 text-[var(--gold)]" />

        <blockquote
          ref={quoteRef}
          data-testid="denomination-quote"
          className="text-[clamp(2.5rem,6.6vw,6.3rem)] font-semibold leading-[1] tracking-[-0.045em]"
        >
          &ldquo;Your denomination is not a footnote. It can be part of the{" "}
          <em className="serif-italic text-[var(--gold)]">foundation.</em>&rdquo;
        </blockquote>

        <p data-testid="denomination-quote-caption" className="mt-10 text-[16px] text-[var(--chalk-50)] sm:text-[19px]">
          Catholic · Orthodox · Pentecostal · Baptist · and more
        </p>
      </div>
    </section>
  );
}

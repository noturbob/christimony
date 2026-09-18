"use client";

import { useRef } from "react";
import Link from "next/link";
import { useGSAP } from "@gsap/react";
import { cancelIdle, ensureGsapRegistered, gsap, scheduleIdle, SplitText } from "@/lib/gsap";
import { SectionEyebrow } from "../shared";
import { ArrowGlyph } from "../icons";
import { PixelPortrait } from "../pixel-portrait";

const LINES = ["Marriage,", "sought with", "intention."];

export function HeroSection() {
  const heroRef = useRef<HTMLElement>(null);
  const headlineRef = useRef<HTMLHeadingElement>(null);

  useGSAP(
    () => {
      // Releases the CSS entrance on everything but the headline (see
      // `.hero-intro` in globals.css). useGSAP runs in a layout effect, so
      // this lands before the first hydrated paint.
      if (heroRef.current) heroRef.current.dataset.heroIntro = "ready";

      if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
      ensureGsapRegistered();

      const q = gsap.utils.selector(heroRef);
      const mm = gsap.matchMedia();
      const splits: ReturnType<typeof SplitText.create>[] = [];

      // The lines are explicit (one per span), so only chars need splitting;
      // the per-line `overflow-hidden` span is the mask.
      q(".hero-line-text").forEach((el) => splits.push(SplitText.create(el, { type: "chars" })));
      const chars = splits.flatMap((s) => s.chars);

      gsap
        .timeline({ delay: 0.25 })
        .fromTo(chars, { yPercent: 110 }, { yPercent: 0, duration: 1.1, ease: "expo.out", stagger: 0.022 });

      // The headline lines sliding apart on scroll is pointer-fine only: extra per-frame scroll work is
      // a cost a phone pays on the same thread it needs for the scroll.
      const idle = scheduleIdle(() => {
        mm.add("(pointer: fine)", () => {
          const tl = gsap.timeline({
            defaults: { ease: "none" },
            scrollTrigger: { trigger: heroRef.current, start: "top top", end: "bottom top", scrub: true },
          });
          q(".hero-line").forEach((line, i) => tl.to(line, { xPercent: i % 2 ? 12 : -12 }, 0));
          return () => tl.scrollTrigger?.kill();
        });
      });

      return () => {
        cancelIdle(idle);
        mm.revert();
        splits.forEach((s) => s.revert());
      };
    },
    { scope: heroRef }
  );

  return (
    <section
      ref={heroRef}
      data-testid="hero-section"
      className="relative isolate flex min-h-dvh flex-col justify-end overflow-hidden pb-10 pt-32 lg:pb-14"
    >
      {/* Pixel-art couple on the right, opposite the headline. Desktop only:
          a phone has no room beside the text for it. */}
      <PixelPortrait className="absolute right-[3vw] top-[12vh] -z-10 hidden h-[72vh] w-[46vw] items-start justify-end lg:flex" />

      <div className="hero-intro px-5 lg:px-8">
        <SectionEyebrow>For the seriously hopeful</SectionEyebrow>
      </div>

      {/* No max-width container on purpose: the display type runs to the
          viewport edge. */}
      <h1
        ref={headlineRef}
        data-testid="hero-headline"
        aria-label="Marriage, sought with intention. Not swiped past."
        className="px-4 text-[clamp(3rem,min(11vw,19vh),14rem)] font-semibold leading-[0.9] tracking-[-0.045em] lg:px-6"
      >
        {LINES.map((line) => (
          <span key={line} aria-hidden className="hero-line block overflow-hidden whitespace-nowrap">
            <span className="hero-line-text inline-block">{line}</span>
          </span>
        ))}
        <span
          aria-hidden
          className="hero-intro serif-italic text-gradient-warm mt-[0.1em] block text-[0.36em] leading-[1.1] [animation-delay:900ms]"
        >
          — not swiped past.
        </span>
      </h1>

      <div className="mt-12 flex flex-col gap-8 px-5 lg:mt-16 lg:flex-row lg:items-end lg:justify-between lg:px-8">
        <p
          data-testid="hero-subheadline"
          className="hero-intro max-w-[520px] text-[19px] leading-[1.38] text-[var(--chalk)]/80 [animation-delay:700ms] lg:text-[23px]"
        >
          A modern matrimony platform for Christians looking for a spouse, shaped by faith, clear intentions, and the
          people who love you.
        </p>

        <div className="hero-intro flex flex-col items-start gap-4 [animation-delay:850ms] lg:items-end">
          <div data-testid="hero-cta-group" className="flex flex-col gap-3 sm:flex-row">
            <Link data-testid="hero-get-started-link" href="/signup" className="pill pill-cta">
              Begin your search <ArrowGlyph className="size-4" />
            </Link>
            <Link data-testid="hero-learn-more-link" href="#how-it-works" className="pill">
              See how it works <ArrowGlyph direction="down" className="size-4" />
            </Link>
          </div>
          <p data-testid="hero-trust-note" className="text-[14px] text-[var(--chalk)]/70">
            Intentions first. <span className="text-[var(--sage)]">Privacy always.</span>
          </p>
        </div>
      </div>
    </section>
  );
}

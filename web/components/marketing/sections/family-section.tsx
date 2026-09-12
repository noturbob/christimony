"use client";

import { useRef } from "react";
import Image from "next/image";
import Link from "next/link";
import { useGSAP } from "@gsap/react";
import { cancelIdle, ensureGsapRegistered, gsap, scheduleIdle } from "@/lib/gsap";
import { Reveal, SectionEyebrow } from "../shared";
import { ArrowGlyph } from "../icons";

export function FamilySection() {
  const featureRef = useRef<HTMLElement>(null);
  const textureRef = useRef<HTMLDivElement>(null);

  useGSAP(
    () => {
      ensureGsapRegistered();
      const mm = gsap.matchMedia();

      const idle = scheduleIdle(() => {
        // Pointer-fine only: this is a decorative dot field, and scrubbing a
        // viewport-sized layer's transform on every scroll frame is a cost a
        // phone pays on the one thread it also needs for the scroll itself.
        // Desktop keeps the parallax; touch gets the same texture, static.
        mm.add("(pointer: fine) and (prefers-reduced-motion: no-preference)", () => {
          const tween = gsap.fromTo(
            textureRef.current,
            { y: -35 },
            {
              y: 45,
              ease: "none",
              scrollTrigger: { trigger: featureRef.current, start: "top bottom", end: "bottom top", scrub: true },
            }
          );
          return () => tween.scrollTrigger?.kill();
        });
      });

      return () => {
        cancelIdle(idle);
        mm.revert();
      };
    },
    { scope: featureRef }
  );

  return (
    <section
      ref={featureRef}
      data-testid="family-feature-section"
      className="relative isolate overflow-hidden bg-[#7a2e2e] px-5 py-24 text-[#faf6ef] lg:px-8 lg:py-32"
    >
      <div
        ref={textureRef}
        data-testid="family-feature-texture"
        className="pointer-events-none absolute inset-0 -z-10 opacity-35 [background-image:radial-gradient(rgba(250,246,239,0.26)_0.7px,transparent_0.7px)] [background-size:24px_24px]"
      />

      <div className="mx-auto grid max-w-[1180px] gap-12 lg:grid-cols-[0.85fr_1.15fr] lg:items-start lg:gap-24">
        <Reveal>
          <SectionEyebrow dark>Our signature difference</SectionEyebrow>
          <h2 data-testid="family-feature-headline" className="max-w-[580px] font-heading text-[clamp(3rem,5.8vw,5.5rem)] leading-[0.91] tracking-[-0.065em]">
            Family‑guided. <em className="font-normal text-[#f1c7b7]">Never family‑decided.</em>
          </h2>
          <div data-testid="family-feature-rule" className="mt-10 h-px w-24 bg-[#faf6ef]/40" />
        </Reveal>

        <Reveal className="grid gap-8 md:grid-cols-[0.9fr_1.1fr] md:items-stretch">
          <div className="aspect-[1264/848] w-full overflow-hidden rounded-[1.7rem] md:aspect-auto md:h-full md:min-h-[320px]">
            <Image
              data-testid="family-feature-image"
              src="/images/family-table.jpg"
              alt="A young woman sharing a joyful moment with family around a dining table"
              width={1264}
              height={848}
              loading="lazy"
              sizes="(min-width: 1024px) 30vw, (min-width: 768px) 42vw, 100vw"
              className="h-full w-full object-cover transition duration-500 hover:scale-105"
            />
          </div>

          <div>
            <p data-testid="family-feature-description" className="font-heading text-[2rem] leading-[1.05] tracking-[-0.045em]">
              Invite the people who know you best to help open a door, while you keep the key.
            </p>
            <p data-testid="family-feature-supporting-copy" className="mt-6 text-sm leading-6 text-[#faf6ef]/70">
              A parent or trusted family member can guide a profile and suggest an introduction. But before a
              connection opens, the person being introduced gets their own private moment to say yes. No pressure. No
              proxy decisions.
            </p>
            <Link
              data-testid="family-feature-learn-more-link"
              href="/signup"
              className="mt-7 inline-flex items-center rounded-full border border-[#faf6ef]/40 px-5 py-3 text-sm font-semibold transition duration-200 hover:-translate-y-1 hover:border-[#faf6ef]"
            >
              Explore the idea <ArrowGlyph className="ml-2 size-4" />
            </Link>
          </div>
        </Reveal>
      </div>
    </section>
  );
}

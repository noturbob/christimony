"use client";

import { useRef } from "react";
import Image from "next/image";
import Link from "next/link";
import { useGSAP } from "@gsap/react";
import { cancelIdle, ensureGsapRegistered, gsap, scheduleIdle } from "@/lib/gsap";
import { Reveal, SectionEyebrow, SplitHeading } from "../shared";
import { ArrowGlyph } from "../icons";

export function FamilySection() {
  const featureRef = useRef<HTMLElement>(null);
  const imageRef = useRef<HTMLDivElement>(null);
  const blobRef = useRef<HTMLDivElement>(null);

  useGSAP(
    () => {
      ensureGsapRegistered();
      const mm = gsap.matchMedia();

      const idle = scheduleIdle(() => {
        // Pointer-fine only: scrubbing on every scroll frame is a cost a
        // phone pays on the one thread it also needs for the scroll itself.
        // Desktop gets the image settling from a zoom and the blob rising
        // past it; touch gets the same composition, static.
        mm.add("(pointer: fine) and (prefers-reduced-motion: no-preference)", () => {
          const tl = gsap.timeline({
            defaults: { ease: "none" },
            scrollTrigger: { trigger: featureRef.current, start: "top bottom", end: "bottom top", scrub: true },
          });
          tl.fromTo(imageRef.current, { scale: 1.25 }, { scale: 1 }, 0).fromTo(
            blobRef.current,
            { yPercent: 40, rotate: -30 },
            { yPercent: -60, rotate: 40 },
            0
          );
          return () => tl.scrollTrigger?.kill();
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
      className="relative isolate overflow-hidden border-t border-[var(--line)] px-5 py-24 lg:px-8 lg:py-36"
    >
      <div className="mx-auto max-w-[1216px]">
        <SectionEyebrow>Our signature difference</SectionEyebrow>
        <SplitHeading
          testId="family-feature-headline"
          className="max-w-[1100px] text-[clamp(2.75rem,7vw,6.3rem)] font-semibold leading-[1] tracking-[-0.045em]"
        >
          Family‑guided. <em className="serif-italic text-[var(--blush)]">Never family‑decided.</em>
        </SplitHeading>

        <div className="mt-16 grid gap-12 lg:mt-24 lg:grid-cols-2 lg:items-center lg:gap-20">
          <div className="relative">
            <div ref={blobRef} className="pointer-events-none absolute -right-8 -top-10 z-10 size-32 lg:-right-14 lg:size-48">
              <div className="blob blob-blush size-full" />
            </div>
            <div className="aspect-[4/5] w-full overflow-hidden rounded-lg sm:aspect-[1264/848] lg:aspect-[4/5]">
              <div ref={imageRef} className="size-full">
                <Image
                  data-testid="family-feature-image"
                  src="/images/family-table.jpg"
                  alt="A young woman sharing a joyful moment with family around a dining table"
                  width={1264}
                  height={848}
                  loading="lazy"
                  sizes="(min-width: 1024px) 45vw, 100vw"
                  className="h-full w-full object-cover"
                />
              </div>
            </div>
          </div>

          <Reveal>
            <p className="text-[19px] text-[var(--blush)]">Family</p>
            <p data-testid="family-feature-description" className="mt-3 text-[34px] font-semibold leading-[1.1] tracking-[-0.03em] lg:text-[44px]">
              Invite the people who know you best to help open a door, while you keep the key.
            </p>
            <p data-testid="family-feature-supporting-copy" className="mt-6 max-w-[520px] text-[19px] leading-[1.38] text-[var(--chalk-50)]">
              A parent or trusted family member can guide a profile and suggest an introduction. But before a
              connection opens, the person being introduced gets their own private moment to say yes. No pressure. No
              proxy decisions.
            </p>
            <Link data-testid="family-feature-learn-more-link" href="/signup" className="pill mt-9">
              Explore the idea <ArrowGlyph className="size-4" />
            </Link>
          </Reveal>
        </div>
      </div>
    </section>
  );
}

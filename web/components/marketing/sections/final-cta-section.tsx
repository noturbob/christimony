"use client";

import { SectionEyebrow, SplitHeading } from "../shared";
import { MagneticLink } from "../magnetic-link";
import { ArrowGlyph } from "../icons";

export function FinalCtaSection() {
  return (
    <section
      data-testid="final-cta-section"
      className="relative isolate overflow-hidden border-t border-[var(--line)] px-5 py-32 text-center lg:py-48"
    >
      <div className="pointer-events-none absolute -left-20 -top-6 -z-10 size-28 lg:-left-16 lg:top-16 lg:size-64">
        <div className="blob blob-gold size-full" style={{ "--drift": "15s" } as React.CSSProperties} />
      </div>
      <div className="pointer-events-none absolute -bottom-16 -right-24 -z-10 size-44 lg:-right-20 lg:bottom-10 lg:size-96">
        <div className="blob blob-sage size-full" style={{ "--drift": "22s" } as React.CSSProperties} />
      </div>

      <div className="mx-auto max-w-[1100px]">
        <div className="flex justify-center">
          <SectionEyebrow>For the life you&apos;re hoping to build</SectionEyebrow>
        </div>

        <SplitHeading
          testId="final-cta-headline"
          className="text-[clamp(3rem,8vw,7.5rem)] font-semibold leading-[0.95] tracking-[-0.05em]"
        >
          The right search can change your <em className="serif-italic text-gradient-brand pr-[0.05em]">whole life.</em>
        </SplitHeading>

        <MagneticLink data-testid="final-cta-signup-link" href="/signup" className="pill pill-cta mt-12 lg:!px-8 lg:!py-5 lg:!text-[19px]">
          Get started with Christimony <ArrowGlyph className="size-4" />
        </MagneticLink>
      </div>
    </section>
  );
}

"use client";

import { Reveal, SectionEyebrow } from "../shared";
import { MagneticLink } from "../magnetic-link";
import { ArrowGlyph } from "../icons";

export function FinalCtaSection() {
  return (
    <section data-testid="final-cta-section" className="border-t border-[#e2dacb] bg-[#24463b] px-5 py-28 text-center text-[#faf6ef] lg:py-40">
      <Reveal className="mx-auto max-w-[780px]">
        <SectionEyebrow dark>For the life you&apos;re hoping to build</SectionEyebrow>

        <h2 data-testid="final-cta-headline" className="font-heading text-[clamp(3rem,6vw,5.8rem)] leading-[0.93] tracking-[-0.07em]">
          The right search can change your <em className="font-normal text-[#e6b9a9]">whole life.</em>
        </h2>

        <MagneticLink
          data-testid="final-cta-signup-link"
          href="/signup"
          className="mt-10 inline-flex items-center rounded-full bg-[#faf6ef] px-7 py-4 text-sm font-semibold text-[#24463b] transition-colors duration-200 hover:bg-white hover:shadow-xl"
        >
          Get started with Christimony <ArrowGlyph className="ml-2 size-4" />
        </MagneticLink>
      </Reveal>
    </section>
  );
}

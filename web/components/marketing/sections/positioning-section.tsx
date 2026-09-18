"use client";

import { Reveal, SectionEyebrow, SplitHeading, comparisonRows } from "../shared";
import { ArrowGlyph, CheckGlyph } from "../icons";

export function PositioningSection() {
  return (
    <section id="positioning" data-testid="positioning-section" className="mx-auto max-w-[1280px] px-5 py-24 lg:px-8 lg:py-36">
      <SectionEyebrow>Enough of the endless maybe</SectionEyebrow>
      <SplitHeading
        testId="positioning-headline"
        className="max-w-[1100px] text-[clamp(2.75rem,7vw,6.3rem)] font-semibold leading-[1] tracking-[-0.045em]"
      >
        The apps built to keep you swiping aren&apos;t built to help you{" "}
        <em className="serif-italic text-[var(--sage)]">stop.</em>
      </SplitHeading>

      <div data-testid="comparison-grid" className="mt-16 grid gap-6 lg:mt-24 lg:grid-cols-[0.8fr_1.2fr]">
        <Reveal className="rounded-lg border border-[var(--line)] p-7 lg:p-10">
          <div className="mb-16 flex items-center justify-between">
            <span data-testid="mainstream-label" className="text-[16px] text-[var(--chalk-50)]">
              Mainstream apps
            </span>
            <span className="text-[var(--chalk-50)]">✕</span>
          </div>
          <p data-testid="mainstream-copy" className="text-[34px] leading-[1.1] tracking-[-0.03em] text-[var(--chalk-50)]">
            More matches. Less clarity. A loop that never asks what you&apos;re actually looking for.
          </p>
        </Reveal>

        <Reveal delay={120} className="gradient-stroke rounded-lg bg-[var(--ink-2)] p-7 lg:p-10">
          <div className="mb-11 flex items-center justify-between">
            <span data-testid="christimony-label" className="text-[19px] text-[var(--sage)]">
              Christimony
            </span>
            <span className="grid size-8 place-items-center rounded-full bg-[image:var(--grad-brand)] text-[var(--ink)]">
              <CheckGlyph className="size-4" />
            </span>
          </div>

          <div data-testid="comparison-rows" className="space-y-6">
            {comparisonRows.map(([left, right], index) => (
              <Reveal
                key={left}
                delay={200 + index * 120}
                className="grid gap-2 sm:grid-cols-[1fr_auto_1.25fr] sm:items-center sm:gap-4 border-b border-[var(--line)] pb-6 last:border-0 last:pb-0"
              >
                <span data-testid={`comparison-mainstream-${index + 1}`} className="text-[16px] leading-5 text-[var(--chalk-50)] line-through decoration-[var(--chalk-50)]/50">
                  {left}
                </span>
                <ArrowGlyph className="hidden size-4 text-[var(--sage)] sm:block" />
                <span data-testid={`comparison-christimony-${index + 1}`} className="text-[23px] font-semibold leading-[1.1] tracking-[-0.02em] lg:text-[28px]">
                  {right}
                </span>
              </Reveal>
            ))}
          </div>
        </Reveal>
      </div>
    </section>
  );
}

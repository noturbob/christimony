"use client";

import { Reveal, SectionEyebrow, comparisonRows } from "../shared";
import { ArrowGlyph, CheckGlyph } from "../icons";

export function PositioningSection() {
  return (
    <section id="positioning" data-testid="positioning-section" className="mx-auto max-w-[1240px] px-5 py-24 lg:px-8 lg:py-36">
      <Reveal className="max-w-[760px]">
        <SectionEyebrow>Enough of the endless maybe</SectionEyebrow>
        <h2 data-testid="positioning-headline" className="font-heading text-[clamp(2.7rem,5vw,4.8rem)] leading-[0.98] tracking-[-0.06em]">
          The apps built to keep you swiping aren&apos;t built to help you <em className="font-normal text-[#7a2e2e]">stop.</em>
        </h2>
      </Reveal>

      <div data-testid="comparison-grid" className="mt-16 grid gap-5 lg:grid-cols-[0.8fr_1.2fr] lg:gap-14">
        <Reveal className="rounded-[1.7rem] border border-[#e2dacb] bg-[#e2dacb]/35 p-7 lg:p-10">
          <div className="mb-16 flex items-center justify-between">
            <span data-testid="mainstream-label" className="text-xs font-semibold uppercase tracking-[0.18em] text-[#1b1b18]/45">
              Mainstream apps
            </span>
            <span className="text-[#1b1b18]/35">✕</span>
          </div>
          <p data-testid="mainstream-copy" className="font-heading text-[2rem] leading-[1.02] tracking-[-0.045em] text-[#1b1b18]/65">
            More matches. Less clarity. A loop that never asks what you&apos;re actually looking for.
          </p>
        </Reveal>

        <Reveal className="rounded-[1.7rem] bg-[#24463b] p-7 text-[#faf6ef] lg:p-10">
          <div className="mb-11 flex items-center justify-between">
            <span data-testid="christimony-label" className="text-xs font-semibold uppercase tracking-[0.18em] text-[#faf6ef]/60">
              Christimony
            </span>
            <span className="grid size-7 place-items-center rounded-full bg-[#faf6ef] text-[#24463b]">
              <CheckGlyph className="size-3.5" />
            </span>
          </div>

          <div data-testid="comparison-rows" className="space-y-6">
            {comparisonRows.map(([left, right], index) => (
              <Reveal
                key={left}
                delay={index * 120}
                className="grid grid-cols-[1fr_auto_1.25fr] items-center gap-3 border-b border-[#faf6ef]/15 pb-6 last:border-0 last:pb-0"
              >
                <span data-testid={`comparison-mainstream-${index + 1}`} className="text-sm leading-5 text-[#faf6ef]/45">
                  {left}
                </span>
                <ArrowGlyph className="size-4 text-[#e6b9a9]" />
                <span data-testid={`comparison-christimony-${index + 1}`} className="font-heading text-[1.55rem] leading-none tracking-[-0.04em]">
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

"use client";

import { useState } from "react";
import { SectionEyebrow, SplitHeading, faqs } from "../shared";
import { PlusMinusGlyph } from "../icons";

export function FaqSection() {
  const [openFaq, setOpenFaq] = useState<number | null>(0);

  return (
    <section id="faq" data-testid="faq-section" className="mx-auto max-w-[1280px] px-5 py-24 lg:px-8 lg:py-36">
      <div className="mb-14 lg:mb-20">
        <SectionEyebrow>Good questions</SectionEyebrow>
        <SplitHeading
          testId="faq-headline"
          className="text-[clamp(2.75rem,7vw,6.3rem)] font-semibold leading-[1] tracking-[-0.045em]"
        >
          Clarity is part of <em className="serif-italic text-[var(--sage)]">care.</em>
        </SplitHeading>
      </div>

      <div data-testid="faq-list" className="border-t border-[var(--line)]">
        {faqs.map((faq, index) => {
          const isOpen = openFaq === index;
          return (
            <div data-testid={`faq-item-${index + 1}`} key={faq.question} className="border-b border-[var(--line)]">
              <button
                data-testid={`faq-toggle-${index + 1}`}
                type="button"
                aria-expanded={isOpen}
                onClick={() => setOpenFaq(isOpen ? null : index)}
                className="group flex w-full items-center justify-between gap-6 py-7 text-left"
              >
                <span
                  data-testid={`faq-question-${index + 1}`}
                  className="relative text-[23px] font-medium leading-tight tracking-[-0.02em] transition-colors duration-300 group-hover:text-[var(--sage)] sm:text-[34px]"
                >
                  {faq.question}
                </span>
                <span
                  className={`grid size-11 shrink-0 place-items-center rounded-full border transition-colors duration-300 ${
                    isOpen ? "border-[var(--sage)] text-[var(--sage)]" : "border-[var(--chalk)]/60 text-[var(--chalk)]"
                  }`}
                >
                  <PlusMinusGlyph open={isOpen} className="size-3.5" />
                </span>
              </button>

              {/* An accordion in normal flow has to move the content below it,
                  so some layout-affecting property genuinely has to animate --
                  `max-height` between two definite lengths is the option that
                  behaves the same in every engine. Not `grid-template-rows:
                  0fr -> 1fr`: on an auto-height single-row container WebKit
                  sizes the row from its content instead of collapsing it, so
                  the "closed" state never closes. */}
              <div
                data-testid={`faq-answer-${index + 1}`}
                inert={!isOpen}
                className={`overflow-hidden transition-[max-height,opacity] duration-300 ease-out ${
                  isOpen ? "max-h-96 opacity-100" : "max-h-0 opacity-0"
                }`}
              >
                <p className="max-w-[760px] pb-8 pr-12 text-[19px] leading-[1.38] text-[var(--chalk-50)]">{faq.answer}</p>
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}

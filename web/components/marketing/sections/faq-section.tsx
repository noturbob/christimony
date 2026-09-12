"use client";

import { useState } from "react";
import { Reveal, SectionEyebrow, faqs } from "../shared";
import { PlusMinusGlyph } from "../icons";

export function FaqSection() {
  const [openFaq, setOpenFaq] = useState<number | null>(0);

  return (
    <section id="faq" data-testid="faq-section" className="mx-auto max-w-[950px] px-5 py-24 lg:py-36">
      <Reveal className="mb-12">
        <SectionEyebrow>Good questions</SectionEyebrow>
        <h2 data-testid="faq-headline" className="font-heading text-[clamp(2.8rem,5vw,4.6rem)] leading-[0.96] tracking-[-0.06em]">
          Clarity is part of <em className="font-normal text-[#7a2e2e]">care.</em>
        </h2>
      </Reveal>

      <div data-testid="faq-list" className="border-t border-[#e2dacb]">
        {faqs.map((faq, index) => {
          const isOpen = openFaq === index;
          return (
            <div data-testid={`faq-item-${index + 1}`} key={faq.question} className="border-b border-[#e2dacb]">
              <button
                data-testid={`faq-toggle-${index + 1}`}
                type="button"
                aria-expanded={isOpen}
                onClick={() => setOpenFaq(isOpen ? null : index)}
                className="group flex w-full items-center justify-between gap-6 py-6 text-left"
              >
                <span
                  data-testid={`faq-question-${index + 1}`}
                  className="relative font-heading text-[1.45rem] leading-tight tracking-[-0.04em] sm:text-[1.7rem]"
                >
                  {faq.question}
                  <span className="absolute -bottom-1 left-0 h-px w-full origin-left scale-x-0 bg-[#7a2e2e] transition-transform duration-300 group-hover:scale-x-100" />
                </span>
                <span
                  className={`grid size-8 shrink-0 place-items-center rounded-full border border-[#e2dacb] transition-colors duration-200 ${
                    isOpen ? "bg-[#24463b] text-[#faf6ef]" : "text-[#7a2e2e]"
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
                <p className="max-w-[760px] pb-7 pr-12 text-sm leading-6 text-[#1b1b18]/65">{faq.answer}</p>
              </div>
            </div>
          );
        })}
      </div>
    </section>
  );
}

"use client";

import { useState } from "react";
import { AnimatePresence, motion } from "motion/react";
import { ChevronDown } from "lucide-react";
import { SectionEyebrow, faqs, reveal } from "../shared";

export function FaqSection() {
  const [openFaq, setOpenFaq] = useState<number | null>(0);

  return (
    <section id="faq" data-testid="faq-section" className="mx-auto max-w-[950px] px-5 py-24 lg:py-36">
      <motion.div initial="hidden" whileInView="visible" viewport={{ once: true, amount: 0.25 }} variants={reveal} className="mb-12">
        <SectionEyebrow>Good questions</SectionEyebrow>
        <h2 data-testid="faq-headline" className="font-heading text-[clamp(2.8rem,5vw,4.6rem)] leading-[0.96] tracking-[-0.06em]">
          Clarity is part of <em className="font-normal text-[#7a2e2e]">care.</em>
        </h2>
      </motion.div>

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
                  className={`grid size-8 shrink-0 place-items-center rounded-full border border-[#e2dacb] transition duration-200 ${
                    isOpen ? "rotate-180 bg-[#24463b] text-[#faf6ef]" : "text-[#7a2e2e]"
                  }`}
                >
                  <ChevronDown size={16} />
                </span>
              </button>

              <AnimatePresence initial={false}>
                {isOpen && (
                  <motion.div
                    data-testid={`faq-answer-${index + 1}`}
                    initial={{ height: 0, opacity: 0 }}
                    animate={{ height: "auto", opacity: 1 }}
                    exit={{ height: 0, opacity: 0 }}
                    transition={{ duration: 0.25 }}
                    className="overflow-hidden"
                  >
                    <p className="max-w-[760px] pb-7 pr-12 text-sm leading-6 text-[#1b1b18]/65">{faq.answer}</p>
                  </motion.div>
                )}
              </AnimatePresence>
            </div>
          );
        })}
      </div>
    </section>
  );
}

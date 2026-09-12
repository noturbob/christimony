"use client";

import { useRef } from "react";
import { motion } from "motion/react";
import { useGSAP } from "@gsap/react";
import { cancelIdle, ensureGsapRegistered, gsap, scheduleIdle } from "@/lib/gsap";
import { SectionEyebrow, reveal } from "../shared";

const STEPS = [
  {
    number: "01",
    title: "Create a profile",
    copy: "Share the faith, values, and intentions you want a future spouse to understand.",
  },
  {
    number: "02",
    title: "Browse with intention",
    copy: "See people through the lens of denomination, direction, and what you both hope to build.",
  },
  {
    number: "03",
    title: "Connect at the right pace",
    copy: "Move from a thoughtful introduction to a real conversation when it feels right.",
  },
];

function StepCard({ step }: { step: (typeof STEPS)[number] }) {
  return (
    <div data-testid={`step-${step.number}`} className="group relative grid grid-cols-[72px_1fr] gap-5 border-t border-[#e2dacb] pt-6 sm:grid-cols-[100px_1fr] sm:gap-8">
      <span data-testid={`step-number-${step.number}`} className="font-heading text-[4.5rem] leading-[0.72] tracking-[-0.08em] text-[#e2dacb] transition-colors duration-200 group-hover:text-[#7a2e2e]/30">
        {step.number}
      </span>
      <div>
        <h3 data-testid={`step-title-${step.number}`} className="font-heading text-[1.7rem] tracking-[-0.045em]">
          {step.title}
        </h3>
        <p data-testid={`step-copy-${step.number}`} className="mt-3 max-w-[500px] text-[15px] leading-6 text-[#1b1b18]/60">
          {step.copy}
        </p>
      </div>
    </div>
  );
}

export function HowItWorksSection() {
  const sectionRef = useRef<HTMLElement>(null);
  const pinRef = useRef<HTMLDivElement>(null);
  const trackRef = useRef<HTMLDivElement>(null);

  useGSAP(
    () => {
      ensureGsapRegistered();
      const mm = gsap.matchMedia();

      const idle = scheduleIdle(() => {
        // The signature moment of the page: on desktop, the section pins
        // and the three steps translate sideways as you keep scrolling
        // down, instead of the usual vertical stack. Mobile gets the plain
        // stacked layout below -- horizontal-scroll-via-pin reads poorly
        // on a phone where vertical scroll is the only expected gesture.
        mm.add("(min-width: 1024px) and (prefers-reduced-motion: no-preference)", () => {
          const track = trackRef.current;
          const pinTarget = pinRef.current;
          if (!track || !pinTarget) return;

          const distance = () => Math.max(track.scrollWidth - window.innerWidth, 0);

          const tween = gsap.to(track, {
            x: () => -distance(),
            ease: "none",
            scrollTrigger: {
              trigger: pinTarget,
              start: "top top",
              end: () => `+=${distance()}`,
              scrub: 1,
              pin: true,
              invalidateOnRefresh: true,
            },
          });

          return () => tween.scrollTrigger?.kill();
        });
      });

      return () => {
        cancelIdle(idle);
        mm.revert();
      };
    },
    { scope: sectionRef }
  );

  return (
    <section ref={sectionRef} id="how-it-works" data-testid="how-it-works-section">
      {/* Mobile / reduced-motion: plain vertical stack */}
      <div className="mx-auto max-w-[1240px] px-5 py-24 lg:hidden">
        <motion.div initial="hidden" whileInView="visible" viewport={{ once: true, amount: 0.25 }} variants={reveal}>
          <SectionEyebrow>How it works</SectionEyebrow>
          <h2 data-testid="how-it-works-headline" className="max-w-[430px] font-heading text-[clamp(2.8rem,5vw,4.5rem)] leading-[0.98] tracking-[-0.06em]">
            A search with room for <em className="font-normal text-[#7a2e2e]">meaning.</em>
          </h2>
          <p data-testid="how-it-works-description" className="mt-6 max-w-[330px] text-[15px] leading-6 text-[#1b1b18]/60">
            Less noise. More context. A path that respects the weight of the decision you&apos;re making.
          </p>
        </motion.div>

        <motion.div
          data-testid="steps-list"
          initial="hidden"
          whileInView="visible"
          viewport={{ once: true, amount: 0.2 }}
          transition={{ staggerChildren: 0.14 }}
          className="mt-14 space-y-11"
        >
          {STEPS.map((step) => (
            <motion.div key={step.number} variants={reveal}>
              <StepCard step={step} />
            </motion.div>
          ))}
        </motion.div>
      </div>

      {/* Desktop: pinned horizontal scroll */}
      <div ref={pinRef} className="hidden lg:block lg:h-screen lg:overflow-hidden">
        <div className="flex h-full items-center">
          <div ref={trackRef} className="flex items-center gap-24 pl-[8vw]">
            <div className="w-[34vw] shrink-0">
              <SectionEyebrow>How it works</SectionEyebrow>
              <h2 data-testid="how-it-works-headline" className="max-w-[430px] font-heading text-[clamp(2.8rem,4.4vw,4.5rem)] leading-[0.98] tracking-[-0.06em]">
                A search with room for <em className="font-normal text-[#7a2e2e]">meaning.</em>
              </h2>
              <p data-testid="how-it-works-description" className="mt-6 max-w-[330px] text-[15px] leading-6 text-[#1b1b18]/60">
                Less noise. More context. A path that respects the weight of the decision you&apos;re making.
              </p>
            </div>

            <div data-testid="steps-list" className="flex items-center gap-20">
              {STEPS.map((step) => (
                <div key={step.number} className="w-[26vw] max-w-[420px]">
                  <StepCard step={step} />
                </div>
              ))}
            </div>

            <div className="w-[4vw] shrink-0" />
          </div>
        </div>
      </div>
    </section>
  );
}

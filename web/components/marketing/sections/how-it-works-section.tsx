"use client";

import { useRef } from "react";
import { useGSAP } from "@gsap/react";
import { cancelIdle, ensureGsapRegistered, gsap, scheduleIdle } from "@/lib/gsap";
import { Reveal, SectionEyebrow, SplitHeading } from "../shared";

// Each step owns one highlighter colour (see the palette note in globals.css).
const STEPS = [
  {
    number: "01",
    label: "Profile",
    color: "var(--sage)",
    blob: "blob-sage",
    title: "Create a profile",
    copy: "Share the faith, values, and intentions you want a future spouse to understand.",
  },
  {
    number: "02",
    label: "Intention",
    color: "var(--gold)",
    blob: "blob-gold",
    title: "Browse with intention",
    copy: "See people through the lens of denomination, direction, and what you both hope to build.",
  },
  {
    number: "03",
    label: "Pace",
    color: "var(--lilac)",
    blob: "blob-lilac",
    title: "Connect at the right pace",
    copy: "Move from a thoughtful introduction to a real conversation when it feels right.",
  },
];

function StepCard({ step }: { step: (typeof STEPS)[number] }) {
  return (
    <div data-testid={`step-${step.number}`} className="relative border-t border-[var(--line)] pt-8">
      <div className="mb-10 flex items-start justify-between">
        <span
          data-testid={`step-number-${step.number}`}
          className="text-[clamp(5rem,8vw,8rem)] font-semibold leading-[0.8] tracking-[-0.06em] text-transparent [-webkit-text-stroke:1.5px_var(--step-color)]"
          style={{ "--step-color": step.color } as React.CSSProperties}
        >
          {step.number}
        </span>
        <div className="step-blob size-20 lg:size-28">
          <div className={`blob size-full ${step.blob}`} />
        </div>
      </div>
      <p className="text-[19px]" style={{ color: step.color }}>
        {step.label}
      </p>
      <h3 data-testid={`step-title-${step.number}`} className="mt-2 text-[34px] font-semibold leading-[1.1] tracking-[-0.03em] lg:text-[44px]">
        {step.title}
      </h3>
      <p data-testid={`step-copy-${step.number}`} className="mt-4 max-w-[440px] text-[19px] leading-[1.38] text-[var(--chalk-50)]">
        {step.copy}
      </p>
    </div>
  );
}

const Intro = () => (
  <>
    <SectionEyebrow>How it works</SectionEyebrow>
    <SplitHeading
      testId="how-it-works-headline"
      className="max-w-[520px] text-[clamp(2.75rem,5.2vw,5.5rem)] font-semibold leading-[1] tracking-[-0.045em]"
    >
      A search with room for <em className="serif-italic text-[var(--sage)]">meaning.</em>
    </SplitHeading>
    <p data-testid="how-it-works-description" className="mt-6 max-w-[380px] text-[19px] leading-[1.38] text-[var(--chalk-50)]">
      Less noise. More context. A path that respects the weight of the decision you&apos;re making.
    </p>
  </>
);

export function HowItWorksSection() {
  const sectionRef = useRef<HTMLElement>(null);
  const pinRef = useRef<HTMLDivElement>(null);
  const trackRef = useRef<HTMLDivElement>(null);
  const progressRef = useRef<HTMLDivElement>(null);

  useGSAP(
    () => {
      ensureGsapRegistered();
      const mm = gsap.matchMedia();

      const idle = scheduleIdle(() => {
        // The signature moment of the page: on desktop, the section pins
        // and the steps translate sideways as you keep scrolling down, the
        // blobs turn with it, and a hairline fills to show how far along
        // you are. Mobile gets the plain stacked layout below --
        // horizontal-scroll-via-pin reads poorly on a phone.
        mm.add("(min-width: 1024px) and (prefers-reduced-motion: no-preference)", () => {
          const track = trackRef.current;
          const pinTarget = pinRef.current;
          if (!track || !pinTarget) return;

          const distance = () => Math.max(track.scrollWidth - window.innerWidth, 0);

          const tl = gsap.timeline({
            defaults: { ease: "none" },
            scrollTrigger: {
              trigger: pinTarget,
              start: "top top",
              end: () => `+=${distance()}`,
              scrub: 1,
              pin: true,
              invalidateOnRefresh: true,
            },
          });
          tl.to(track, { x: () => -distance() }, 0)
            .fromTo(progressRef.current, { scaleX: 0 }, { scaleX: 1 }, 0)
            .to(track.querySelectorAll(".step-blob"), { rotate: 240, scale: 1.15 }, 0);

          return () => tl.scrollTrigger?.kill();
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
      <div className="mx-auto max-w-[1280px] px-5 py-24 lg:hidden">
        <Intro />
        <div data-testid="steps-list" className="mt-14 space-y-14">
          {STEPS.map((step, index) => (
            <Reveal key={step.number} delay={index * 140}>
              <StepCard step={step} />
            </Reveal>
          ))}
        </div>
      </div>

      {/* Desktop: pinned horizontal scroll */}
      <div ref={pinRef} className="relative hidden lg:block lg:h-screen lg:overflow-hidden">
        <div className="flex h-full items-center">
          <div ref={trackRef} className="flex items-center gap-24 pl-[6vw]">
            <div className="w-[36vw] shrink-0">
              <Intro />
            </div>

            <div data-testid="steps-list" className="flex items-center gap-20">
              {STEPS.map((step) => (
                <div key={step.number} className="w-[30vw] max-w-[480px]">
                  <StepCard step={step} />
                </div>
              ))}
            </div>

            <div className="w-[4vw] shrink-0" />
          </div>
        </div>

        <div className="absolute inset-x-8 bottom-10 h-px bg-[var(--line)]">
          <div ref={progressRef} className="h-full origin-left bg-[image:var(--grad-brand)] [transform:scaleX(0)]" />
        </div>
      </div>
    </section>
  );
}

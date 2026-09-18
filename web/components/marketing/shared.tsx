"use client";

import { useEffect, useRef } from "react";
import Link from "next/link";
import { useGSAP } from "@gsap/react";
import { cancelIdle, ensureGsapRegistered, gsap, scheduleIdle, SplitText } from "@/lib/gsap";

// Fade/rise-in on first scroll into view. This used to be a Framer Motion
// `whileInView` variant; the animation itself is two composited properties
// and needs no animation library, and dropping Framer Motion from this route
// takes ~146KB of JS (~49KB gzipped, roughly a sixth of the landing page's
// total) off the parse/hydrate path -- which is exactly the path the page
// was stalling on. The observer fires once and disconnects; everything after
// that is a plain CSS transition (see `.reveal` in app/globals.css).
export function Reveal({
  children,
  className,
  delay,
}: {
  children: React.ReactNode;
  className?: string;
  delay?: number;
}) {
  const ref = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const el = ref.current;
    if (!el) return;

    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) {
      el.dataset.revealed = "true";
      return;
    }

    // Deliberately threshold 0 with a bottom margin rather than a fractional
    // threshold: several of these blocks are taller than a phone viewport, and
    // a "25% of the element is visible" threshold can never be satisfied for
    // those -- the content would simply stay invisible.
    const io = new IntersectionObserver(
      ([entry]) => {
        if (!entry.isIntersecting) return;
        el.dataset.revealed = "true";
        io.disconnect();
      },
      { rootMargin: "0px 0px -12% 0px" }
    );
    io.observe(el);

    return () => io.disconnect();
  }, []);

  return (
    <div
      ref={ref}
      className={className ? `reveal ${className}` : "reveal"}
      style={delay ? { transitionDelay: `${delay}ms` } : undefined}
    >
      {children}
    </div>
  );
}

export const DENOMINATIONS = [
  "Roman Catholic",
  "Syro-Malabar",
  "Malankara Orthodox",
  "Mar Thoma",
  "Church of South India",
  "Anglican",
  "Methodist",
  "Baptist",
  "Pentecostal",
  "Seventh-day Adventist",
  "Evangelical",
  "Non-denominational",
];

export const faqs = [
  {
    question: "Is Christimony only for one denomination?",
    answer:
      "No. Christimony is built for Christians across Catholic, Orthodox, Pentecostal, Baptist, Anglican, Methodist, non-denominational, and other traditions. Denomination-aware matching helps you be clear about what matters to you without reducing anyone to a label.",
  },
  {
    question: "How does the family-guided feature work?",
    answer:
      "A parent or trusted family member can help shape a profile and offer thoughtful introductions. Before any real connection opens, the person being introduced must independently review and consent. Their answer is always final: family-guided, never family-decided.",
  },
  {
    question: "Is Christimony safe and verified?",
    answer:
      "We are designing for a slower, more considered experience with profile standards, privacy controls, reporting tools, and room to connect at your own pace. Verification is part of the foundation, not an afterthought.",
  },
  {
    question: "How does matching work?",
    answer:
      "You set your denomination, location, values, and relationship intentions. Christimony uses those signals to make discovery more relevant, so browsing feels like a real search for a spouse rather than an endless stream of maybes.",
  },
  {
    question: "What does 'connect at the right pace' mean?",
    answer:
      "You decide when a connection moves forward. There is space to learn, pray, and talk with intention before sharing more personal details or involving family.",
  },
  {
    question: "Will Christimony be free to join?",
    answer:
      "The launch plan is designed to make joining and creating a profile accessible. We will keep pricing simple and transparent, with no confusing paywalls between you and a meaningful first step.",
  },
  {
    question: "Can I use Christimony if my family is not involved?",
    answer:
      "Absolutely. Family guidance is optional. You can create and guide your own profile, browse independently, and choose whether to invite someone you trust into the process.",
  },
];

export const comparisonRows: [string, string][] = [
  ["Designed to keep you swiping", "Designed to help you stop"],
  ["One-size-fits-all discovery", "Denomination-aware matching"],
  ["Connection before clarity", "Intentions made visible early"],
];

// Section headline whose lines rise out of a mask the first time it scrolls
// into view. Same idle deferral as every other SplitText on the page.
export function SplitHeading({
  children,
  className,
  testId,
}: {
  children: React.ReactNode;
  className?: string;
  testId?: string;
}) {
  const ref = useRef<HTMLHeadingElement>(null);

  useGSAP(
    () => {
      if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
      ensureGsapRegistered();

      let split: ReturnType<typeof SplitText.create> | undefined;
      const idle = scheduleIdle(() => {
        split = SplitText.create(ref.current!, {
          type: "lines",
          mask: "lines",
          linesClass: "split-line",
          autoSplit: true,
          onSplit: (self) =>
            gsap.from(self.lines, {
              yPercent: 115,
              duration: 1.1,
              ease: "expo.out",
              stagger: 0.08,
              scrollTrigger: { trigger: ref.current, start: "top 88%", once: true },
            }),
        });
      });

      return () => {
        cancelIdle(idle);
        split?.revert();
      };
    },
    { scope: ref }
  );

  return (
    <h2 ref={ref} data-testid={testId} className={className}>
      {children}
    </h2>
  );
}

// Short sage rule + label: the page's recurring section marker.
export function SectionEyebrow({ children }: { children: string }) {
  return (
    <p
      data-testid={`section-eyebrow-${children.toLowerCase().replaceAll(" ", "-")}`}
      className="mb-6 flex items-center gap-3 text-[16px] leading-[1.15] text-[var(--chalk)] sm:text-[19px]"
    >
      <span aria-hidden className="h-px w-8 bg-[var(--sage)]" />
      {children}
    </p>
  );
}

export function Wordmark({ testId }: { testId: string }) {
  return (
    <Link
      data-testid={testId}
      href="/"
      className="flex items-center gap-2.5 text-[19px] font-semibold tracking-[-0.03em] text-[var(--chalk)]"
    >
      <span className="grid size-8 place-items-center rounded-full bg-[image:var(--grad-brand)] font-display text-[16px] leading-none text-[var(--ink)]">
        C
      </span>
      Christimony
    </Link>
  );
}

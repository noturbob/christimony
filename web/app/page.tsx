"use client";

import { AnimatePresence, motion, useReducedMotion, useScroll, useTransform } from "motion/react";
import type { Variants } from "motion/react";
import { useEffect, useRef, useState } from "react";
import { ArrowDown, ArrowUpRight, Check, ChevronDown, Heart, Menu, ShieldCheck, Sparkles, Users, X } from "lucide-react";
import Link from "next/link";

const heroImage = "https://static.prod-images.emergentagent.com/jobs/62a2040b-249f-4b01-9872-ce81e407d920/images/68850258fde1d3827eec293348bd593eba29a8e4a66bae6acfb70addd1d4e498.jpeg";
const familyImage = "https://static.prod-images.emergentagent.com/jobs/62a2040b-249f-4b01-9872-ce81e407d920/images/dc2effa9c8b3ba14ec374f389f38da470bddafe851dc393bd06bf9ac489be223.jpeg";

const reveal: Variants = {
  hidden: { opacity: 0, y: 28 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.7, ease: "easeOut" } },
};

const faqs = [
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

const comparisonRows = [
  ["Designed to keep you swiping", "Designed to help you stop"],
  ["One-size-fits-all discovery", "Denomination-aware matching"],
  ["Connection before clarity", "Intentions made visible early"],
];

function SectionEyebrow({
  children,
  dark = false,
}: {
  children: string;
  dark?: boolean;
}) {
  return (
    <p
      data-testid={`section-eyebrow-${children.toLowerCase().replaceAll(" ", "-")}`}
      className={`mb-5 text-[11px] font-semibold uppercase tracking-[0.24em] ${
        dark ? "text-[#ead8cb]" : "text-[#7a2e2e]"
      }`}
    >
      {children}
    </p>
  );
}

function Wordmark({
  light = false,
  testId,
}: {
  light?: boolean;
  testId: string;
}) {
  return (
    <Link
      data-testid={testId}
      href="/"
      className={`flex items-center gap-2.5 text-[17px] font-semibold tracking-[-0.03em] ${
        light ? "text-[#faf6ef]" : "text-[#1b1b18]"
      }`}
    >
      <span
        className={`grid size-8 place-items-center rounded-full ${
          light ? "bg-[#faf6ef] text-[#24463b]" : "bg-[#24463b] text-[#faf6ef]"
        }`}
      >
        <Heart size={15} fill="currentColor" strokeWidth={1.5} />
      </span>
      Christimony
    </Link>
  );
}

export default function Home() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const [openFaq, setOpenFaq] = useState<number | null>(0);
  const reduceMotion = useReducedMotion();
  const heroRef = useRef<HTMLElement>(null);
  const featureRef = useRef<HTMLElement>(null);

  const { scrollYProgress: heroProgress } = useScroll({
    target: heroRef,
    offset: ["start start", "end start"],
  });

  const { scrollYProgress: featureProgress } = useScroll({
    target: featureRef,
    offset: ["start end", "end start"],
  });

  const heroTextureY = useTransform(heroProgress, [0, 1], [0, 90]);
  const featureTextureY = useTransform(featureProgress, [0, 1], [-35, 45]);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 24);

    window.addEventListener("scroll", onScroll, { passive: true });
    onScroll();

    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  const closeMobile = () => setMobileOpen(false);

  return (
    <div
      data-testid="christimony-landing-page"
      className="overflow-hidden bg-[#faf6ef] text-[#1b1b18]"
    >
      <header
        data-testid="site-header"
        className={`fixed inset-x-0 top-0 z-50 transition-[background-color,backdrop-filter,box-shadow] duration-300 ${
          scrolled
            ? "bg-[#faf6ef]/90 shadow-[0_1px_0_rgba(27,27,24,0.08)] backdrop-blur-xl"
            : "bg-transparent"
        }`}
      >
        <nav
          data-testid="primary-navigation"
          aria-label="Primary navigation"
          className="mx-auto flex h-[76px] max-w-[1240px] items-center justify-between px-5 lg:px-8"
        >
          <Wordmark testId="header-brand-wordmark" light={!scrolled} />

          <div
            data-testid="desktop-navigation-links"
            className="hidden items-center gap-8 md:flex"
          >
            <Link
              data-testid="nav-how-it-works-link"
              href="#how-it-works"
              className={`text-[13px] font-medium transition-colors hover:text-[#7a2e2e] ${
                scrolled ? "text-[#1b1b18]/70" : "text-[#faf6ef]/75"
              }`}
            >
              How it works
            </Link>

            <Link
              data-testid="nav-faq-link"
              href="#faq"
              className={`text-[13px] font-medium transition-colors hover:text-[#7a2e2e] ${
                scrolled ? "text-[#1b1b18]/70" : "text-[#faf6ef]/75"
              }`}
            >
              Questions
            </Link>

            <Link
              data-testid="nav-login-link"
              href="/login"
              className={`text-[13px] font-medium transition-colors hover:text-[#7a2e2e] ${
                scrolled ? "text-[#1b1b18]/70" : "text-[#faf6ef]/75"
              }`}
            >
              Log in
            </Link>

            <Link
              data-testid="nav-get-started-link"
              href="/signup"
              className={`rounded-full px-5 py-2.5 text-[13px] font-semibold transition duration-200 hover:-translate-y-0.5 hover:shadow-lg ${
                scrolled
                  ? "bg-[#24463b] text-[#faf6ef]"
                  : "bg-[#faf6ef] text-[#24463b]"
              }`}
            >
              Get started{" "}
              <ArrowUpRight className="ml-1 inline size-3.5" />
            </Link>
          </div>

          <button
            data-testid="mobile-menu-toggle"
            type="button"
            aria-label={mobileOpen ? "Close menu" : "Open menu"}
            aria-expanded={mobileOpen}
            onClick={() => setMobileOpen(!mobileOpen)}
            className={`grid size-10 place-items-center rounded-full md:hidden ${
              scrolled ? "text-[#1b1b18]" : "text-[#faf6ef]"
            }`}
          >
            {mobileOpen ? <X size={20} /> : <Menu size={20} />}
          </button>
        </nav>

        <AnimatePresence>
          {mobileOpen && (
            <motion.div
              data-testid="mobile-navigation-menu"
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              exit={{ opacity: 0, height: 0 }}
              className="border-t border-[#e2dacb] bg-[#faf6ef] px-5 pb-6 md:hidden"
            >
              <div className="flex flex-col gap-4 pt-5">
                <Link
                  data-testid="mobile-how-it-works-link"
                  href="#how-it-works"
                  onClick={closeMobile}
                  className="font-medium"
                >
                  How it works
                </Link>

                <Link
                  data-testid="mobile-faq-link"
                  href="#faq"
                  onClick={closeMobile}
                  className="font-medium"
                >
                  Questions
                </Link>

                <Link
                  data-testid="mobile-login-link"
                  href="/login"
                  onClick={closeMobile}
                  className="font-medium"
                >
                  Log in
                </Link>

                <Link
                  data-testid="mobile-get-started-link"
                  href="/signup"
                  onClick={closeMobile}
                  className="rounded-full bg-[#24463b] px-5 py-3 text-center font-semibold text-[#faf6ef]"
                >
                  Get started{" "}
                  <ArrowUpRight className="ml-1 inline size-4" />
                </Link>
              </div>
            </motion.div>
          )}
        </AnimatePresence>
      </header>

      <main>
        <section
          ref={heroRef}
          data-testid="hero-section"
          className="relative isolate min-h-[730px] overflow-hidden bg-[#24463b] text-[#faf6ef] lg:min-h-[790px]"
        >
          <motion.div
            data-testid="hero-dot-texture"
            style={reduceMotion ? undefined : { y: heroTextureY }}
            className="pointer-events-none absolute inset-0 -z-10 opacity-40 [background-image:radial-gradient(rgba(250,246,239,0.28)_0.7px,transparent_0.7px)] [background-size:22px_22px]"
          />

          <div className="absolute -right-24 top-24 -z-10 size-[420px] rounded-full bg-[#7a2e2e]/20 blur-[90px]" />

          <div className="mx-auto flex max-w-[1240px] flex-col px-5 pb-16 pt-36 lg:flex-row lg:items-end lg:gap-14 lg:px-8 lg:pb-24 lg:pt-44">
            <motion.div
              initial={reduceMotion ? false : { opacity: 0, y: 24 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.75, delay: 0.08 }}
              className="relative z-10 max-w-[700px] lg:w-[56%]"
            >
              <SectionEyebrow dark>
                For the seriously hopeful
              </SectionEyebrow>

              <h1
                data-testid="hero-headline"
                className="max-w-[700px] font-heading text-[clamp(3.3rem,7.4vw,5.8rem)] leading-[0.94] tracking-[-0.065em]"
              >
                Marriage, sought with intention —{" "}
                <em className="font-normal text-[#e6b9a9]">
                  not swiped past.
                </em>
              </h1>

              <p
                data-testid="hero-subheadline"
                className="mt-7 max-w-[520px] text-[17px] leading-7 text-[#faf6ef]/72"
              >
                A modern matrimony platform for Christians looking for a
                spouse, shaped by faith, clear intentions, and the people who
                love you.
              </p>

              <div
                data-testid="hero-cta-group"
                className="mt-9 flex flex-col gap-3 sm:flex-row"
              >
                <Link
                  data-testid="hero-get-started-link"
                  href="/signup"
                  className="inline-flex items-center justify-center rounded-full bg-[#faf6ef] px-6 py-3.5 text-sm font-semibold text-[#24463b] transition duration-200 hover:-translate-y-1 hover:bg-white hover:shadow-xl"
                >
                  Begin your search{" "}
                  <ArrowUpRight className="ml-2 size-4" />
                </Link>

                <Link
                  data-testid="hero-learn-more-link"
                  href="#how-it-works"
                  className="inline-flex items-center justify-center rounded-full border border-[#faf6ef]/40 px-6 py-3.5 text-sm font-semibold text-[#faf6ef] transition duration-200 hover:-translate-y-1 hover:border-[#faf6ef]"
                >
                  See how it works{" "}
                  <ArrowDown className="ml-2 size-4" />
                </Link>
              </div>

              <div
                data-testid="hero-trust-note"
                className="mt-8 flex items-center gap-2 text-xs text-[#faf6ef]/55"
              >
                <ShieldCheck size={15} />
                Intentions first. Privacy always.
              </div>
            </motion.div>

            <motion.div
              initial={
                reduceMotion ? false : { opacity: 0, y: 32, rotate: 2 }
              }
              animate={{ opacity: 1, y: 0, rotate: 2 }}
              transition={{ duration: 0.9, delay: 0.22 }}
              className="relative mt-14 ml-auto w-[87%] max-w-[500px] lg:mt-0 lg:w-[42%]"
            >
              <div className="absolute -inset-3 rounded-[2rem] border border-[#faf6ef]/20" />

              {/* eslint-disable-next-line @next/next/no-img-element */}
              <img
                data-testid="hero-couple-image"
                src={heroImage}
                alt="A couple walking together through a sunlit garden"
                width={1264}
                height={848}
                fetchPriority="high"
                className="aspect-[1.18] w-full rounded-[1.7rem] object-cover shadow-2xl"
              />

              <div
                data-testid="hero-image-caption"
                className="absolute -bottom-5 -left-5 max-w-[230px] rounded-2xl bg-[#faf6ef] p-4 text-[#1b1b18] shadow-xl"
              >
                <p className="font-heading text-xl leading-none">
                  A slower way to find each other.
                </p>

                <p className="mt-2 text-[11px] uppercase tracking-[0.14em] text-[#1b1b18]/50">
                  Built around real life
                </p>
              </div>
            </motion.div>
          </div>

          <div className="absolute bottom-6 left-5 text-[10px] uppercase tracking-[0.22em] text-[#faf6ef]/45 lg:left-8">
            01 / 09
          </div>
        </section>

        <section
          id="positioning"
          data-testid="positioning-section"
          className="mx-auto max-w-[1240px] px-5 py-24 lg:px-8 lg:py-36"
        >
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true, amount: 0.25 }}
            variants={reveal}
            className="max-w-[760px]"
          >
            <SectionEyebrow>Enough of the endless maybe</SectionEyebrow>

            <h2
              data-testid="positioning-headline"
              className="font-heading text-[clamp(2.7rem,5vw,4.8rem)] leading-[0.98] tracking-[-0.06em]"
            >
              The apps built to keep you swiping aren&apos;t built to help you{" "}
              <em className="font-normal text-[#7a2e2e]">stop.</em>
            </h2>
          </motion.div>

          <div
            data-testid="comparison-grid"
            className="mt-16 grid gap-5 lg:grid-cols-[0.8fr_1.2fr] lg:gap-14"
          >
            <motion.div
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true, amount: 0.25 }}
              variants={reveal}
              className="rounded-[1.7rem] border border-[#e2dacb] bg-[#e2dacb]/35 p-7 lg:p-10"
            >
              <div className="mb-16 flex items-center justify-between">
                <span
                  data-testid="mainstream-label"
                  className="text-xs font-semibold uppercase tracking-[0.18em] text-[#1b1b18]/45"
                >
                  Mainstream apps
                </span>

                <span className="text-[#1b1b18]/35">✕</span>
              </div>

              <p
                data-testid="mainstream-copy"
                className="font-heading text-[2rem] leading-[1.02] tracking-[-0.045em] text-[#1b1b18]/65"
              >
                More matches. Less clarity. A loop that never asks what you&apos;re
                actually looking for.
              </p>
            </motion.div>

            <motion.div
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true, amount: 0.25 }}
              transition={{ staggerChildren: 0.12 }}
              variants={reveal}
              className="rounded-[1.7rem] bg-[#24463b] p-7 text-[#faf6ef] lg:p-10"
            >
              <div className="mb-11 flex items-center justify-between">
                <span
                  data-testid="christimony-label"
                  className="text-xs font-semibold uppercase tracking-[0.18em] text-[#faf6ef]/60"
                >
                  Christimony
                </span>

                <span className="grid size-7 place-items-center rounded-full bg-[#faf6ef] text-[#24463b]">
                  <Check size={15} />
                </span>
              </div>

              <div data-testid="comparison-rows" className="space-y-6">
                {comparisonRows.map(([left, right], index) => (
                  <motion.div
                    key={left}
                    variants={reveal}
                    className="grid grid-cols-[1fr_auto_1.25fr] items-center gap-3 border-b border-[#faf6ef]/15 pb-6 last:border-0 last:pb-0"
                  >
                    <span
                      data-testid={`comparison-mainstream-${index + 1}`}
                      className="text-sm leading-5 text-[#faf6ef]/45"
                    >
                      {left}
                    </span>

                    <ArrowUpRight className="size-4 text-[#e6b9a9]" />

                    <span
                      data-testid={`comparison-christimony-${index + 1}`}
                      className="font-heading text-[1.55rem] leading-none tracking-[-0.04em]"
                    >
                      {right}
                    </span>
                  </motion.div>
                ))}
              </div>
            </motion.div>
          </div>
        </section>

        <section
          data-testid="denomination-quote-section"
          className="border-y border-[#e2dacb] bg-[#e2dacb]/45 px-5 py-24 text-center lg:py-36"
        >
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true, amount: 0.35 }}
            transition={{ duration: 0.8 }}
            className="mx-auto max-w-[980px]"
          >
            <Sparkles
              data-testid="quote-sparkle-icon"
              className="mx-auto mb-7 size-5 text-[#7a2e2e]"
            />

            <blockquote
              data-testid="denomination-quote"
              className="font-heading text-[clamp(2.5rem,5.1vw,5rem)] leading-[0.98] tracking-[-0.06em]"
            >
              &quot;Your denomination is not a footnote. It can be part of the{" "}
              <em className="font-normal text-[#7a2e2e]">foundation.</em>&quot;
            </blockquote>

            <p
              data-testid="denomination-quote-caption"
              className="mt-7 text-xs font-semibold uppercase tracking-[0.2em] text-[#1b1b18]/50"
            >
              Catholic · Orthodox · Pentecostal · Baptist · and more
            </p>
          </motion.div>
        </section>

        <section
          id="how-it-works"
          data-testid="how-it-works-section"
          className="mx-auto max-w-[1240px] px-5 py-24 lg:px-8 lg:py-36"
        >
          <div className="grid gap-14 lg:grid-cols-[0.7fr_1.3fr] lg:gap-24">
            <motion.div
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true, amount: 0.25 }}
              variants={reveal}
            >
              <SectionEyebrow>How it works</SectionEyebrow>

              <h2
                data-testid="how-it-works-headline"
                className="max-w-[430px] font-heading text-[clamp(2.8rem,5vw,4.5rem)] leading-[0.98] tracking-[-0.06em]"
              >
                A search with room for{" "}
                <em className="font-normal text-[#7a2e2e]">meaning.</em>
              </h2>

              <p
                data-testid="how-it-works-description"
                className="mt-6 max-w-[330px] text-[15px] leading-6 text-[#1b1b18]/60"
              >
                Less noise. More context. A path that respects the weight of
                the decision you&apos;re making.
              </p>
            </motion.div>

            <motion.div
              data-testid="steps-list"
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true, amount: 0.2 }}
              transition={{ staggerChildren: 0.14 }}
              className="space-y-11"
            >
              {[
                {
                  number: "01",
                  icon: Users,
                  title: "Create a profile",
                  copy: "Share the faith, values, and intentions you want a future spouse to understand.",
                },
                {
                  number: "02",
                  icon: Sparkles,
                  title: "Browse with intention",
                  copy: "See people through the lens of denomination, direction, and what you both hope to build.",
                },
                {
                  number: "03",
                  icon: Heart,
                  title: "Connect at the right pace",
                  copy: "Move from a thoughtful introduction to a real conversation when it feels right.",
                },
              ].map(({ number, icon: Icon, title, copy }) => (
                <motion.div
                  key={number}
                  variants={reveal}
                  data-testid={`step-${number}`}
                  className="group relative grid grid-cols-[72px_1fr] gap-5 border-t border-[#e2dacb] pt-6 sm:grid-cols-[100px_1fr] sm:gap-8"
                >
                  <span
                    data-testid={`step-number-${number}`}
                    className="font-heading text-[4.5rem] leading-[0.72] tracking-[-0.08em] text-[#e2dacb] transition-colors duration-200 group-hover:text-[#7a2e2e]/30"
                  >
                    {number}
                  </span>

                  <div>
                    <div className="flex items-center gap-3">
                      <Icon
                        data-testid={`step-icon-${number}`}
                        size={17}
                        className="text-[#7a2e2e]"
                      />

                      <h3
                        data-testid={`step-title-${number}`}
                        className="font-heading text-[1.7rem] tracking-[-0.045em]"
                      >
                        {title}
                      </h3>
                    </div>

                    <p
                      data-testid={`step-copy-${number}`}
                      className="mt-3 max-w-[500px] text-[15px] leading-6 text-[#1b1b18]/60"
                    >
                      {copy}
                    </p>
                  </div>
                </motion.div>
              ))}
            </motion.div>
          </div>
        </section>

        <section
          ref={featureRef}
          data-testid="family-feature-section"
          className="relative isolate overflow-hidden bg-[#7a2e2e] px-5 py-24 text-[#faf6ef] lg:px-8 lg:py-32"
        >
          <motion.div
            data-testid="family-feature-texture"
            style={reduceMotion ? undefined : { y: featureTextureY }}
            className="pointer-events-none absolute inset-0 -z-10 opacity-35 [background-image:radial-gradient(rgba(250,246,239,0.26)_0.7px,transparent_0.7px)] [background-size:24px_24px]"
          />

          <div className="mx-auto grid max-w-[1180px] gap-12 lg:grid-cols-[0.85fr_1.15fr] lg:items-center lg:gap-24">
            <motion.div
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true, amount: 0.25 }}
              variants={reveal}
            >
              <SectionEyebrow dark>Our signature difference</SectionEyebrow>

              <h2
                data-testid="family-feature-headline"
                className="max-w-[580px] font-heading text-[clamp(3rem,5.8vw,5.5rem)] leading-[0.91] tracking-[-0.065em]"
              >
                Family-guided.{" "}
                <em className="font-normal text-[#f1c7b7]">
                  Never family-decided.
                </em>
              </h2>

              <div
                data-testid="family-feature-rule"
                className="mt-10 h-px w-24 bg-[#faf6ef]/40"
              />
            </motion.div>

            <motion.div
              initial="hidden"
              whileInView="visible"
              viewport={{ once: true, amount: 0.25 }}
              variants={reveal}
              className="grid gap-8 md:grid-cols-[0.9fr_1.1fr] md:items-end"
            >
              <div className="overflow-hidden rounded-[1.7rem]">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img
                  data-testid="family-feature-image"
                  src={familyImage}
                  alt="A young woman sharing a joyful moment with family around a dining table"
                  width={1264}
                  height={848}
                  loading="lazy"
                  className="aspect-[1.15] w-full object-cover transition duration-500 hover:scale-105"
                />
              </div>

              <div>
                <p
                  data-testid="family-feature-description"
                  className="font-heading text-[2rem] leading-[1.05] tracking-[-0.045em]"
                >
                  Invite the people who know you best to help open a door —
                  while you keep the key.
                </p>

                <p
                  data-testid="family-feature-supporting-copy"
                  className="mt-6 text-sm leading-6 text-[#faf6ef]/70"
                >
                  A parent or trusted family member can guide a profile and
                  suggest an introduction. But before a connection opens, the
                  person being introduced gets their own private moment to say
                  yes. No pressure. No proxy decisions.
                </p>

                <Link
                  data-testid="family-feature-learn-more-link"
                  href="/signup"
                  className="mt-7 inline-flex items-center rounded-full border border-[#faf6ef]/40 px-5 py-3 text-sm font-semibold transition duration-200 hover:-translate-y-1 hover:border-[#faf6ef]"
                >
                  Explore the idea{" "}
                  <ArrowUpRight className="ml-2 size-4" />
                </Link>
              </div>
            </motion.div>
          </div>
        </section>

        <section
          id="faq"
          data-testid="faq-section"
          className="mx-auto max-w-[950px] px-5 py-24 lg:py-36"
        >
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true, amount: 0.25 }}
            variants={reveal}
            className="mb-12"
          >
            <SectionEyebrow>Good questions</SectionEyebrow>

            <h2
              data-testid="faq-headline"
              className="font-heading text-[clamp(2.8rem,5vw,4.6rem)] leading-[0.96] tracking-[-0.06em]"
            >
              Clarity is part of{" "}
              <em className="font-normal text-[#7a2e2e]">care.</em>
            </h2>
          </motion.div>

          <div
            data-testid="faq-list"
            className="border-t border-[#e2dacb]"
          >
            {faqs.map((faq, index) => {
              const isOpen = openFaq === index;

              return (
                <div
                  data-testid={`faq-item-${index + 1}`}
                  key={faq.question}
                  className="border-b border-[#e2dacb]"
                >
                  <button
                    data-testid={`faq-toggle-${index + 1}`}
                    type="button"
                    aria-expanded={isOpen}
                    onClick={() => setOpenFaq(isOpen ? null : index)}
                    className="flex w-full items-center justify-between gap-6 py-6 text-left"
                  >
                    <span
                      data-testid={`faq-question-${index + 1}`}
                      className="font-heading text-[1.45rem] leading-tight tracking-[-0.04em] sm:text-[1.7rem]"
                    >
                      {faq.question}
                    </span>

                    <span
                      className={`grid size-8 shrink-0 place-items-center rounded-full border border-[#e2dacb] transition duration-200 ${
                        isOpen
                          ? "rotate-180 bg-[#24463b] text-[#faf6ef]"
                          : "text-[#7a2e2e]"
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
                        <p className="max-w-[760px] pb-7 pr-12 text-sm leading-6 text-[#1b1b18]/65">
                          {faq.answer}
                        </p>
                      </motion.div>
                    )}
                  </AnimatePresence>
                </div>
              );
            })}
          </div>
        </section>

        <section
          data-testid="final-cta-section"
          className="border-t border-[#e2dacb] bg-[#24463b] px-5 py-28 text-center text-[#faf6ef] lg:py-40"
        >
          <motion.div
            initial="hidden"
            whileInView="visible"
            viewport={{ once: true, amount: 0.3 }}
            variants={reveal}
            className="mx-auto max-w-[780px]"
          >
            <SectionEyebrow dark>
              For the life you&apos;re hoping to build
            </SectionEyebrow>

            <h2
              data-testid="final-cta-headline"
              className="font-heading text-[clamp(3rem,6vw,5.8rem)] leading-[0.93] tracking-[-0.07em]"
            >
              The right search can change your{" "}
              <em className="font-normal text-[#e6b9a9]">whole life.</em>
            </h2>

            <Link
              data-testid="final-cta-signup-link"
              href="/signup"
              className="mt-10 inline-flex items-center rounded-full bg-[#faf6ef] px-7 py-4 text-sm font-semibold text-[#24463b] transition duration-200 hover:-translate-y-1 hover:bg-white hover:shadow-xl"
            >
              Get started with Christimony{" "}
              <ArrowUpRight className="ml-2 size-4" />
            </Link>
          </motion.div>
        </section>
      </main>

      <footer
        data-testid="site-footer"
        className="bg-[#1b1b18] px-5 py-10 text-[#faf6ef] lg:px-8"
      >
        <div className="mx-auto flex max-w-[1240px] flex-col gap-9 md:flex-row md:items-end md:justify-between">
          <div>
            <Wordmark testId="footer-brand-wordmark" light />

            <p
              data-testid="footer-tagline"
              className="mt-5 max-w-[230px] text-sm leading-5 text-[#faf6ef]/45"
            >
              A more intentional way to search for a spouse.
            </p>
          </div>

          <div
            data-testid="footer-links"
            className="flex flex-wrap gap-x-6 gap-y-3 text-xs text-[#faf6ef]/60"
          >
            <Link
              data-testid="footer-login-link"
              href="/login"
              className="transition hover:text-[#faf6ef]"
            >
              Log in
            </Link>

            <Link
              data-testid="footer-signup-link"
              href="/signup"
              className="transition hover:text-[#faf6ef]"
            >
              Sign up
            </Link>

            <Link
              data-testid="footer-about-link"
              href="#positioning"
              className="transition hover:text-[#faf6ef]"
            >
              About
            </Link>

            <Link
              data-testid="footer-privacy-link"
              href="#faq"
              className="transition hover:text-[#faf6ef]"
            >
              Privacy
            </Link>

            <Link
              data-testid="footer-terms-link"
              href="#faq"
              className="transition hover:text-[#faf6ef]"
            >
              Terms
            </Link>
          </div>

          <p
            data-testid="footer-copyright"
            className="text-xs text-[#faf6ef]/35"
          >
            © {new Date().getFullYear()} Christimony
          </p>
        </div>
      </footer>
    </div>
  );
}
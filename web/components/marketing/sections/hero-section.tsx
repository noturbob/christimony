"use client";

import { useRef } from "react";
import { motion, useReducedMotion, useScroll, useTransform } from "motion/react";
import Image from "next/image";
import Link from "next/link";
import { ArrowDown, ArrowUpRight, ShieldCheck } from "lucide-react";
import { useGSAP } from "@gsap/react";
import { ensureGsapRegistered, gsap, SplitText } from "@/lib/gsap";
import { SectionEyebrow } from "../shared";

export function HeroSection() {
  const reduceMotion = useReducedMotion();
  const heroRef = useRef<HTMLElement>(null);
  const headlineRef = useRef<HTMLHeadingElement>(null);
  const imageWrapRef = useRef<HTMLDivElement>(null);

  const { scrollYProgress: heroProgress } = useScroll({
    target: heroRef,
    offset: ["start start", "end start"],
  });
  const heroTextureY = useTransform(heroProgress, [0, 1], [0, 90]);

  useGSAP(
    () => {
      if (reduceMotion) return;
      ensureGsapRegistered();

      const split = SplitText.create(headlineRef.current, {
        type: "lines",
        mask: "lines",
        linesClass: "line",
      });

      gsap.set(split.lines, { yPercent: 110 });
      gsap
        .timeline({ delay: 0.35 })
        .to(split.lines, { yPercent: 0, duration: 1, ease: "power4.out", stagger: 0.09 })
        .fromTo(
          imageWrapRef.current,
          { clipPath: "inset(12% 12% 12% 12% round 1.7rem)", scale: 1.08 },
          { clipPath: "inset(0% 0% 0% 0% round 1.7rem)", scale: 1, duration: 1.2, ease: "power3.out" },
          0.15
        );

      return () => split.revert();
    },
    { scope: heroRef, dependencies: [reduceMotion] }
  );

  return (
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
          <SectionEyebrow dark>For the seriously hopeful</SectionEyebrow>

          <h1
            ref={headlineRef}
            data-testid="hero-headline"
            className="max-w-[700px] font-heading text-[clamp(3.3rem,7.4vw,5.8rem)] leading-[0.94] tracking-[-0.065em]"
          >
            Marriage, sought with intention — <em className="font-normal text-[#e6b9a9]">not swiped past.</em>
          </h1>

          <p data-testid="hero-subheadline" className="mt-7 max-w-[520px] text-[17px] leading-7 text-[#faf6ef]/72">
            A modern matrimony platform for Christians looking for a spouse, shaped by faith, clear intentions, and
            the people who love you.
          </p>

          <div data-testid="hero-cta-group" className="mt-9 flex flex-col gap-3 sm:flex-row">
            <Link
              data-testid="hero-get-started-link"
              href="/signup"
              className="inline-flex items-center justify-center rounded-full bg-[#faf6ef] px-6 py-3.5 text-sm font-semibold text-[#24463b] transition duration-200 hover:-translate-y-1 hover:bg-white hover:shadow-xl"
            >
              Begin your search <ArrowUpRight className="ml-2 size-4" />
            </Link>

            <Link
              data-testid="hero-learn-more-link"
              href="#how-it-works"
              className="inline-flex items-center justify-center rounded-full border border-[#faf6ef]/40 px-6 py-3.5 text-sm font-semibold text-[#faf6ef] transition duration-200 hover:-translate-y-1 hover:border-[#faf6ef]"
            >
              See how it works <ArrowDown className="ml-2 size-4" />
            </Link>
          </div>

          <div data-testid="hero-trust-note" className="mt-8 flex items-center gap-2 text-xs text-[#faf6ef]/55">
            <ShieldCheck size={15} />
            Intentions first. Privacy always.
          </div>
        </motion.div>

        <motion.div
          initial={reduceMotion ? false : { opacity: 0, y: 32, rotate: 2 }}
          animate={{ opacity: 1, y: 0, rotate: 2 }}
          transition={{ duration: 0.9, delay: 0.22 }}
          className="relative mt-14 ml-auto w-[87%] max-w-[500px] lg:mt-0 lg:w-[42%]"
        >
          <div className="absolute -inset-3 rounded-[2rem] border border-[#faf6ef]/20" />

          <div ref={imageWrapRef} className="overflow-hidden rounded-[1.7rem] shadow-2xl">
            <Image
              data-testid="hero-couple-image"
              src="/images/hero-couple.jpg"
              alt="A couple walking together through a sunlit garden"
              width={1264}
              height={848}
              preload
              className="aspect-[1.18] w-full object-cover"
            />
          </div>

          <div
            data-testid="hero-image-caption"
            className="absolute -bottom-5 -left-5 max-w-[230px] rounded-2xl bg-[#faf6ef] p-4 text-[#1b1b18] shadow-xl"
          >
            <p className="font-heading text-xl leading-none">A slower way to find each other.</p>
            <p className="mt-2 text-[11px] uppercase tracking-[0.14em] text-[#1b1b18]/50">Built around real life</p>
          </div>
        </motion.div>
      </div>

      <div className="absolute bottom-6 left-5 text-[10px] uppercase tracking-[0.22em] text-[#faf6ef]/45 lg:left-8">
        01 / 09
      </div>
    </section>
  );
}

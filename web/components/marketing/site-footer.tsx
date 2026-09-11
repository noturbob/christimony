"use client";

import { useEffect, useRef } from "react";
import Link from "next/link";
import { ensureGsapRegistered, gsap } from "@/lib/gsap";
import { Wordmark } from "./shared";

export function SiteFooter() {
  const bigWordRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!bigWordRef.current) return;
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

    ensureGsapRegistered();

    const ctx = gsap.context(() => {
      gsap.fromTo(
        bigWordRef.current,
        { clipPath: "inset(0 100% 0 0)" },
        {
          clipPath: "inset(0 0% 0 0)",
          ease: "none",
          scrollTrigger: {
            trigger: bigWordRef.current,
            start: "top 95%",
            end: "top 45%",
            scrub: 0.6,
          },
        }
      );
    });

    return () => ctx.revert();
  }, []);

  return (
    <footer data-testid="site-footer" className="bg-[#1b1b18] px-5 pt-14 pb-10 text-[#faf6ef] lg:px-8">
      <div className="mx-auto max-w-[1240px]">
        <div className="flex flex-col gap-9 md:flex-row md:items-end md:justify-between">
          <div>
            <Wordmark testId="footer-brand-wordmark" light />
            <p data-testid="footer-tagline" className="mt-5 max-w-[230px] text-sm leading-5 text-[#faf6ef]/45">
              A more intentional way to search for a spouse.
            </p>
          </div>

          <div data-testid="footer-links" className="flex flex-wrap gap-x-6 gap-y-3 text-xs text-[#faf6ef]/60">
            <Link data-testid="footer-login-link" href="/login" className="transition hover:text-[#faf6ef]">
              Log in
            </Link>
            <Link data-testid="footer-signup-link" href="/signup" className="transition hover:text-[#faf6ef]">
              Sign up
            </Link>
            <Link data-testid="footer-about-link" href="#positioning" className="transition hover:text-[#faf6ef]">
              About
            </Link>
            <Link data-testid="footer-privacy-link" href="#faq" className="transition hover:text-[#faf6ef]">
              Privacy
            </Link>
            <Link data-testid="footer-terms-link" href="#faq" className="transition hover:text-[#faf6ef]">
              Terms
            </Link>
          </div>

          <p data-testid="footer-copyright" className="text-xs text-[#faf6ef]/35">
            © {new Date().getFullYear()} Christimony
          </p>
        </div>

        <div className="mt-14 overflow-hidden border-t border-[#faf6ef]/10 pt-8">
          <div ref={bigWordRef} className="font-display text-[clamp(3rem,13vw,11rem)] leading-[0.85] tracking-[-0.05em] text-[#faf6ef] select-none">
            Christimony
          </div>
        </div>
      </div>
    </footer>
  );
}

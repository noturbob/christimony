"use client";

import { useEffect, useRef } from "react";
import Link from "next/link";
import { cancelIdle, ensureGsapRegistered, gsap, scheduleIdle } from "@/lib/gsap";
import { Wordmark } from "./shared";

export function SiteFooter() {
  const bigWordRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!bigWordRef.current) return;
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;

    ensureGsapRegistered();

    // Same deferral the other sections got: building this ScrollTrigger
    // reads the footer's position, and there is no reason for that to
    // happen in the same tick as hydration.
    let ctx: gsap.Context | undefined;
    const idle = scheduleIdle(() => {
      ctx = gsap.context(() => {
        // A scrubbed tween (progress tied to scroll position) doesn't work
        // here: this is the last element on the page, so there's often too
        // little scroll room left after it comes into view for the scrub
        // to ever reach 100% -- it was getting stuck mid-reveal. A one-shot
        // tween with its own fixed duration, played once on entry, always
        // completes regardless of how much scroll room remains.
        //
        // The wipe used to be an animated `clip-path: inset()` on the word
        // itself. Transform is on WebKit's short list of compositor-resolved
        // properties; clip-path is not, so every frame re-rasterized a
        // full-width run of ~50px display-serif glyphs on the main thread.
        // Two solid covers in the footer's own background colour, scaled
        // out from the centre, are pixel-identical and never touch the text
        // layer at all.
        gsap.fromTo(
          ".footer-wordmark-cover",
          { scaleX: 1 },
          {
            scaleX: 0,
            duration: 1.1,
            ease: "power3.out",
            scrollTrigger: {
              trigger: bigWordRef.current,
              start: "top 95%",
              toggleActions: "play none none none",
            },
          }
        );
      }, bigWordRef);
    });

    return () => {
      cancelIdle(idle);
      ctx?.revert();
    };
  }, []);

  return (
    <footer
      data-testid="site-footer"
      style={{ paddingBottom: "max(2.5rem, env(safe-area-inset-bottom))" }}
      className="bg-[#1b1b18] px-5 pt-14 text-[#faf6ef] lg:px-8"
    >
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

        <div className="mt-14 border-t border-[#faf6ef]/10 pt-8 text-center">
          <div
            ref={bigWordRef}
            className="relative font-display text-[clamp(2.5rem,13vw,10.5rem)] leading-[1.15] tracking-[-0.05em] text-[#faf6ef] select-none pb-[0.08em]"
          >
            Christimony
            {/* Default state is uncovered, so the word is readable if the
                tween never runs (no JS, reduced motion). GSAP sets the covers
                back to scaleX(1) when it builds the tween. */}
            <span
              aria-hidden
              className="footer-wordmark-cover pointer-events-none absolute inset-y-0 left-0 w-1/2 origin-left [transform:scaleX(0)] bg-[#1b1b18]"
            />
            <span
              aria-hidden
              className="footer-wordmark-cover pointer-events-none absolute inset-y-0 right-0 w-1/2 origin-right [transform:scaleX(0)] bg-[#1b1b18]"
            />
          </div>
        </div>
      </div>
    </footer>
  );
}

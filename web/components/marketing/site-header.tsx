"use client";

import { useEffect, useState } from "react";
import { AnimatePresence, motion } from "motion/react";
import Link from "next/link";
import { Wordmark } from "./shared";
import { ArrowGlyph, MenuGlyph } from "./icons";

export function SiteHeader() {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 24);
    window.addEventListener("scroll", onScroll, { passive: true });
    onScroll();
    return () => window.removeEventListener("scroll", onScroll);
  }, []);

  const closeMobile = () => setMobileOpen(false);

  return (
    <header
      data-testid="site-header"
      style={{ paddingTop: "env(safe-area-inset-top)" }}
      className={`fixed inset-x-0 top-0 z-50 transition-[background-color,backdrop-filter,box-shadow] duration-300 ${
        scrolled ? "bg-[#faf6ef]/90 shadow-[0_1px_0_rgba(27,27,24,0.08)] backdrop-blur-xl" : "bg-transparent"
      }`}
    >
      <nav
        data-testid="primary-navigation"
        aria-label="Primary navigation"
        className="mx-auto flex h-[76px] max-w-[1240px] items-center justify-between px-5 lg:px-8"
      >
        <Wordmark testId="header-brand-wordmark" light={!scrolled} />

        <div data-testid="desktop-navigation-links" className="hidden items-center gap-8 md:flex">
          <Link
            data-testid="nav-how-it-works-link"
            href="#how-it-works"
            className={`text-[13px] font-medium transition-colors hover:text-[#7a2e2e] ${scrolled ? "text-[#1b1b18]/70" : "text-[#faf6ef]/75"}`}
          >
            How it works
          </Link>

          <Link
            data-testid="nav-faq-link"
            href="#faq"
            className={`text-[13px] font-medium transition-colors hover:text-[#7a2e2e] ${scrolled ? "text-[#1b1b18]/70" : "text-[#faf6ef]/75"}`}
          >
            Questions
          </Link>

          <Link
            data-testid="nav-login-link"
            href="/login"
            className={`text-[13px] font-medium transition-colors hover:text-[#7a2e2e] ${scrolled ? "text-[#1b1b18]/70" : "text-[#faf6ef]/75"}`}
          >
            Log in
          </Link>

          <Link
            data-testid="nav-get-started-link"
            href="/signup"
            className={`rounded-full px-5 py-2.5 text-[13px] font-semibold transition duration-200 hover:-translate-y-0.5 hover:shadow-lg ${
              scrolled ? "bg-[#24463b] text-[#faf6ef]" : "bg-[#faf6ef] text-[#24463b]"
            }`}
          >
            Get started <ArrowGlyph className="ml-1 inline size-3.5" />
          </Link>
        </div>

        <button
          data-testid="mobile-menu-toggle"
          type="button"
          aria-label={mobileOpen ? "Close menu" : "Open menu"}
          aria-expanded={mobileOpen}
          onClick={() => setMobileOpen(!mobileOpen)}
          className={`grid size-10 place-items-center rounded-full md:hidden ${scrolled ? "text-[#1b1b18]" : "text-[#faf6ef]"}`}
        >
          <MenuGlyph open={mobileOpen} className="size-4" />
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
              <Link data-testid="mobile-how-it-works-link" href="#how-it-works" onClick={closeMobile} className="font-medium">
                How it works
              </Link>
              <Link data-testid="mobile-faq-link" href="#faq" onClick={closeMobile} className="font-medium">
                Questions
              </Link>
              <Link data-testid="mobile-login-link" href="/login" onClick={closeMobile} className="font-medium">
                Log in
              </Link>
              <Link
                data-testid="mobile-get-started-link"
                href="/signup"
                onClick={closeMobile}
                className="rounded-full bg-[#24463b] px-5 py-3 text-center font-semibold text-[#faf6ef]"
              >
                Get started <ArrowGlyph className="ml-1 inline size-4" />
              </Link>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </header>
  );
}

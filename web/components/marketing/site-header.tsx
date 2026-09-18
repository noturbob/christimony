"use client";

import { useEffect, useState } from "react";
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
      className={`fixed inset-x-0 top-0 z-50 transition-[background-color,box-shadow] duration-300 ${
        scrolled ? "bg-[#0f1311]/80 shadow-[0_1px_0_var(--line)] backdrop-blur-md" : "bg-transparent"
      }`}
    >
      <nav
        data-testid="primary-navigation"
        aria-label="Primary navigation"
        className="mx-auto flex h-[76px] max-w-[1280px] items-center justify-between px-5 lg:px-8"
      >
        <Wordmark testId="header-brand-wordmark" />

        <div data-testid="desktop-navigation-links" className="hidden items-center gap-7 md:flex">
          <Link
            data-testid="nav-how-it-works-link"
            href="#how-it-works"
            className="text-[16px] text-[var(--chalk)]/70 transition-colors hover:text-[var(--chalk)]"
          >
            How it works
          </Link>

          <Link
            data-testid="nav-faq-link"
            href="#faq"
            className="text-[16px] text-[var(--chalk)]/70 transition-colors hover:text-[var(--chalk)]"
          >
            Questions
          </Link>

          <Link
            data-testid="nav-login-link"
            href="/login"
            className="text-[16px] text-[var(--chalk)]/70 transition-colors hover:text-[var(--chalk)]"
          >
            Log in
          </Link>

          <Link
            data-testid="nav-get-started-link"
            href="/signup"
            className="pill pill-cta !px-5 !py-2.5 !text-[15px]"
          >
            Get started <ArrowGlyph className="size-3.5" />
          </Link>
        </div>

        <button
          data-testid="mobile-menu-toggle"
          type="button"
          aria-label={mobileOpen ? "Close menu" : "Open menu"}
          aria-expanded={mobileOpen}
          onClick={() => setMobileOpen(!mobileOpen)}
          className="grid size-10 place-items-center rounded-full text-[var(--chalk)] md:hidden"
        >
          <MenuGlyph open={mobileOpen} className="size-4" />
        </button>
      </nav>

      {/* Third attempt at this panel, and the first that animates nothing
          the layout engine has to re-run. `height` (Framer) and then
          `max-height` are both layout-affecting: WebKit re-lays-out and
          repaints the header subtree on every frame of the transition,
          which is what read as "chunky". `transform` is one of the few
          properties WebKit resolves on the compositor, so that's all that
          moves here: the panel sits at its natural height inside an
          overflow-hidden box and slides up out of it by exactly 100% of
          its own height. Because it's `absolute`, the box never changes
          the header's height either -- zero layout, open or closed.
          (`grid-template-rows: 0fr -> 1fr` is not an option: on an
          auto-height single-row container WebKit sizes the row from its
          content rather than collapsing it, so the closed state stayed
          visibly open.) The border can go back to being unconditional --
          a border-top does paint regardless of its box's height, but this
          one is on the translated panel, above the clip, not on the
          clipping box itself. `pointer-events-none` is what actually lets
          taps through to the page while closed; `inert` is for focus and
          the accessibility tree. */}
      <div
        data-testid="mobile-navigation-menu"
        inert={!mobileOpen}
        className={`absolute inset-x-0 top-full overflow-hidden md:hidden ${mobileOpen ? "" : "pointer-events-none"}`}
      >
        <div
          className={`border-b border-[var(--line)] bg-[var(--ink)] px-5 pb-8 transition-transform duration-300 ease-out will-change-transform ${
            mobileOpen ? "[transform:translateY(0)]" : "[transform:translateY(-100%)]"
          }`}
        >
          <div className="flex flex-col gap-5 pt-6 text-[34px] font-semibold leading-none tracking-[-0.03em]">
            <Link data-testid="mobile-how-it-works-link" href="#how-it-works" onClick={closeMobile} className="transition-colors hover:text-[var(--sage)]">
              How it works
            </Link>
            <Link data-testid="mobile-faq-link" href="#faq" onClick={closeMobile} className="transition-colors hover:text-[var(--sage)]">
              Questions
            </Link>
            <Link data-testid="mobile-login-link" href="/login" onClick={closeMobile} className="transition-colors hover:text-[var(--sage)]">
              Log in
            </Link>
            <Link
              data-testid="mobile-get-started-link"
              href="/signup"
              onClick={closeMobile}
              className="pill pill-cta mt-3 w-full"
            >
              Get started <ArrowGlyph className="size-4" />
            </Link>
          </div>
        </div>
      </div>
    </header>
  );
}

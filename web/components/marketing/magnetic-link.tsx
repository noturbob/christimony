"use client";

import { useRef } from "react";
import Link, { type LinkProps } from "next/link";
import { useGSAP } from "@gsap/react";
import { ensureGsapRegistered, gsap } from "@/lib/gsap";

type MagneticLinkProps = LinkProps & {
  className?: string;
  children: React.ReactNode;
  "data-testid"?: string;
};

// Cursor-following "magnetic" pull, GSAP quickTo for near-zero overhead
// per mousemove. Skipped entirely on touch devices (no cursor to follow)
// and under prefers-reduced-motion.
export function MagneticLink({ children, ...props }: MagneticLinkProps) {
  const ref = useRef<HTMLAnchorElement>(null);

  useGSAP(
    () => {
      if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return;
      if (window.matchMedia("(pointer: coarse)").matches) return;
      ensureGsapRegistered();

      const el = ref.current;
      if (!el) return;

      const xTo = gsap.quickTo(el, "x", { duration: 0.5, ease: "power3" });
      const yTo = gsap.quickTo(el, "y", { duration: 0.5, ease: "power3" });

      function handleMove(e: MouseEvent) {
        const rect = el!.getBoundingClientRect();
        xTo((e.clientX - rect.left - rect.width / 2) * 0.35);
        yTo((e.clientY - rect.top - rect.height / 2) * 0.35);
      }
      function handleLeave() {
        xTo(0);
        yTo(0);
      }

      el.addEventListener("mousemove", handleMove);
      el.addEventListener("mouseleave", handleLeave);
      return () => {
        el.removeEventListener("mousemove", handleMove);
        el.removeEventListener("mouseleave", handleLeave);
      };
    },
    { scope: ref }
  );

  return (
    <Link ref={ref} {...props}>
      {children}
    </Link>
  );
}

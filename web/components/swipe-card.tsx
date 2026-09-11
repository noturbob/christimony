"use client";

import { animate, motion, useMotionValue, useTransform, type PanInfo } from "motion/react";
import { ReactNode } from "react";

const THRESHOLD = 120;
const FLING_VELOCITY = 600;
const EXIT_DISTANCE = 500;

export function SwipeCard({
  children,
  onSwiped,
  disabled,
  className,
}: {
  children: ReactNode;
  onSwiped: (direction: "like" | "pass") => void;
  disabled?: boolean;
  className?: string;
}) {
  const x = useMotionValue(0);
  const rotate = useTransform(x, [-300, 300], [-16, 16]);
  const likeOpacity = useTransform(x, [24, 140], [0, 1]);
  const passOpacity = useTransform(x, [-140, -24], [1, 0]);

  function handleDragEnd(_event: unknown, info: PanInfo) {
    if (disabled) return;

    if (info.offset.x > THRESHOLD || info.velocity.x > FLING_VELOCITY) {
      animate(x, EXIT_DISTANCE, { duration: 0.25, ease: "easeOut" });
      setTimeout(() => onSwiped("like"), 180);
    } else if (info.offset.x < -THRESHOLD || info.velocity.x < -FLING_VELOCITY) {
      animate(x, -EXIT_DISTANCE, { duration: 0.25, ease: "easeOut" });
      setTimeout(() => onSwiped("pass"), 180);
    } else {
      animate(x, 0, { type: "spring", stiffness: 320, damping: 26 });
    }
  }

  return (
    <motion.div
      style={{ x, rotate }}
      drag={disabled ? false : "x"}
      dragElastic={0.6}
      onDragEnd={handleDragEnd}
      className={className}
    >
      {/* A second, non-transformed clipping layer -- Chromium doesn't
          reliably clip rounded corners on an element that also has a
          `transform` (this motion.div always has one, even at rest, since
          framer-motion sets `x`/`rotate` unconditionally), which showed up
          as small square slivers poking past the rounded corners. This
          inner div inherits the same radius but carries no transform of
          its own, so its clip renders correctly and covers the outer
          element's bleed. It also doubles as the card's single scroll
          region, so longer profiles scroll in place instead of growing
          the card. */}
      <div className="h-full overflow-y-auto overscroll-contain rounded-[inherit] scroll-fade-b">
        {children}
      </div>
      <motion.div
        style={{ opacity: likeOpacity }}
        className="pointer-events-none absolute top-8 left-6 -rotate-12 rounded-lg border-4 border-primary px-3 py-1 font-display text-2xl font-bold text-primary"
      >
        LIKE
      </motion.div>
      <motion.div
        style={{ opacity: passOpacity }}
        className="pointer-events-none absolute top-8 right-6 rotate-12 rounded-lg border-4 border-muted-foreground px-3 py-1 font-display text-2xl font-bold text-muted-foreground"
      >
        PASS
      </motion.div>
    </motion.div>
  );
}

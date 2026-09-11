// Hand-drawn, single-stroke marks for the marketing page instead of a
// generic icon library — a handful of bespoke SVGs/CSS shapes rather
// than dropping in Lucide's (or any library's) off-the-shelf glyphs.

type SvgProps = React.SVGProps<SVGSVGElement>;

export function ArrowGlyph({ direction = "up-right", style, ...props }: SvgProps & { direction?: "up-right" | "down" }) {
  return (
    <svg
      viewBox="0 0 16 16"
      fill="none"
      style={direction === "down" ? { ...style, transform: "rotate(90deg)" } : style}
      aria-hidden="true"
      {...props}
    >
      <path d="M4 12L12 4M12 4H5.5M12 4V10.5" stroke="currentColor" strokeWidth={1.4} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

export function CheckGlyph(props: SvgProps) {
  return (
    <svg viewBox="0 0 16 16" fill="none" aria-hidden="true" {...props}>
      <path d="M3.5 8.5L6.5 11.5L12.5 4.5" stroke="currentColor" strokeWidth={1.6} strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  );
}

// A plus that rotates its vertical stroke away to read as a minus --
// used for the FAQ toggle instead of a chevron.
export function PlusMinusGlyph({ open, className, ...props }: { open: boolean; className?: string } & React.HTMLAttributes<HTMLSpanElement>) {
  return (
    <span className={`relative block ${className ?? "size-3.5"}`} aria-hidden="true" {...props}>
      <span className="absolute inset-y-0 left-1/2 w-px -translate-x-1/2 bg-current" />
      <span
        className="absolute inset-x-0 top-1/2 h-px -translate-y-1/2 bg-current transition-transform duration-300"
        style={{ transform: open ? "translateY(-50%) rotate(90deg)" : "translateY(-50%) rotate(0deg)" }}
      />
    </span>
  );
}

// Three bars that morph into an X -- pure CSS transforms, no path data.
export function MenuGlyph({ open, className, ...props }: { open: boolean; className?: string } & React.HTMLAttributes<HTMLSpanElement>) {
  return (
    <span className={`relative block ${className ?? "size-4"}`} aria-hidden="true" {...props}>
      {[0, 1, 2].map((i) => (
        <span
          key={i}
          className="absolute left-0 h-px w-full bg-current transition-all duration-300"
          style={
            open
              ? i === 1
                ? { top: "50%", opacity: 0 }
                : { top: "50%", transform: `rotate(${i === 0 ? 45 : -45}deg)` }
              : { top: `${i * 45}%`, transform: "rotate(0deg)" }
          }
        />
      ))}
    </span>
  );
}

// A small flourish used in place of a decorative icon (quote marks,
// section accents) -- a thin diamond rather than a library sparkle/star.
export function DiamondGlyph(props: SvgProps) {
  return (
    <svg viewBox="0 0 16 16" fill="none" aria-hidden="true" {...props}>
      <path d="M8 1L11 8L8 15L5 8L8 1Z" stroke="currentColor" strokeWidth={1.2} strokeLinejoin="round" />
    </svg>
  );
}

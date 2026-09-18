import { useId } from "react";

// The Christimony mark: a cross drawn as four separate arms -- the many
// traditions -- that all meet at one ring, the marriage at the centre.
// Keep in sync with app/icon.svg (the same mark on a tile).
export function LogoMark({ className }: { className?: string }) {
  const id = useId();
  return (
    <svg viewBox="0 0 64 64" className={className} aria-hidden="true">
      <defs>
        <linearGradient id={id} x1="14" y1="3" x2="50" y2="61" gradientUnits="userSpaceOnUse">
          <stop offset="0" stopColor="#d4f7b5" />
          <stop offset="0.5" stopColor="#5fd39a" />
          <stop offset="1" stopColor="#1b7a55" />
        </linearGradient>
      </defs>
      <g fill={`url(#${id})`}>
        <rect x="28" y="3" width="8" height="12" rx="4" />
        <rect x="28" y="31" width="8" height="30" rx="4" />
        <rect x="9" y="19" width="12" height="8" rx="4" />
        <rect x="43" y="19" width="12" height="8" rx="4" />
      </g>
      <circle cx="32" cy="23" r="6.5" fill="none" stroke={`url(#${id})`} strokeWidth="3.4" />
    </svg>
  );
}

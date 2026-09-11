// Shared building blocks for per-route loading.tsx skeletons. Each route's
// skeleton mirrors that route's own heading size and layout so navigating
// to it never flashes a shape that reads as a different page (it used to
// share one generic, Discover-card-shaped skeleton across every route).
export function SkeletonTitle({ subtitleWidth = "w-64" }: { subtitleWidth?: string }) {
  return (
    <div className="space-y-3">
      <div className="h-10 md:h-12 w-48 md:w-64 rounded-full bg-secondary" />
      <div className={`h-5 ${subtitleWidth} max-w-full rounded-full bg-secondary/70`} />
    </div>
  );
}

export function SkeletonRow() {
  return (
    <div className="rounded-2xl border border-border bg-card p-6 flex items-center gap-4">
      <div className="h-12 w-12 rounded-full bg-secondary shrink-0" />
      <div className="flex-1 space-y-2">
        <div className="h-4 w-1/3 rounded-full bg-secondary" />
        <div className="h-3 w-1/2 rounded-full bg-secondary/70" />
      </div>
    </div>
  );
}

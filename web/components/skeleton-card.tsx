export function SkeletonCard() {
  return (
    <div className="rounded-3xl border border-border bg-card overflow-hidden animate-pulse">
      <div className="aspect-[4/5] bg-secondary" />
      <div className="p-6 space-y-3">
        <div className="h-6 w-2/3 rounded-full bg-secondary" />
        <div className="h-4 w-1/2 rounded-full bg-secondary" />
        <div className="h-20 rounded-2xl bg-secondary/60 mt-4" />
      </div>
    </div>
  );
}

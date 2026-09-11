import { SkeletonTitle } from "@/components/skeleton-bits";

export default function VerificationLoading() {
  return (
    <div className="max-w-2xl mx-auto w-full px-6 py-12 md:py-16 space-y-10 md:space-y-12 animate-pulse">
      <SkeletonTitle subtitleWidth="w-72" />
      <div className="space-y-4">
        {[0, 1, 2, 3].map((i) => (
          <div key={i} className="rounded-2xl border border-border bg-card p-6 flex items-center justify-between gap-4">
            <div className="space-y-2 flex-1">
              <div className="h-4 w-1/3 rounded-full bg-secondary" />
              <div className="h-3 w-2/3 rounded-full bg-secondary/70" />
            </div>
            <div className="h-8 w-16 rounded-full bg-secondary shrink-0" />
          </div>
        ))}
      </div>
    </div>
  );
}

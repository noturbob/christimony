import { SkeletonTitle } from "@/components/skeleton-bits";

export default function SubscriptionLoading() {
  return (
    <div className="max-w-4xl mx-auto w-full px-6 py-12 md:py-16 space-y-10 md:space-y-14 animate-pulse">
      <SkeletonTitle subtitleWidth="w-56" />
      <div className="grid sm:grid-cols-3 gap-6">
        {[0, 1, 2].map((i) => (
          <div key={i} className="rounded-2xl border border-border p-8 space-y-4">
            <div className="space-y-2">
              <div className="h-6 w-20 rounded-full bg-secondary" />
              <div className="h-8 w-24 rounded-full bg-secondary" />
            </div>
            <div className="h-16 rounded-full bg-secondary/60" />
            <div className="h-9 rounded-full bg-secondary" />
          </div>
        ))}
      </div>
    </div>
  );
}

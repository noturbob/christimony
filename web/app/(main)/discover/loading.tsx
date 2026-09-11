import { SkeletonCard } from "@/components/skeleton-card";

export default function DiscoverLoading() {
  return (
    <div className="max-w-md mx-auto w-full px-4 py-10 animate-pulse">
      <div className="flex items-center justify-between mb-6">
        <div className="h-10 w-40 rounded-full bg-secondary" />
        <div className="h-4 w-12 rounded-full bg-secondary/70" />
      </div>
      <SkeletonCard />
    </div>
  );
}

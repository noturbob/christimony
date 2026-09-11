import { SkeletonTitle, SkeletonRow } from "@/components/skeleton-bits";

export default function MatchesLoading() {
  return (
    <div className="max-w-3xl mx-auto w-full px-6 py-12 md:py-16 space-y-10 md:space-y-12 animate-pulse">
      <SkeletonTitle subtitleWidth="w-56" />
      <div className="space-y-4">
        <SkeletonRow />
        <SkeletonRow />
        <SkeletonRow />
      </div>
    </div>
  );
}

"use client";

import { Button } from "@/components/ui/button";

// Next.js 16.3 stabilized `retry` on error boundaries -- prefer it over
// `reset`, which only re-renders the existing tree without re-running
// the failed data fetch.
export default function MainError({
  error,
  retry,
}: {
  error: Error & { digest?: string };
  retry: () => void;
}) {
  return (
    <div className="flex items-center justify-center min-h-[60vh] px-8 text-center">
      <div className="max-w-sm space-y-4">
        <h1 className="font-display text-2xl">Something went wrong</h1>
        <p className="text-muted-foreground text-sm">
          {error.message || "We couldn't load this page. Please try again."}
        </p>
        <Button onClick={() => retry()} className="rounded-full">Try again</Button>
      </div>
    </div>
  );
}

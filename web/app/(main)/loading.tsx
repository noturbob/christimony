// Fallback for any (main) route that doesn't define its own loading.tsx
// (messages/[id], profiles/new, profiles/[id], profiles/[id]/edit).
// Deliberately generic -- routes with a distinct page shape (discover,
// matches, messages, profile, introductions, subscription, verification)
// get their own matching skeleton in a sibling loading.tsx instead, so
// navigating to them never flashes a shape that reads as a different page.
export default function MainLoading() {
  return (
    <div className="flex items-center justify-center min-h-[50vh]">
      <div className="h-8 w-8 rounded-full border-2 border-secondary border-t-primary animate-spin" />
    </div>
  );
}

export default function ProfileLoading() {
  return (
    <div className="max-w-md mx-auto w-full px-6 py-12 space-y-10 animate-pulse">
      <div className="space-y-2">
        <div className="h-10 md:h-12 w-40 rounded-full bg-secondary" />
        <div className="h-4 w-36 rounded-full bg-secondary/70" />
      </div>

      <div className="space-y-4">
        <div className="h-4 w-32 rounded-full bg-secondary/70" />
        <div className="rounded-2xl border border-dashed border-border h-32" />
      </div>

      <div className="space-y-3">
        <div className="h-4 w-24 rounded-full bg-secondary/70" />
        <div className="h-16 rounded-2xl bg-secondary/40" />
        <div className="h-16 rounded-2xl bg-secondary/40" />
        <div className="h-16 rounded-2xl bg-secondary/40" />
      </div>
    </div>
  );
}

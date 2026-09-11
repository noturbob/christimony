export default function MainLoading() {
  return (
    <div className="max-w-md mx-auto px-4 pt-8 animate-pulse">
      <div className="h-7 w-32 rounded-full bg-secondary mb-6" />
      <div className="rounded-3xl border border-border bg-card overflow-hidden">
        <div className="aspect-[4/5] bg-secondary" />
        <div className="p-6 space-y-3">
          <div className="h-5 w-2/3 rounded-full bg-secondary" />
          <div className="h-4 w-1/2 rounded-full bg-secondary" />
        </div>
      </div>
    </div>
  );
}

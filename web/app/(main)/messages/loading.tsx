export default function MessagesLoading() {
  return (
    <div className="max-w-md mx-auto w-full px-6 py-12 animate-pulse">
      <div className="h-10 md:h-12 w-44 rounded-full bg-secondary mb-8" />
      <div className="space-y-1">
        {[0, 1, 2, 3].map((i) => (
          <div key={i} className="flex items-center gap-4 py-3 border-b border-border">
            <div className="h-12 w-12 rounded-full bg-secondary shrink-0" />
            <div className="flex-1 space-y-2">
              <div className="h-4 w-1/3 rounded-full bg-secondary" />
              <div className="h-3 w-2/3 rounded-full bg-secondary/70" />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

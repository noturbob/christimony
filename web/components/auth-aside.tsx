import { Wordmark } from "@/components/marketing/shared";
import { PixelPortrait } from "@/components/marketing/pixel-portrait";

// Left-hand panel shared by login, signup and verify (desktop only).
export function AuthAside({ children }: { children: React.ReactNode }) {
  return (
    <div className="hidden lg:flex flex-col justify-between gap-8 border-r border-border bg-card p-12">
      <Wordmark testId="auth-wordmark" />
      <PixelPortrait className="flex min-h-0 flex-1 items-center justify-center" />
      <div>
        <p className="font-display max-w-lg text-6xl leading-[1] tracking-[-0.045em]">{children}</p>
        <p className="mt-6 flex items-center gap-3 text-sm text-muted-foreground">
          <span aria-hidden className="h-px w-8 bg-primary" />
          For Christians building a life together.
        </p>
      </div>
    </div>
  );
}

import { redirect } from "next/navigation";
import { BottomNav } from "@/components/bottom-nav";
import { HydrateAuth } from "@/components/hydrate-auth";
import { serverApiFetch } from "@/lib/server-api";
import type { Account } from "@/lib/auth-context";

// This segment requires a session (proxy.ts already redirects unauthenticated
// requests before they get here, but this is the authoritative check --
// proxy.ts only looks at cookie presence, not validity). Fetching the
// account here means every page under (main) gets it for free instead of
// each duplicating its own useAuth + redirect-if-missing + "Loading..."
// dance.
export default async function MainLayout({ children }: { children: React.ReactNode }) {
  const account = await serverApiFetch<Account>("/me");
  if (!account) redirect("/login");

  return (
    // min-h-dvh (not min-h-screen/100vh) so mobile browser chrome doesn't
    // leave the page shorter than the real viewport. The inner flex column
    // centers whatever page renders here vertically when it's shorter than
    // the screen (subscription, verification, empty states) -- content
    // taller than the viewport just overflows and scrolls as normal, since
    // justify-center only acts on the leftover space.
    <div className="min-h-dvh flex flex-col">
      <HydrateAuth account={account} />
      <div className="flex-1 flex flex-col justify-center pb-20">{children}</div>
      <BottomNav />
    </div>
  );
}

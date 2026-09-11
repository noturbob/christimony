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
    <div className="min-h-screen pb-20">
      <HydrateAuth account={account} />
      {children}
      <BottomNav />
    </div>
  );
}

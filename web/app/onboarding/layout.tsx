import { redirect } from "next/navigation";
import { HydrateAuth } from "@/components/hydrate-auth";
import { serverApiFetch } from "@/lib/server-api";
import type { Account } from "@/lib/auth-context";

// Same session-hydration pattern as (main)/layout.tsx, minus the bottom
// nav -- onboarding needs a verified account (to create/own a profile)
// but isn't part of the tabbed app shell yet.
export default async function OnboardingLayout({ children }: { children: React.ReactNode }) {
  const account = await serverApiFetch<Account>("/me");
  if (!account) redirect("/login");

  return (
    <div className="min-h-screen">
      <HydrateAuth account={account} />
      {children}
    </div>
  );
}

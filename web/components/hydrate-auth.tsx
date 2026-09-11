"use client";

import { useEffect } from "react";
import { useAuth, type Account } from "@/lib/auth-context";

// Bridges a server-fetched account (see (main)/layout.tsx) into the
// client AuthContext with no extra network call, so app pages have the
// signed-in account on first paint instead of fetching it themselves.
export function HydrateAuth({ account }: { account: Account | null }) {
  const { hydrate } = useAuth();

  useEffect(() => {
    hydrate(account);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [account?.id]);

  return null;
}

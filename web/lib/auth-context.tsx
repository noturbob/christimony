"use client";

import { createContext, useCallback, useContext, useState, ReactNode } from "react";
import { apiFetch } from "./api";

export interface Account {
  id: number;
  email: string | null;
  phone: string | null;
  phone_verified_at: string | null;
  account_type: string;
  onboarding: { complete: boolean; profile_id: number | null };
}

interface AuthContextType {
  account: Account | null;
  logout: () => Promise<void>;
  /** Used by the phone OTP and OAuth (Google/Apple) sign-in flows, which
   * authenticate directly against their own endpoints and hand back a
   * token + account to establish a session with. */
  establishSession: (token: string, account: Account) => Promise<void>;
  refresh: () => Promise<void>;
  /** Seeds context state from a server-fetched account with no network call
   * of its own -- see components/hydrate-auth.tsx. */
  hydrate: (account: Account | null) => void;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({
  children,
  initialAccount = null,
}: {
  children: ReactNode;
  initialAccount?: Account | null;
}) {
  const [account, setAccount] = useState<Account | null>(initialAccount);

  const refresh = useCallback(async () => {
    try {
      const data = await apiFetch<Account>("/me");
      setAccount(data);
    } catch {
      setAccount(null);
    }
  }, []);

  const establishSession = useCallback(async (token: string, nextAccount: Account) => {
    await fetch("/api/auth/session", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ token }),
    });
    setAccount(nextAccount);
  }, []);

  async function logout() {
    await fetch("/api/auth/session", { method: "DELETE" });
    setAccount(null);
  }

  return (
    <AuthContext.Provider value={{ account, logout, establishSession, refresh, hydrate: setAccount }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}

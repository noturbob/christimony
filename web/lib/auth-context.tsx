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
  /** True only while an explicit refresh()/login() call is in flight -- initial
   * state comes from the server (see app/layout.tsx), so there's no boot-time
   * loading flash on any page. */
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => Promise<void>;
  /** Used by the phone OTP verify step, which authenticates directly against
   * /auth/phone/verify rather than through login(). */
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
  const [loading, setLoading] = useState(false);

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

  async function login(email: string, password: string) {
    setLoading(true);
    try {
      const data = await apiFetch<{ token: string; account: Account }>("/login", {
        method: "POST",
        body: { email, password },
      });
      await establishSession(data.token, data.account);
    } finally {
      setLoading(false);
    }
  }

  async function logout() {
    await fetch("/api/auth/session", { method: "DELETE" });
    setAccount(null);
  }

  return (
    <AuthContext.Provider value={{ account, loading, login, logout, establishSession, refresh, hydrate: setAccount }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}

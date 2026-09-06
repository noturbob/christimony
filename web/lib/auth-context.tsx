"use client";

import { createContext, useContext, useEffect, useState, ReactNode } from "react";
import { apiFetch } from "./api";

interface Account {
  id: number;
  email: string | null;
  account_type?: string;
}

interface AuthContextType {
  account: Account | null;
  token: string | null;
  loading: boolean;
  login: (email: string, password: string) => Promise<void>;
  signup: (email: string, password: string, accountType: string) => Promise<void>;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [account, setAccount] = useState<Account | null>(null);
  const [token, setToken] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const storedToken = localStorage.getItem("token");
    if (storedToken) {
      setToken(storedToken);
      apiFetch<Account>("/me", { token: storedToken })
        .then(setAccount)
        .catch(() => {
          localStorage.removeItem("token");
          setToken(null);
        })
        .finally(() => setLoading(false));
    } else {
      setLoading(false);
    }
  }, []);

  async function login(email: string, password: string) {
    const data = await apiFetch<{ token: string; account: Account }>("/login", {
      method: "POST",
      body: { email, password },
    });
    localStorage.setItem("token", data.token);
    setToken(data.token);
    setAccount(data.account);
  }

  async function signup(email: string, password: string, accountType: string) {
    const data = await apiFetch<{ token: string; account: Account }>("/signup", {
      method: "POST",
      body: { account: { email, password, account_type: accountType } },
    });
    localStorage.setItem("token", data.token);
    setToken(data.token);
    setAccount(data.account);
  }

  function logout() {
    localStorage.removeItem("token");
    setToken(null);
    setAccount(null);
  }

  return (
    <AuthContext.Provider value={{ account, token, loading, login, signup, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within AuthProvider");
  return ctx;
}
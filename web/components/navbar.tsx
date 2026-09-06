"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { Button } from "@/components/ui/button";

const LINKS = [
  { href: "/dashboard", label: "Dashboard" },
  { href: "/feed", label: "Browse" },
  { href: "/introductions", label: "Introductions" },
  { href: "/matches", label: "Matches" },
  { href: "/verification", label: "Verification" },
  { href: "/subscription", label: "Membership" },
];

export function Navbar() {
  const { logout } = useAuth();
  const pathname = usePathname();

  return (
    <header className="border-b border-border">
      <div className="max-w-5xl mx-auto flex items-center justify-between px-6 py-4">
        <Link href="/dashboard" className="font-display text-xl text-primary shrink-0">
          Christimony
        </Link>
        <nav className="flex items-center gap-4 text-sm overflow-x-auto">
          {LINKS.map((link) => (
            <Link
              key={link.href}
              href={link.href}
              className={
                pathname === link.href
                  ? "text-foreground font-medium whitespace-nowrap"
                  : "text-muted-foreground hover:text-foreground whitespace-nowrap"
              }
            >
              {link.label}
            </Link>
          ))}
          <Button variant="ghost" size="sm" onClick={logout}>Log out</Button>
        </nav>
      </div>
    </header>
  );
}
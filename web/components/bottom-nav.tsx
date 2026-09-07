"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { Compass, Heart, MessageCircle, Users, User } from "lucide-react";

const TABS = [
  { href: "/discover", label: "Discover", icon: Compass },
  { href: "/matches", label: "Matches", icon: Heart },
  { href: "/messages", label: "Messages", icon: MessageCircle },
  { href: "/introductions", label: "Family", icon: Users },
  { href: "/profile", label: "Profile", icon: User },
];

export function BottomNav() {
  const pathname = usePathname();

  return (
    <nav className="fixed bottom-0 left-0 right-0 z-20 bg-background/95 backdrop-blur border-t border-border">
      <div className="max-w-md mx-auto grid grid-cols-5">
        {TABS.map((tab) => {
          const active = pathname.startsWith(tab.href);
          const Icon = tab.icon;
          return (
            <Link
              key={tab.href}
              href={tab.href}
              className="flex flex-col items-center justify-center gap-1 py-3"
            >
              <Icon
                size={22}
                strokeWidth={active ? 2.5 : 1.75}
                className={active ? "text-primary" : "text-muted-foreground"}
              />
              <span className={`text-[11px] ${active ? "text-primary font-medium" : "text-muted-foreground"}`}>
                {tab.label}
              </span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
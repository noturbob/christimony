"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { motion } from "motion/react";
import { Compass, Heart, MessageCircle, Users, User } from "lucide-react";
import { getConversations } from "@/lib/conversations";

const TABS = [
  { href: "/discover", label: "Discover", icon: Compass },
  { href: "/matches", label: "Matches", icon: Heart },
  { href: "/messages", label: "Messages", icon: MessageCircle },
  { href: "/introductions", label: "Family", icon: Users },
  { href: "/profile", label: "Profile", icon: User },
];

const UNREAD_POLL_MS = 15000;

export function BottomNav() {
  const pathname = usePathname();
  const [unreadCount, setUnreadCount] = useState(0);

  useEffect(() => {
    let cancelled = false;
    function poll() {
      getConversations()
        .then((conversations) => {
          if (!cancelled) setUnreadCount(conversations.reduce((sum, c) => sum + c.unread_count, 0));
        })
        .catch(() => {});
    }
    poll();
    const interval = setInterval(poll, UNREAD_POLL_MS);
    return () => {
      cancelled = true;
      clearInterval(interval);
    };
  }, []);

  return (
    <nav
      className="fixed bottom-0 left-0 right-0 z-20 bg-background/95 backdrop-blur border-t border-border"
      style={{ paddingBottom: "env(safe-area-inset-bottom)" }}
    >
      <div className="max-w-md mx-auto grid grid-cols-5">
        {TABS.map((tab) => {
          const active = pathname === tab.href || pathname.startsWith(`${tab.href}/`);
          const Icon = tab.icon;
          return (
            <Link
              key={tab.href}
              href={tab.href}
              className="relative flex flex-col items-center justify-center gap-1 py-3"
            >
              {active && (
                <motion.div
                  layoutId="bottom-nav-active-pill"
                  className="absolute inset-x-3 inset-y-0.5 rounded-2xl bg-primary/10"
                  transition={{ type: "spring", stiffness: 380, damping: 32 }}
                />
              )}
              <span className="relative">
                <Icon
                  size={22}
                  strokeWidth={active ? 2.5 : 1.75}
                  className={active ? "text-primary" : "text-muted-foreground"}
                />
                {tab.href === "/messages" && unreadCount > 0 && (
                  <span className="absolute -top-0.5 -right-1.5 h-2 w-2 rounded-full bg-accent ring-2 ring-background" />
                )}
              </span>
              <span className={`relative text-[11px] ${active ? "text-primary font-medium" : "text-muted-foreground"}`}>
                {tab.label}
              </span>
            </Link>
          );
        })}
      </div>
    </nav>
  );
}

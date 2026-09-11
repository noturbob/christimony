import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";
import { SESSION_COOKIE } from "@/lib/session";

// Next.js 16 renamed middleware.ts -> proxy.ts. This only gates on
// cookie *presence* (cheap, no Rails round-trip); the cookie's validity
// is verified server-side against Rails whenever a page/BFF call
// actually uses it, and a 401 from Rails clears the cookie (see
// app/api/bff/[...path]/route.ts).
const APP_ROUTES = [
  "/discover",
  "/matches",
  "/messages",
  "/introductions",
  "/profile",
  "/profiles",
  "/subscription",
  "/verification",
  "/onboarding",
];

const AUTH_ONLY_WHEN_LOGGED_OUT = ["/login", "/verify", "/signup"];

export function proxy(request: NextRequest) {
  const { pathname } = request.nextUrl;
  const hasSession = request.cookies.has(SESSION_COOKIE);

  const isAppRoute = APP_ROUTES.some((route) => pathname === route || pathname.startsWith(`${route}/`));
  if (isAppRoute && !hasSession) {
    const url = request.nextUrl.clone();
    url.pathname = "/login";
    url.searchParams.set("next", pathname);
    return NextResponse.redirect(url);
  }

  const isAuthOnlyRoute = AUTH_ONLY_WHEN_LOGGED_OUT.some((route) => pathname === route);
  if (isAuthOnlyRoute && hasSession) {
    const url = request.nextUrl.clone();
    url.pathname = "/discover";
    url.search = "";
    return NextResponse.redirect(url);
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|webp|avif|ico)$).*)"],
};

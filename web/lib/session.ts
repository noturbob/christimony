import "server-only";
import { cookies } from "next/headers";

// The Rails JWT is stored httpOnly so client JS (and therefore XSS) can
// never read it -- this is the single cookie the whole auth system rests
// on. Matches the 30-day expiry JsonWebToken.encode uses on the Rails side.
export const SESSION_COOKIE = "christimony_session";
const MAX_AGE_SECONDS = 30 * 24 * 60 * 60;

export async function getSessionToken(): Promise<string | null> {
  const jar = await cookies();
  return jar.get(SESSION_COOKIE)?.value ?? null;
}

export async function setSessionToken(token: string) {
  const jar = await cookies();
  jar.set(SESSION_COOKIE, token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === "production",
    sameSite: "lax",
    path: "/",
    maxAge: MAX_AGE_SECONDS,
  });
}

export async function clearSessionToken() {
  const jar = await cookies();
  jar.delete(SESSION_COOKIE);
}

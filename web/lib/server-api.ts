import "server-only";
import { getSessionToken } from "./session";

// Server-side counterpart to lib/api.ts: used from Server Components
// (the (app) shell layout, for hydrating auth with no client-side
// loading flash) to call Rails directly, skipping the extra same-origin
// hop the browser-side BFF proxy needs.
const API_BASE_URL = process.env.API_BASE_URL || "http://localhost:3000/api/v1";

export async function serverApiFetch<T>(path: string): Promise<T | null> {
  const token = await getSessionToken();
  if (!token) return null;

  try {
    const res = await fetch(`${API_BASE_URL}${path}`, {
      headers: { Authorization: `Bearer ${token}` },
      cache: "no-store",
    });

    if (!res.ok) return null;
    return (await res.json()) as T;
  } catch (err) {
    // Network-level failure (API unreachable, DNS, timeout, etc.) --
    // fail closed to "not logged in" rather than crashing the layout
    // that calls this with an unhandled rejection / 500 page.
    console.error(`serverApiFetch(${path}) failed:`, err);
    return null;
  }
}

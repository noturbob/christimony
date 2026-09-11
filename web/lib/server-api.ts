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
    // Every navigation inside (main)/onboarding re-runs this layout (it
    // reads cookies, so Next can't skip it), which used to mean a fresh
    // round-trip to Rails on every single tab switch -- the old page hung
    // around on screen until that finished, which is what showed up as a
    // "flash" of whichever tab you were leaving. A short revalidate window
    // lets Next serve the same account from its request cache for repeat
    // navigations instead of re-fetching every time (keyed on the bearer
    // token, so this never crosses between accounts/sessions). Has no
    // effect in `next dev`, which never caches fetches -- only in a
    // production build.
    const res = await fetch(`${API_BASE_URL}${path}`, {
      headers: { Authorization: `Bearer ${token}` },
      next: { revalidate: 30 },
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

// Client-side fetcher. Talks to same-origin /api/bff/* only -- the
// httpOnly session cookie rides along automatically with same-origin
// requests, so no token is ever threaded through call sites or held in
// JS-reachable storage. See app/api/bff/[...path]/route.ts for the
// actual proxy to Rails.
const API_BASE = "/api/bff";

interface ApiOptions {
  method?: string;
  body?: unknown;
}

export class ApiError extends Error {
  status: number;

  constructor(message: string, status: number) {
    super(message);
    this.status = status;
  }
}

export async function apiFetch<T>(path: string, options: ApiOptions = {}): Promise<T> {
  const { method = "GET", body } = options;

  const isFormData = body instanceof FormData;
  const headers: Record<string, string> = {};
  if (!isFormData) headers["Content-Type"] = "application/json";

  const res = await fetch(`${API_BASE}${path}`, {
    method,
    headers,
    body: isFormData ? (body as FormData) : body ? JSON.stringify(body) : undefined,
  });

  if (res.status === 401) {
    // The BFF already cleared the cookie for us; force a full navigation
    // (not a soft client-side push) so proxy.ts re-evaluates the route
    // server-side against the now-cleared cookie, same as a fresh visit.
    // eslint-disable-next-line @next/next/no-location-assign-relative-destination -- intentional hard navigation, not a component we can useRouter() from
    if (typeof window !== "undefined") window.location.href = "/login";
    throw new ApiError("Session expired", 401);
  }

  if (res.status === 204) return undefined as T;

  const data = await res.json().catch(() => ({}));

  if (!res.ok) {
    const message = data.errors?.join(", ") || data.error || "Something went wrong";
    throw new ApiError(message, res.status);
  }

  return data as T;
}

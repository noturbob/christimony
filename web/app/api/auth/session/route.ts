import { NextRequest, NextResponse } from "next/server";
import { getSessionToken, setSessionToken, clearSessionToken } from "@/lib/session";
import { API_BASE_URL } from "@/lib/server-api";

// Bridges the OTP-verify / OAuth sign-in response into an httpOnly
// cookie. The raw JWT never touches localStorage or any place client JS
// can read it.
export async function POST(request: NextRequest) {
  const body = await request.json().catch(() => null);
  const token = body?.token;

  if (typeof token !== "string" || !token) {
    return NextResponse.json({ error: "token is required" }, { status: 400 });
  }

  await setSessionToken(token);
  return NextResponse.json({ ok: true });
}

// Logout: revoke the JWT with Rails first so a copied token stops working,
// but clear the cookie regardless -- Rails being down (or the token already
// invalid) must never leave the user stuck signed in.
export async function DELETE() {
  const token = await getSessionToken();
  if (token) {
    try {
      await fetch(`${API_BASE_URL}/auth/session`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${token}` },
        cache: "no-store",
        signal: AbortSignal.timeout(3000),
      });
    } catch (err) {
      console.error("Token revocation failed:", err);
    }
  }
  await clearSessionToken();
  return NextResponse.json({ ok: true });
}

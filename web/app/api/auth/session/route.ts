import { NextRequest, NextResponse } from "next/server";
import { setSessionToken, clearSessionToken } from "@/lib/session";

// Bridges the OTP-verify (or email/password login) response into an
// httpOnly cookie. The raw JWT never touches localStorage or any place
// client JS can read it.
export async function POST(request: NextRequest) {
  const body = await request.json().catch(() => null);
  const token = body?.token;

  if (typeof token !== "string" || !token) {
    return NextResponse.json({ error: "token is required" }, { status: 400 });
  }

  await setSessionToken(token);
  return NextResponse.json({ ok: true });
}

export async function DELETE() {
  await clearSessionToken();
  return NextResponse.json({ ok: true });
}

"use client";

import { useEffect, useRef, useState } from "react";
import Script from "next/script";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { verifyAppleIdToken, verifyGoogleIdToken, type OAuthSignInResponse } from "@/lib/oauth";

// Set these to enable each provider. Google: OAuth client ID from Google
// Cloud Console (Web application type). Apple: Services ID from the Apple
// Developer portal, with this app's origin registered as an associated
// domain/return URL. Both are safe to expose to the client -- they're
// public identifiers, not secrets.
const GOOGLE_CLIENT_ID = process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID;
const APPLE_CLIENT_ID = process.env.NEXT_PUBLIC_APPLE_CLIENT_ID;
const APPLE_REDIRECT_URI = process.env.NEXT_PUBLIC_APPLE_REDIRECT_URI;

interface GoogleCredentialResponse {
  credential: string;
}

interface GoogleAccountsId {
  initialize(config: {
    client_id: string;
    callback: (response: GoogleCredentialResponse) => void;
  }): void;
  renderButton(parent: HTMLElement, options: Record<string, string | number | boolean>): void;
}

interface AppleIdAuth {
  init(config: { clientId: string; scope: string; redirectURI: string; usePopup: boolean }): void;
  signIn(): Promise<{ authorization: { id_token: string } }>;
}

declare global {
  interface Window {
    google?: { accounts: { id: GoogleAccountsId } };
    AppleID?: { auth: AppleIdAuth };
  }
}

export function OAuthButtons() {
  const router = useRouter();
  const { establishSession } = useAuth();
  const [error, setError] = useState("");
  const [applePending, setApplePending] = useState(false);
  const [googleReady, setGoogleReady] = useState(false);
  const [appleReady, setAppleReady] = useState(false);
  const googleButtonRef = useRef<HTMLDivElement>(null);

  async function finishSignIn(result: Promise<OAuthSignInResponse>) {
    setError("");
    try {
      const res = await result;
      await establishSession(res.token, res.account);
      router.push(res.onboarding.complete ? "/discover" : "/onboarding/account-type");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Sign-in failed");
    }
  }

  useEffect(() => {
    if (!googleReady || !GOOGLE_CLIENT_ID || !window.google || !googleButtonRef.current) return;

    window.google.accounts.id.initialize({
      client_id: GOOGLE_CLIENT_ID,
      callback: (response) => finishSignIn(verifyGoogleIdToken(response.credential)),
    });
    window.google.accounts.id.renderButton(googleButtonRef.current, {
      type: "standard",
      theme: "outline",
      size: "large",
      shape: "pill",
      width: 320,
      text: "continue_with",
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps -- finishSignIn is stable enough here; re-running on every render would re-mount Google's button
  }, [googleReady]);

  useEffect(() => {
    if (!appleReady || !APPLE_CLIENT_ID || !window.AppleID) return;
    window.AppleID.auth.init({
      clientId: APPLE_CLIENT_ID,
      scope: "email name",
      redirectURI: APPLE_REDIRECT_URI || window.location.origin,
      usePopup: true,
    });
  }, [appleReady]);

  async function handleAppleClick() {
    if (!window.AppleID) return;
    setApplePending(true);
    try {
      const res = await window.AppleID.auth.signIn();
      await finishSignIn(verifyAppleIdToken(res.authorization.id_token));
    } catch {
      // Apple's SDK rejects signIn() on a plain user-cancel too, so this
      // stays silent rather than showing an "error" for closing the popup.
    } finally {
      setApplePending(false);
    }
  }

  if (!GOOGLE_CLIENT_ID && !APPLE_CLIENT_ID) return null;

  return (
    <div className="space-y-3">
      {GOOGLE_CLIENT_ID && (
        <>
          <Script
            src="https://accounts.google.com/gsi/client"
            strategy="afterInteractive"
            onLoad={() => setGoogleReady(true)}
          />
          <div ref={googleButtonRef} className="flex justify-center [&>div]:!w-full" />
        </>
      )}

      {APPLE_CLIENT_ID && (
        <>
          <Script
            src="https://appleid.cdn-apple.com/appleauth/static/jsapi/appleid/1/en_US/appleid.auth.js"
            strategy="afterInteractive"
            onLoad={() => setAppleReady(true)}
          />
          <button
            type="button"
            onClick={handleAppleClick}
            disabled={!appleReady || applePending}
            className="w-full h-10 rounded-full border border-foreground bg-foreground text-background flex items-center justify-center gap-2 text-sm font-medium disabled:opacity-50 transition-opacity"
          >
            {applePending ? "Signing in..." : "Continue with Apple"}
          </button>
        </>
      )}

      {error && <p className="text-sm text-destructive text-center">{error}</p>}
    </div>
  );
}

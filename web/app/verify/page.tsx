"use client";

import { Suspense, useEffect, useRef, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import Link from "next/link";
import { AuthAside } from "@/components/auth-aside";
import { useAuth } from "@/lib/auth-context";
import { startPhoneAuth, verifyPhoneAuth } from "@/lib/phone-auth";

const CODE_LENGTH = 6;

function VerifyForm() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { establishSession } = useAuth();

  const phone = searchParams.get("phone") ?? "";
  const devCode = searchParams.get("dev");

  const [digits, setDigits] = useState<string[]>(Array(CODE_LENGTH).fill(""));
  const [error, setError] = useState("");
  const [shake, setShake] = useState(false);
  const [verifying, setVerifying] = useState(false);
  const [resending, setResending] = useState(false);
  const [cooldown, setCooldown] = useState(30);
  const inputRefs = useRef<(HTMLInputElement | null)[]>([]);

  useEffect(() => {
    if (cooldown <= 0) return;
    const timer = setTimeout(() => setCooldown((c) => c - 1), 1000);
    return () => clearTimeout(timer);
  }, [cooldown]);

  useEffect(() => {
    inputRefs.current[0]?.focus();
  }, []);

  async function submitCode(code: string) {
    setError("");
    setVerifying(true);
    try {
      const res = await verifyPhoneAuth(phone, code);
      await establishSession(res.token, res.account);
      router.push(res.onboarding.complete ? "/discover" : "/onboarding/account-type");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Verification failed");
      setShake(true);
      setDigits(Array(CODE_LENGTH).fill(""));
      inputRefs.current[0]?.focus();
      setTimeout(() => setShake(false), 400);
    } finally {
      setVerifying(false);
    }
  }

  function handleChange(index: number, value: string) {
    const clean = value.replace(/\D/g, "");
    if (!clean) {
      const next = [...digits];
      next[index] = "";
      setDigits(next);
      return;
    }

    const next = [...digits];
    next[index] = clean[clean.length - 1];
    setDigits(next);

    if (index < CODE_LENGTH - 1) {
      inputRefs.current[index + 1]?.focus();
    } else if (next.every((d) => d)) {
      submitCode(next.join(""));
    }
  }

  function handleKeyDown(index: number, e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === "Backspace" && !digits[index] && index > 0) {
      inputRefs.current[index - 1]?.focus();
    }
  }

  function handlePaste(e: React.ClipboardEvent<HTMLInputElement>) {
    const pasted = e.clipboardData.getData("text").replace(/\D/g, "").slice(0, CODE_LENGTH);
    if (!pasted) return;
    e.preventDefault();
    const next = Array(CODE_LENGTH).fill("");
    for (let i = 0; i < pasted.length; i++) next[i] = pasted[i];
    setDigits(next);
    if (pasted.length === CODE_LENGTH) {
      submitCode(pasted);
    } else {
      inputRefs.current[pasted.length]?.focus();
    }
  }

  async function handleResend() {
    setResending(true);
    setError("");
    try {
      await startPhoneAuth(phone);
      setCooldown(30);
      setDigits(Array(CODE_LENGTH).fill(""));
      inputRefs.current[0]?.focus();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to resend code");
    } finally {
      setResending(false);
    }
  }

  if (!phone) {
    return (
      <div className="text-center space-y-4">
        <p className="text-muted-foreground">No phone number to verify.</p>
        <Link href="/login" className="text-primary underline underline-offset-4">Go back</Link>
      </div>
    );
  }

  return (
    <div className="w-full max-w-sm space-y-8">
      <div className="lg:hidden">
        <span className="font-display text-2xl text-primary">Christimony</span>
      </div>

      <div>
        <h1 className="font-display text-5xl leading-none">Enter the code</h1>
        <p className="text-muted-foreground mt-1">We sent a 6-digit code to +91 {phone}.</p>
      </div>

      {devCode && (
        <p className="rounded-full bg-secondary px-4 py-2 text-xs text-muted-foreground text-center">
          Dev mode — your code is <span className="font-mono font-medium">{devCode}</span>
        </p>
      )}

      <div className={`flex gap-2 justify-between ${shake ? "animate-[shake_0.4s]" : ""}`}>
        {digits.map((digit, i) => (
          <input
            key={i}
            ref={(el) => {
              inputRefs.current[i] = el;
            }}
            type="text"
            inputMode="numeric"
            maxLength={1}
            autoComplete={i === 0 ? "one-time-code" : "off"}
            value={digit}
            disabled={verifying}
            onChange={(e) => handleChange(i, e.target.value)}
            onKeyDown={(e) => handleKeyDown(i, e)}
            onPaste={handlePaste}
            className="h-14 w-12 text-center text-xl font-medium rounded-2xl border border-input bg-card outline-none focus:border-ring focus:ring-2 focus:ring-ring/40"
          />
        ))}
      </div>

      {error && <p className="text-sm text-destructive text-center">{error}</p>}
      {verifying && <p className="text-sm text-muted-foreground text-center">Verifying...</p>}

      <div className="text-center">
        {cooldown > 0 ? (
          <p className="text-sm text-muted-foreground">Resend code in {cooldown}s</p>
        ) : (
          <button
            onClick={handleResend}
            disabled={resending}
            className="text-sm text-primary underline underline-offset-4"
          >
            {resending ? "Sending..." : "Resend code"}
          </button>
        )}
      </div>

      <p className="text-sm text-muted-foreground text-center">
        <Link href="/login" className="underline underline-offset-4">Use a different number</Link>
      </p>
    </div>
  );
}

export default function VerifyPage() {
  return (
    <div className="min-h-dvh grid lg:grid-cols-2">
      <AuthAside>Almost <em className="serif-italic text-primary">there.</em></AuthAside>

      <div className="flex items-center justify-center p-8">
        <Suspense fallback={<p className="text-muted-foreground">Loading...</p>}>
          <VerifyForm />
        </Suspense>
      </div>
    </div>
  );
}

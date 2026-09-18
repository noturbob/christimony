"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { AuthAside } from "@/components/auth-aside";
import { startPhoneAuth } from "@/lib/phone-auth";
import { Button } from "@/components/ui/button";
import { OAuthButtons } from "@/components/oauth-buttons";

function normalizeDigits(value: string) {
  return value.replace(/\D/g, "").slice(0, 10);
}

export default function LoginPage() {
  const router = useRouter();
  const [phone, setPhone] = useState("");
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");

    if (phone.length !== 10) {
      setError("Enter a 10-digit phone number");
      return;
    }

    setSubmitting(true);
    try {
      const res = await startPhoneAuth(phone);
      const devParam = res.dev_code ? `&dev=${res.dev_code}` : "";
      router.push(`/verify?phone=${phone}${devParam}`);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Something went wrong");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="min-h-dvh grid lg:grid-cols-2">
      <AuthAside>Marriage, sought with <em className="serif-italic text-primary">intention.</em></AuthAside>

      <div className="flex items-center justify-center p-8">
        <div className="w-full max-w-sm space-y-8">
          <div className="lg:hidden">
            <span className="font-display text-2xl text-primary">Christimony</span>
          </div>

          <div>
            <h1 className="font-display text-5xl leading-none">Welcome back</h1>
            <p className="text-muted-foreground mt-1">Continue with your phone number or a connected account.</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <label htmlFor="phone" className="text-sm font-medium">Phone number</label>
              <div className="flex items-center rounded-full border border-input bg-background overflow-hidden focus-within:ring-1 focus-within:ring-ring">
                <span className="pl-4 pr-2 text-sm text-muted-foreground border-r border-input py-2.5">+91</span>
                <input
                  id="phone"
                  type="tel"
                  inputMode="numeric"
                  autoComplete="tel-national"
                  placeholder="98765 43210"
                  value={phone}
                  onChange={(e) => setPhone(normalizeDigits(e.target.value))}
                  className="flex-1 bg-transparent px-3 py-2.5 text-sm outline-none"
                  required
                />
              </div>
            </div>
            {error && <p className="text-sm text-destructive">{error}</p>}
            <Button type="submit" className="w-full rounded-full" disabled={submitting}>
              {submitting ? "Sending code..." : "Send code"}
            </Button>
          </form>

          <div className="flex items-center gap-3">
            <div className="h-px flex-1 bg-border" />
            <span className="text-xs text-muted-foreground uppercase tracking-wide">or</span>
            <div className="h-px flex-1 bg-border" />
          </div>

          <OAuthButtons />

          <p className="text-sm text-muted-foreground text-center">
            New here?{" "}
            <Link href="/signup" className="text-primary underline underline-offset-4">
              Create an account
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
}

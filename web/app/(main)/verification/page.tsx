"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/lib/auth-context";
import { getVerifications, createVerification, Verification } from "@/lib/verifications";
import { Button } from "@/components/ui/button";

const TYPES: { value: string; label: string; description: string }[] = [
  { value: "phone_otp", label: "Phone number", description: "Confirm your phone number with a one-time code." },
  { value: "email_otp", label: "Email address", description: "Confirm your email address with a one-time code." },
  { value: "government_id", label: "Government ID", description: "Upload a government-issued photo ID." },
  { value: "selfie_liveness", label: "Selfie check", description: "A quick photo to confirm you're a real person." },
];

export default function VerificationPage() {
  const { account } = useAuth();
  const [verifications, setVerifications] = useState<Verification[]>([]);
  const [loadingData, setLoadingData] = useState(true);
  const [submittingType, setSubmittingType] = useState<string | null>(null);

  useEffect(() => {
    if (!account) return;
    getVerifications().then(setVerifications).finally(() => setLoadingData(false));
  }, [account]);

  async function handleSubmit(type: string) {
    setSubmittingType(type);
    try {
      const v = await createVerification(type);
      setVerifications((prev) => [...prev, v]);
    } finally {
      setSubmittingType(null);
    }
  }

  function statusFor(type: string) {
    const matching = verifications.filter((v) => v.verification_type === type);
    if (matching.length === 0) return null;
    return matching.find((v) => v.status === "verified") ?? matching[matching.length - 1];
  }

  if (!account) return null;

  return (
    <div className="max-w-2xl mx-auto px-6 py-10 space-y-6">
      <div>
        <h1 className="font-display text-3xl">Verification</h1>
        <p className="text-muted-foreground mt-1">Verified accounts are trusted more, and matched more often.</p>
      </div>

      <div className="space-y-3">
        {loadingData ? (
          <p className="text-muted-foreground">Loading...</p>
        ) : (
          TYPES.map((t) => {
            const status = statusFor(t.value);
            return (
              <div key={t.value} className="rounded-2xl border border-border bg-card p-5 flex items-center justify-between gap-4">
                <div>
                  <p className="font-medium">{t.label}</p>
                  <p className="text-sm text-muted-foreground">{t.description}</p>
                </div>
                {status?.status === "verified" ? (
                  <span className="text-sm text-primary font-medium shrink-0">Verified</span>
                ) : status ? (
                  <span className="text-sm text-muted-foreground shrink-0 capitalize">{status.status}</span>
                ) : (
                  <Button
                    variant="outline"
                    className="rounded-full shrink-0"
                    size="sm"
                    disabled={submittingType === t.value}
                    onClick={() => handleSubmit(t.value)}
                  >
                    {submittingType === t.value ? "Submitting..." : "Start"}
                  </Button>
                )}
              </div>
            );
          })
        )}
      </div>
    </div>
  );
}

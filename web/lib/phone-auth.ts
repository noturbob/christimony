import { apiFetch } from "./api";
import type { Account } from "./auth-context";

export interface StartPhoneAuthResponse {
  sent: boolean;
  expires_in: number;
  retry_after: number;
  dev_code?: string;
}

export interface VerifyPhoneAuthResponse {
  token: string;
  account: Account;
  is_new_account: boolean;
  onboarding: { complete: boolean; profile_id: number | null };
}

export function startPhoneAuth(phone: string) {
  return apiFetch<StartPhoneAuthResponse>("/auth/phone/start", {
    method: "POST",
    body: { phone },
  });
}

export function verifyPhoneAuth(phone: string, code: string) {
  return apiFetch<VerifyPhoneAuthResponse>("/auth/phone/verify", {
    method: "POST",
    body: { phone, code },
  });
}

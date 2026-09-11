import { apiFetch } from "./api";
import type { Account } from "./auth-context";

export interface OAuthSignInResponse {
  token: string;
  account: Account;
  is_new_account: boolean;
  onboarding: { complete: boolean; profile_id: number | null };
}

export function verifyGoogleIdToken(idToken: string) {
  return apiFetch<OAuthSignInResponse>("/auth/google", {
    method: "POST",
    body: { id_token: idToken },
  });
}

export function verifyAppleIdToken(idToken: string) {
  return apiFetch<OAuthSignInResponse>("/auth/apple", {
    method: "POST",
    body: { id_token: idToken },
  });
}

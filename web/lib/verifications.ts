import { apiFetch } from "./api";

export interface Verification {
  id: number;
  verification_type: string;
  status: string;
  verified_at: string | null;
}

export function getVerifications(token: string) {
  return apiFetch<Verification[]>("/verifications", { token });
}

export function createVerification(token: string, verificationType: string) {
  return apiFetch<Verification>("/verifications", {
    method: "POST",
    token,
    body: { verification_type: verificationType },
  });
}
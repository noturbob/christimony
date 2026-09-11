import { apiFetch } from "./api";

export interface Verification {
  id: number;
  verification_type: string;
  status: string;
  verified_at: string | null;
}

export function getVerifications() {
  return apiFetch<Verification[]>("/verifications");
}

export function createVerification(verificationType: string) {
  return apiFetch<Verification>("/verifications", {
    method: "POST",
    body: { verification_type: verificationType },
  });
}

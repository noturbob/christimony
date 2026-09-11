import { apiFetch } from "./api";

export interface Vouch {
  id: number;
  profile_id: number;
  voucher_name: string;
  voucher_role: string;
  status: string;
}

export function getVouches(profileId: number) {
  return apiFetch<Vouch[]>(`/profiles/${profileId}/vouches`);
}

export function createVouch(profileId: number, data: { voucher_name: string; voucher_role: string }) {
  return apiFetch<Vouch>(`/profiles/${profileId}/vouches`, {
    method: "POST",
    body: data,
  });
}

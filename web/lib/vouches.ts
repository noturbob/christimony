import { apiFetch } from "./api";

export interface Vouch {
  id: number;
  profile_id: number;
  voucher_name: string;
  voucher_role: string;
  status: string;
}

export function getVouches(token: string, profileId: number) {
  return apiFetch<Vouch[]>(`/profiles/${profileId}/vouches`, { token });
}

export function createVouch(
  token: string,
  profileId: number,
  data: { voucher_name: string; voucher_role: string }
) {
  return apiFetch<Vouch>(`/profiles/${profileId}/vouches`, {
    method: "POST",
    token,
    body: data,
  });
}
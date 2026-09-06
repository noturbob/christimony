import { apiFetch } from "./api";

export interface WardSummary {
  id: number;
  name: string;
  city: string | null;
}

export interface Introduction {
  id: number;
  parent_match_id: number;
  status: string;
  ward_a: WardSummary;
  ward_b: WardSummary;
}

export function getIntroductions(token: string) {
  return apiFetch<Introduction[]>("/introductions", { token });
}

export function acceptIntroduction(token: string, introductionId: number, wardProfileId: number) {
  return apiFetch<Introduction>(`/introductions/${introductionId}/accept`, {
    method: "POST",
    token,
    body: { ward_profile_id: wardProfileId },
  });
}

export function declineIntroduction(token: string, introductionId: number, wardProfileId: number) {
  return apiFetch<Introduction>(`/introductions/${introductionId}/decline`, {
    method: "POST",
    token,
    body: { ward_profile_id: wardProfileId },
  });
}
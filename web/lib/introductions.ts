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

export function getIntroductions() {
  return apiFetch<Introduction[]>("/introductions");
}

export function acceptIntroduction(introductionId: number, wardProfileId: number) {
  return apiFetch<Introduction>(`/introductions/${introductionId}/accept`, {
    method: "POST",
    body: { ward_profile_id: wardProfileId },
  });
}

export function declineIntroduction(introductionId: number, wardProfileId: number) {
  return apiFetch<Introduction>(`/introductions/${introductionId}/decline`, {
    method: "POST",
    body: { ward_profile_id: wardProfileId },
  });
}

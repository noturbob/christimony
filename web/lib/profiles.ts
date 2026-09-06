import { apiFetch } from "./api";

export interface Profile {
  id: number;
  name: string;
  profile_type: string;
  dob: string | null;
  gender: string | null;
  city: string | null;
  education: string | null;
  profession: string | null;
  bio: string | null;
  status: string;
  denomination: string | null;
}

export interface ProfileSummary {
  id: number;
  name: string;
  city: string | null;
  profile_type: string;
}

export interface Match {
  id: number;
  profile_a: ProfileSummary;
  profile_b: ProfileSummary;
  match_type: string;
  matched_at: string;
}

export function getMyProfiles(token: string) {
  return apiFetch<Profile[]>("/profiles", { token });
}

export function getProfile(token: string, id: number) {
  return apiFetch<Profile>(`/profiles/${id}`, { token });
}

export function getFeed(token: string, filters?: { city?: string; denomination_id?: number }) {
  const params = new URLSearchParams();
  if (filters?.city) params.set("city", filters.city);
  if (filters?.denomination_id) params.set("denomination_id", String(filters.denomination_id));
  const query = params.toString() ? `?${params.toString()}` : "";
  return apiFetch<Profile[]>(`/profiles/feed${query}`, { token });
}

export function sendInterest(token: string, senderProfileId: number, receiverProfileId: number) {
  return apiFetch<{ interest: any; match: any }>("/interests", {
    method: "POST",
    token,
    body: { sender_profile_id: senderProfileId, receiver_profile_id: receiverProfileId },
  });
}

export function createProfile(
  token: string,
  data: { name: string; profile_type: string; city?: string; bio?: string }
) {
  return apiFetch<Profile>("/profiles", {
    method: "POST",
    token,
    body: { profile: { ...data, status: "active" } },
  });
}

export function updateProfile(
  token: string,
  id: number,
  data: Partial<{ name: string; city: string; bio: string; education: string; profession: string; gender: string; dob: string }>
) {
  return apiFetch<Profile>(`/profiles/${id}`, {
    method: "PATCH",
    token,
    body: { profile: data },
  });
}

export function getMatches(token: string) {
  return apiFetch<Match[]>("/matches", { token });
}
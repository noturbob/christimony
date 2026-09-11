import { apiFetch } from "./api";

export interface PhotoRef {
  id: number;
  url: string;
  thumb_url: string;
  position: number;
}

export interface Prompt {
  id: number;
  profile_id: number;
  question: string;
  answer: string;
}

export interface Profile {
  id: number;
  name: string;
  profile_type: string;
  dob: string | null;
  age: number | null;
  gender: string | null;
  city: string | null;
  education: string | null;
  profession: string | null;
  bio: string | null;
  status: string;
  denomination_id: number | null;
  denomination: string | null;
  photos: PhotoRef[];
  prompts: Prompt[];
}

export interface ProfileSummary {
  id: number;
  name: string;
  city: string | null;
  profile_type: string;
  age: number | null;
  cover_photo_url: string | null;
}

export interface Match {
  id: number;
  profile_a: ProfileSummary;
  profile_b: ProfileSummary;
  my_profile_id: number;
  match_type: string;
  matched_at: string;
}

export interface Denomination {
  id: number;
  name: string;
}

export interface FeedFilters {
  city?: string;
  denomination_id?: number;
  gender?: string;
  min_age?: number;
  max_age?: number;
  page?: number;
  per?: number;
}

export interface FeedPage {
  profiles: Profile[];
  next_page: number | null;
}

export function getMyProfiles() {
  return apiFetch<Profile[]>("/profiles");
}

export function getProfile(id: number) {
  return apiFetch<Profile>(`/profiles/${id}`);
}

export function getFeed(filters?: FeedFilters) {
  const params = new URLSearchParams();
  if (filters) {
    for (const [key, value] of Object.entries(filters)) {
      if (value !== undefined && value !== "") params.set(key, String(value));
    }
  }
  const query = params.toString() ? `?${params.toString()}` : "";
  return apiFetch<FeedPage>(`/profiles/feed${query}`);
}

export function getDenominations() {
  return apiFetch<Denomination[]>("/denominations");
}

export function getPromptQuestions() {
  return apiFetch<string[]>("/prompt_questions");
}

export function sendInterest(senderProfileId: number, receiverProfileId: number) {
  return apiFetch<{ interest: { id: number; status: string }; match: { id: number } | null }>("/interests", {
    method: "POST",
    body: { sender_profile_id: senderProfileId, receiver_profile_id: receiverProfileId },
  });
}

export function createProfile(data: {
  name: string;
  profile_type: string;
  gender?: string;
  dob?: string;
  city?: string;
  bio?: string;
  denomination_id?: number;
  education?: string;
  profession?: string;
}) {
  return apiFetch<Profile>("/profiles", {
    method: "POST",
    body: { profile: data },
  });
}

export function updateProfile(
  id: number,
  data: Partial<{
    name: string;
    city: string;
    bio: string;
    education: string;
    profession: string;
    gender: string;
    dob: string;
    denomination_id: number;
    status: string;
  }>
) {
  return apiFetch<Profile>(`/profiles/${id}`, {
    method: "PATCH",
    body: { profile: data },
  });
}

export function getMatches() {
  return apiFetch<Match[]>("/matches");
}

export function uploadProfilePhoto(profileId: number, file: File) {
  const formData = new FormData();
  formData.append("image", file);
  return apiFetch<PhotoRef>(`/profiles/${profileId}/photos`, {
    method: "POST",
    body: formData,
  });
}

export function deleteProfilePhoto(profileId: number, photoId: number) {
  return apiFetch<void>(`/profiles/${profileId}/photos/${photoId}`, {
    method: "DELETE",
  });
}

export function reorderProfilePhotos(profileId: number, order: number[]) {
  return apiFetch<PhotoRef[]>(`/profiles/${profileId}/photos/reorder`, {
    method: "PATCH",
    body: { order },
  });
}

export function createPrompt(profileId: number, question: string, answer: string) {
  return apiFetch<Prompt>(`/profiles/${profileId}/prompts`, {
    method: "POST",
    body: { prompt: { question, answer } },
  });
}

export function updatePrompt(profileId: number, promptId: number, data: Partial<{ question: string; answer: string }>) {
  return apiFetch<Prompt>(`/profiles/${profileId}/prompts/${promptId}`, {
    method: "PATCH",
    body: { prompt: data },
  });
}

export function deletePrompt(profileId: number, promptId: number) {
  return apiFetch<void>(`/profiles/${profileId}/prompts/${promptId}`, {
    method: "DELETE",
  });
}

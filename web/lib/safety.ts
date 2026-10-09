import { apiFetch } from "./api";
import type { ProfileSummary } from "./profiles";

export interface Block {
  id: number;
  blocked_profile: ProfileSummary;
  created_at: string;
}

export const REPORT_REASONS = [
  { value: "spam", label: "Spam" },
  { value: "inappropriate", label: "Inappropriate content" },
  { value: "fake_profile", label: "Fake profile" },
  { value: "harassment", label: "Harassment" },
  { value: "underage", label: "Underage" },
  { value: "other", label: "Something else" },
] as const;

export type ReportReason = (typeof REPORT_REASONS)[number]["value"];

export function getBlocks() {
  return apiFetch<Block[]>("/blocks");
}

export function blockProfile(blockedProfileId: number) {
  return apiFetch<Block>("/blocks", {
    method: "POST",
    body: { blocked_profile_id: blockedProfileId },
  });
}

export function unblock(blockId: number) {
  return apiFetch<void>(`/blocks/${blockId}`, { method: "DELETE" });
}

export function reportProfile(reportedProfileId: number, reason: ReportReason, details?: string) {
  return apiFetch<{ id: number }>("/reports", {
    method: "POST",
    body: { reported_profile_id: reportedProfileId, reason, details: details || undefined },
  });
}

import { apiFetch } from "./api";
import type { ProfileSummary } from "./profiles";

export interface ConversationSummary {
  id: number;
  match_id: number;
  other_profile: ProfileSummary;
  last_message: { body: string; sent_at: string } | null;
  unread_count: number;
}

export interface Message {
  id: number;
  conversation_id: number;
  sender_account_id: number;
  body: string;
  sent_at: string;
  read_at: string | null;
}

export function getConversations() {
  return apiFetch<ConversationSummary[]>("/conversations");
}

export function createConversation(matchId: number) {
  return apiFetch<ConversationSummary>("/conversations", {
    method: "POST",
    body: { match_id: matchId },
  });
}

export const MESSAGES_PAGE_SIZE = 30;

// Newest page (ascending) older than beforeId, or the newest overall.
export function getMessages(conversationId: number, beforeId?: number) {
  const params = new URLSearchParams({ limit: String(MESSAGES_PAGE_SIZE) });
  if (beforeId) params.set("before_id", String(beforeId));
  return apiFetch<Message[]>(`/conversations/${conversationId}/messages?${params}`);
}

export function markConversationRead(conversationId: number) {
  return apiFetch<void>(`/conversations/${conversationId}/read`, { method: "POST" });
}

export function sendMessage(conversationId: number, body: string) {
  return apiFetch<Message>(`/conversations/${conversationId}/messages`, {
    method: "POST",
    body: { body },
  });
}

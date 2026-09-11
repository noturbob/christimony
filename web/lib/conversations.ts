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

export function getMessages(conversationId: number) {
  return apiFetch<Message[]>(`/conversations/${conversationId}/messages`);
}

export function sendMessage(conversationId: number, body: string) {
  return apiFetch<Message>(`/conversations/${conversationId}/messages`, {
    method: "POST",
    body: { body },
  });
}

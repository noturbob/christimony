import { apiFetch } from "./api";

export interface Conversation {
  id: number;
  match_id: number;
  profile_a_id: number;
  profile_b_id: number;
}

export interface Message {
  id: number;
  conversation_id: number;
  sender_account_id: number;
  body: string;
  sent_at: string;
  read_at: string | null;
}

export function getConversations(token: string) {
  return apiFetch<Conversation[]>("/conversations", { token });
}

export function createConversation(token: string, matchId: number) {
  return apiFetch<Conversation>("/conversations", {
    method: "POST",
    token,
    body: { match_id: matchId },
  });
}

export function getMessages(token: string, conversationId: number) {
  return apiFetch<Message[]>(`/conversations/${conversationId}/messages`, { token });
}

export function sendMessage(token: string, conversationId: number, body: string) {
  return apiFetch<Message>(`/conversations/${conversationId}/messages`, {
    method: "POST",
    token,
    body: { body },
  });
}
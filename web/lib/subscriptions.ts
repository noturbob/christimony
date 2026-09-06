import { apiFetch } from "./api";

export interface Subscription {
  id: number;
  plan: string;
  status: string;
  started_at: string;
  expires_at: string | null;
}

export function getSubscriptions(token: string) {
  return apiFetch<Subscription[]>("/subscriptions", { token });
}

export function createSubscription(token: string, plan: string) {
  return apiFetch<Subscription>("/subscriptions", {
    method: "POST",
    token,
    body: { plan },
  });
}
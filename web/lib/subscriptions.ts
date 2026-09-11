import { apiFetch } from "./api";

export interface Subscription {
  id: number;
  plan: string;
  status: string;
  started_at: string;
  expires_at: string | null;
}

export function getSubscriptions() {
  return apiFetch<Subscription[]>("/subscriptions");
}

export function createSubscription(plan: string) {
  return apiFetch<Subscription>("/subscriptions", {
    method: "POST",
    body: { plan },
  });
}

"use client";

import { useEffect, useState } from "react";
import { useAuth } from "@/lib/auth-context";
import { getSubscriptions, createSubscription, Subscription } from "@/lib/subscriptions";
import { Button } from "@/components/ui/button";

const PLANS = [
  { value: "free", name: "Free", price: "₹0", blurb: "Browse and send a limited number of interests." },
  { value: "premium", name: "Premium", price: "₹499/mo", blurb: "Unlimited interests, see who's interested in you, priority placement." },
  { value: "family", name: "Family", price: "₹899/mo", blurb: "Everything in Premium, for you and the profiles you manage." },
];

export default function SubscriptionPage() {
  const { account } = useAuth();
  const [subscriptions, setSubscriptions] = useState<Subscription[]>([]);
  const [loadingData, setLoadingData] = useState(true);
  const [subscribing, setSubscribing] = useState<string | null>(null);
  const [error, setError] = useState("");

  useEffect(() => {
    if (!account) return;
    getSubscriptions().then(setSubscriptions).finally(() => setLoadingData(false));
  }, [account]);

  const activeSub = subscriptions.find((s) => s.status === "active");

  async function handleSubscribe(plan: string) {
    setError("");
    setSubscribing(plan);
    try {
      const sub = await createSubscription(plan);
      setSubscriptions((prev) => [...prev, sub]);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to subscribe");
    } finally {
      setSubscribing(null);
    }
  }

  if (!account) return null;

  return (
    <div className="max-w-4xl mx-auto w-full px-6 py-12 md:py-16 space-y-10 md:space-y-14">
      <div className="text-center md:text-left space-y-3">
        <h1 className="font-display text-4xl md:text-5xl">Membership</h1>
        <p className="text-muted-foreground text-base md:text-lg">
          {loadingData ? "Loading..." : activeSub ? `You're on the ${activeSub.plan} plan.` : "Choose a plan to get started."}
        </p>
      </div>

      {error && <p className="text-sm text-destructive">{error}</p>}

      <div className="grid sm:grid-cols-3 gap-6">
        {PLANS.map((p) => {
          const isCurrent = activeSub?.plan === p.value;
          return (
            <div key={p.value} className={`rounded-2xl border p-8 flex flex-col gap-4 ${isCurrent ? "border-primary bg-primary/5" : p.value === "premium" ? "gradient-stroke bg-card" : "border-border bg-card"}`}>
              <div className="space-y-1.5">
                <h3 className="font-display text-2xl">{p.name}</h3>
                <p className="text-3xl font-medium">{p.price}</p>
              </div>
              <p className="text-base text-muted-foreground flex-1 leading-relaxed">{p.blurb}</p>
              <Button
                size="lg"
                className="rounded-full"
                variant={isCurrent ? "secondary" : "default"}
                disabled={isCurrent || subscribing === p.value || loadingData}
                onClick={() => handleSubscribe(p.value)}
              >
                {isCurrent ? "Current plan" : subscribing === p.value ? "..." : "Choose"}
              </Button>
            </div>
          );
        })}
      </div>
    </div>
  );
}

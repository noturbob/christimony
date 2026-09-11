"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { createProfile } from "@/lib/profiles";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";

export default function NewProfilePage() {
  const { account } = useAuth();
  const router = useRouter();

  const [name, setName] = useState("");
  const [profileType, setProfileType] = useState("self");
  const [city, setCity] = useState("");
  const [bio, setBio] = useState("");
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    setSubmitting(true);
    try {
      // Profiles are always created as "draft" server-side -- the profile
      // hub links into /edit to add photos/prompts and activate it.
      await createProfile({ name, profile_type: profileType, city, bio });
      router.push("/profile");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to create profile");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="max-w-md mx-auto w-full px-6 py-12 space-y-8">
      <div className="space-y-2">
        <h1 className="font-display text-4xl md:text-5xl">Create a profile</h1>
        <p className="text-muted-foreground text-base">
          {account?.account_type === "parent"
            ? "For yourself, or on behalf of your child."
            : "Tell us a bit about yourself."}
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4 rounded-2xl border border-border bg-card p-6">
        <div className="space-y-2">
          <Label htmlFor="name">Name</Label>
          <Input id="name" value={name} onChange={(e) => setName(e.target.value)} required />
        </div>

        {account?.account_type === "parent" && (
          <div className="space-y-2">
            <Label htmlFor="profileType">Who is this profile for?</Label>
            <select
              id="profileType"
              value={profileType}
              onChange={(e) => setProfileType(e.target.value)}
              className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
            >
              <option value="self">Myself</option>
              <option value="ward">My child</option>
            </select>
          </div>
        )}

        <div className="space-y-2">
          <Label htmlFor="city">City</Label>
          <Input id="city" value={city} onChange={(e) => setCity(e.target.value)} />
        </div>

        <div className="space-y-2">
          <Label htmlFor="bio">Bio</Label>
          <Textarea id="bio" value={bio} onChange={(e) => setBio(e.target.value)} rows={4} />
        </div>

        {error && <p className="text-sm text-destructive">{error}</p>}
        <Button type="submit" className="w-full rounded-full" disabled={submitting}>
          {submitting ? "Creating..." : "Create profile"}
        </Button>
      </form>
    </div>
  );
}

"use client";

import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { getProfile, updateProfile, Profile } from "@/lib/profiles";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";

export default function EditProfilePage() {
  const { account, token, loading } = useAuth();
  const router = useRouter();
  const params = useParams();
  const profileId = Number(params.id);

  const [profile, setProfile] = useState<Profile | null>(null);
  const [name, setName] = useState("");
  const [city, setCity] = useState("");
  const [bio, setBio] = useState("");
  const [education, setEducation] = useState("");
  const [profession, setProfession] = useState("");
  const [loadingData, setLoadingData] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [saved, setSaved] = useState(false);

  useEffect(() => {
    if (!loading && !account) router.push("/login");
  }, [loading, account, router]);

  useEffect(() => {
    if (!token) return;
    getProfile(token, profileId)
      .then((p) => {
        setProfile(p);
        setName(p.name);
        setCity(p.city ?? "");
        setBio(p.bio ?? "");
        setEducation(p.education ?? "");
        setProfession(p.profession ?? "");
      })
      .finally(() => setLoadingData(false));
  }, [token, profileId]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    if (!token) return;
    setError("");
    setSaving(true);
    setSaved(false);
    try {
      await updateProfile(token, profileId, { name, city, bio, education, profession });
      setSaved(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to save. You may not have permission to edit this profile.");
    } finally {
      setSaving(false);
    }
  }

  if (loading || loadingData) return <p className="p-8">Loading...</p>;
  if (!account || !profile) return null;

  return (
    <div className="max-w-2xl mx-auto px-6 py-10 space-y-6">
      <div>
        <h1 className="font-display text-3xl">Edit profile</h1>
        <p className="text-muted-foreground mt-1">Keep {profile.name}&apos;s details up to date.</p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-4 rounded-2xl border border-border bg-card p-6">
        <div className="space-y-2">
          <Label htmlFor="name">Name</Label>
          <Input id="name" value={name} onChange={(e) => setName(e.target.value)} required />
        </div>
        <div className="space-y-2">
          <Label htmlFor="city">City</Label>
          <Input id="city" value={city} onChange={(e) => setCity(e.target.value)} />
        </div>
        <div className="grid sm:grid-cols-2 gap-4">
          <div className="space-y-2">
            <Label htmlFor="education">Education</Label>
            <Input id="education" value={education} onChange={(e) => setEducation(e.target.value)} />
          </div>
          <div className="space-y-2">
            <Label htmlFor="profession">Profession</Label>
            <Input id="profession" value={profession} onChange={(e) => setProfession(e.target.value)} />
          </div>
        </div>
        <div className="space-y-2">
          <Label htmlFor="bio">Bio</Label>
          <Textarea id="bio" value={bio} onChange={(e) => setBio(e.target.value)} rows={4} />
        </div>

        {error && <p className="text-sm text-destructive">{error}</p>}
        {saved && <p className="text-sm text-primary">Saved.</p>}

        <Button type="submit" className="rounded-full" disabled={saving}>
          {saving ? "Saving..." : "Save changes"}
        </Button>
      </form>
    </div>
  );
}
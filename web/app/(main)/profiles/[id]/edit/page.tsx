"use client";

import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import { getProfile, updateProfile, uploadProfilePhoto, deleteProfilePhoto, Profile } from "@/lib/profiles";
import { getVouches, createVouch, Vouch } from "@/lib/vouches";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";

export default function EditProfilePage() {
  const { account } = useAuth();
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
  const [uploading, setUploading] = useState(false);

  const [vouches, setVouches] = useState<Vouch[]>([]);
  const [voucherName, setVoucherName] = useState("");
  const [voucherRole, setVoucherRole] = useState("pastor");
  const [submittingVouch, setSubmittingVouch] = useState(false);

  useEffect(() => {
    if (!account) return;
    Promise.all([getProfile(profileId), getVouches(profileId)])
      .then(([p, v]) => {
        setProfile(p);
        setName(p.name);
        setCity(p.city ?? "");
        setBio(p.bio ?? "");
        setEducation(p.education ?? "");
        setProfession(p.profession ?? "");
        setVouches(v);
      })
      .finally(() => setLoadingData(false));
  }, [account, profileId]);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    setSaving(true);
    setSaved(false);
    try {
      await updateProfile(profileId, { name, city, bio, education, profession });
      setSaved(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to save. You may not have permission to edit this profile.");
    } finally {
      setSaving(false);
    }
  }

  async function handleActivate() {
    setError("");
    try {
      const updated = await updateProfile(profileId, { status: "active" });
      setProfile(updated);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to activate profile");
    }
  }

  async function handlePhotoUpload(e: React.ChangeEvent<HTMLInputElement>) {
    if (!e.target.files?.[0]) return;
    setUploading(true);
    try {
      const photo = await uploadProfilePhoto(profileId, e.target.files[0]);
      setProfile((prev) => (prev ? { ...prev, photos: [...prev.photos, photo] } : prev));
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to upload photo");
    } finally {
      setUploading(false);
      e.target.value = "";
    }
  }

  async function handlePhotoDelete(photoId: number) {
    try {
      await deleteProfilePhoto(profileId, photoId);
      setProfile((prev) => (prev ? { ...prev, photos: prev.photos.filter((p) => p.id !== photoId) } : prev));
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to delete photo");
    }
  }

  async function handleVouch(e: React.FormEvent) {
    e.preventDefault();
    if (!voucherName.trim()) return;
    setSubmittingVouch(true);
    try {
      const vouch = await createVouch(profileId, { voucher_name: voucherName, voucher_role: voucherRole });
      setVouches((prev) => [...prev, vouch]);
      setVoucherName("");
    } finally {
      setSubmittingVouch(false);
    }
  }

  if (loadingData) return <p className="p-8">Loading...</p>;
  if (!account || !profile) return null;

  return (
    <div className="max-w-2xl mx-auto w-full px-6 py-12 space-y-8">
      <div className="space-y-2">
        <h1 className="font-display text-4xl md:text-5xl">Edit profile</h1>
        <p className="text-muted-foreground text-base">Keep {profile.name}&apos;s details up to date.</p>
      </div>

      {profile.status === "draft" && (
        <div className="rounded-2xl border border-dashed border-primary/40 bg-primary/5 p-5 flex items-center justify-between gap-4">
          <div>
            <p className="font-medium">This profile is a draft</p>
            <p className="text-sm text-muted-foreground">It won&apos;t show up in anyone&apos;s feed until you activate it.</p>
          </div>
          <Button className="rounded-full shrink-0" onClick={handleActivate} disabled={profile.photos.length === 0}>
            Activate
          </Button>
        </div>
      )}

      <div className="space-y-3">
        <p className="text-sm font-medium">Photos</p>
        <div className="grid grid-cols-3 gap-2">
          {[...profile.photos]
            .sort((a, b) => a.position - b.position)
            .map((photo) => (
              <div key={photo.id} className="relative aspect-square rounded-xl overflow-hidden bg-secondary">
                {/* eslint-disable-next-line @next/next/no-img-element */}
                <img src={photo.thumb_url} alt="" className="w-full h-full object-cover" />
                <button
                  onClick={() => handlePhotoDelete(photo.id)}
                  className="absolute top-1 right-1 h-6 w-6 rounded-full bg-black/60 text-white text-xs flex items-center justify-center"
                >
                  ✕
                </button>
              </div>
            ))}
          {profile.photos.length < 6 && (
            <label className="aspect-square rounded-xl border border-dashed border-border flex items-center justify-center cursor-pointer text-2xl text-muted-foreground">
              {uploading ? "..." : "+"}
              <input type="file" accept="image/*" onChange={handlePhotoUpload} className="hidden" disabled={uploading} />
            </label>
          )}
        </div>
        {profile.photos.length < 2 && (
          <p className="text-xs text-muted-foreground">Add at least 2 photos before activating this profile.</p>
        )}
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

      <div className="space-y-4">
        <div>
          <h2 className="font-display text-xl">Vouches</h2>
          <p className="text-sm text-muted-foreground mt-1">
            Ask a pastor, elder, or family friend to vouch for {profile.name} — it builds trust with people who view this profile.
          </p>
        </div>

        {vouches.length > 0 && (
          <div className="space-y-2">
            {vouches.map((v) => (
              <div key={v.id} className="rounded-xl border border-border bg-card px-4 py-3 text-sm flex items-center justify-between">
                <span>{v.voucher_name} <span className="text-muted-foreground capitalize">· {v.voucher_role}</span></span>
                <span className="text-xs text-muted-foreground capitalize">{v.status}</span>
              </div>
            ))}
          </div>
        )}

        <form onSubmit={handleVouch} className="rounded-2xl border border-border bg-card p-5 space-y-3">
          <div className="grid sm:grid-cols-2 gap-3">
            <div className="space-y-1">
              <Label htmlFor="voucherName">Their name</Label>
              <Input id="voucherName" value={voucherName} onChange={(e) => setVoucherName(e.target.value)} required />
            </div>
            <div className="space-y-1">
              <Label htmlFor="voucherRole">Their role</Label>
              <select
                id="voucherRole"
                value={voucherRole}
                onChange={(e) => setVoucherRole(e.target.value)}
                className="w-full rounded-md border border-input bg-background px-3 py-2 text-sm"
              >
                <option value="pastor">Pastor</option>
                <option value="elder">Elder</option>
                <option value="family_friend">Family friend</option>
                <option value="other">Other</option>
              </select>
            </div>
          </div>
          <Button type="submit" size="sm" className="rounded-full" disabled={submittingVouch}>
            {submittingVouch ? "Adding..." : "Add vouch"}
          </Button>
        </form>
      </div>
    </div>
  );
}

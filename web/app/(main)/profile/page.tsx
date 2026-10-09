"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { ChevronRight, LogOut } from "lucide-react";
import { deleteAccount, useAuth } from "@/lib/auth-context";
import { getMyProfiles, Profile } from "@/lib/profiles";
import { getBlocks, unblock, Block } from "@/lib/safety";
import { Modal } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

const DELETE_PHRASE = "DELETE";

export default function ProfileHubPage() {
  const { account, logout } = useAuth();
  const router = useRouter();
  const [profiles, setProfiles] = useState<Profile[]>([]);
  const [loadingProfiles, setLoadingProfiles] = useState(true);
  const [blocks, setBlocks] = useState<Block[]>([]);
  const [deleteOpen, setDeleteOpen] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState("");
  const [deleting, setDeleting] = useState(false);
  const [deleteError, setDeleteError] = useState("");

  useEffect(() => {
    if (!account) return;
    getMyProfiles().then(setProfiles).finally(() => setLoadingProfiles(false));
    getBlocks().then(setBlocks).catch(() => {});
  }, [account]);

  async function handleUnblock(id: number) {
    await unblock(id).catch(() => {});
    setBlocks((b) => b.filter((x) => x.id !== id));
  }

  async function handleDelete() {
    setDeleting(true);
    setDeleteError("");
    try {
      await deleteAccount();
      await logout();
      router.replace("/");
    } catch (err) {
      setDeleteError(err instanceof Error ? err.message : "Couldn't delete your account");
      setDeleting(false);
    }
  }

  if (!account) return null;

  // Two parents matching only becomes an Introduction when both have a
  // ward (child) profile, so a parent without one is effectively invisible.
  const needsWard = account.account_type === "parent" && !loadingProfiles && !profiles.some((p) => p.profile_type === "ward");

  return (
    <div className="max-w-md mx-auto w-full px-6 py-12 space-y-10">
      <div className="space-y-2">
        <h1 className="font-display text-4xl md:text-5xl">Profile</h1>
        <p className="text-muted-foreground text-base">{account.email ?? account.phone}</p>
      </div>

      {needsWard && (
        <div className="rounded-3xl border border-[color:var(--blush)]/40 bg-[color:var(--blush)]/5 p-6 space-y-4">
          <div className="space-y-1.5">
            <h2 className="font-display text-2xl">
              Add your <em className="serif-italic text-[var(--blush)]">child&apos;s</em> profile
            </h2>
            <p className="text-sm text-muted-foreground">
              When you match with another parent, we only introduce your children if both families have a profile for their child.
            </p>
          </div>
          <Link href="/profiles/new">
            <Button>Create your child&apos;s profile</Button>
          </Link>
        </div>
      )}

      <div className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">Your profiles</h2>
          <Link href="/profiles/new" className="text-sm text-primary font-medium">+ New</Link>
        </div>

        {loadingProfiles ? (
          <p className="text-muted-foreground text-sm">Loading...</p>
        ) : profiles.length === 0 ? (
          <div className="rounded-2xl border border-dashed border-border p-10 text-center">
            <p className="text-muted-foreground text-sm mb-5">
              {account.account_type === "parent"
                ? "Create a profile for yourself, or on behalf of your child."
                : "Create your profile to start browsing."}
            </p>
            <Link href="/profiles/new">
              <Button size="lg" className="rounded-full">Create a profile</Button>
            </Link>
          </div>
        ) : (
          <div className="space-y-3">
            {profiles.map((p) => (
              <Link
                key={p.id}
                href={`/profiles/${p.id}/edit`}
                className="flex items-center gap-4 rounded-2xl border border-border bg-card p-5"
              >
                <div className="h-12 w-12 rounded-full bg-secondary overflow-hidden flex items-center justify-center shrink-0">
                  {p.photos[0] ? (
                    /* eslint-disable-next-line @next/next/no-img-element */
                    <img src={p.photos[0].thumb_url} alt="" className="w-full h-full object-cover" />
                  ) : (
                    <span className="font-display text-lg text-primary/50">{p.name.charAt(0)}</span>
                  )}
                </div>
                <div className="flex-1">
                  <p className="font-medium">{p.name}</p>
                  <p className="text-xs text-muted-foreground capitalize">
                    {p.profile_type === "ward" ? "child's" : p.profile_type} profile{p.city ? ` · ${p.city}` : ""}
                    {p.status === "draft" ? " · draft" : ""}
                  </p>
                </div>
                <ChevronRight size={18} className="text-muted-foreground" />
              </Link>
            ))}
          </div>
        )}
      </div>

      <div className="space-y-3">
        <h2 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">Account</h2>
        <Link href="/verification" className="flex items-center justify-between rounded-2xl border border-border bg-card p-5">
          <span className="font-medium">Verification</span>
          <ChevronRight size={18} className="text-muted-foreground" />
        </Link>
        <Link href="/subscription" className="flex items-center justify-between rounded-2xl border border-border bg-card p-5">
          <span className="font-medium">Membership</span>
          <ChevronRight size={18} className="text-muted-foreground" />
        </Link>
        <button
          onClick={async () => {
            await logout();
            router.push("/login");
          }}
          className="w-full flex items-center justify-between rounded-2xl border border-border bg-card p-5 text-destructive"
        >
          <span className="font-medium flex items-center gap-2"><LogOut size={16} /> Log out</span>
        </button>
      </div>

      <div className="space-y-3">
        <h2 className="text-sm font-medium text-muted-foreground uppercase tracking-wide">Blocked</h2>
        {blocks.length === 0 ? (
          <p className="text-sm text-muted-foreground">You haven&apos;t blocked anyone.</p>
        ) : (
          <div className="space-y-2">
            {blocks.map((b) => (
              <div key={b.id} className="flex items-center gap-3 rounded-2xl border border-border bg-card px-5 py-3">
                <div className="h-9 w-9 rounded-full bg-secondary overflow-hidden flex items-center justify-center shrink-0">
                  {b.blocked_profile.cover_photo_url ? (
                    /* eslint-disable-next-line @next/next/no-img-element */
                    <img src={b.blocked_profile.cover_photo_url} alt="" className="w-full h-full object-cover" />
                  ) : (
                    <span className="font-display text-primary/50">{b.blocked_profile.name.charAt(0)}</span>
                  )}
                </div>
                <span className="flex-1 font-medium truncate">{b.blocked_profile.name}</span>
                <Button variant="ghost" size="sm" onClick={() => handleUnblock(b.id)}>Unblock</Button>
              </div>
            ))}
          </div>
        )}
      </div>

      <div className="space-y-3 pt-4 border-t border-border">
        <button
          onClick={() => {
            setDeleteConfirm("");
            setDeleteError("");
            setDeleteOpen(true);
          }}
          className="text-sm text-destructive underline underline-offset-4"
        >
          Delete account
        </button>
      </div>

      <Modal
        open={deleteOpen}
        onOpenChange={(o) => !deleting && setDeleteOpen(o)}
        title="Delete your account?"
        description="This permanently deletes your account and every profile you own — photos, matches, conversations and introductions. It can't be undone."
      >
        <div className="space-y-2">
          <label htmlFor="delete-confirm" className="text-sm">
            Type <span className="font-semibold text-destructive">{DELETE_PHRASE}</span> to confirm
          </label>
          <Input
            id="delete-confirm"
            value={deleteConfirm}
            onChange={(e) => setDeleteConfirm(e.target.value)}
            autoComplete="off"
            className="rounded-full"
          />
        </div>
        {deleteError && <p className="text-sm text-destructive">{deleteError}</p>}
        <div className="flex justify-end gap-2">
          <Button variant="ghost" onClick={() => setDeleteOpen(false)} disabled={deleting}>Cancel</Button>
          <Button variant="destructive" onClick={handleDelete} disabled={deleteConfirm !== DELETE_PHRASE || deleting}>
            {deleting ? "Deleting..." : "Delete forever"}
          </Button>
        </div>
      </Modal>
    </div>
  );
}

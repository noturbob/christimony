"use client";

import { useState } from "react";
import { Flag, Ban } from "lucide-react";
import { blockProfile, reportProfile, REPORT_REASONS, type ReportReason } from "@/lib/safety";
import { Modal } from "@/components/ui/dialog";
import { Button } from "@/components/ui/button";
import { Textarea } from "@/components/ui/textarea";

// Report and Block are separate actions (a report doesn't block), but a
// finished report offers Block as the obvious next step.
export function SafetyActions({
  profileId,
  profileName,
  onBlocked,
}: {
  profileId: number;
  profileName: string;
  onBlocked: () => void;
}) {
  const [dialog, setDialog] = useState<"report" | "block" | null>(null);
  const [reason, setReason] = useState<ReportReason | null>(null);
  const [details, setDetails] = useState("");
  const [reported, setReported] = useState(false);
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState("");

  function open(which: "report" | "block") {
    setError("");
    setDialog(which);
  }

  async function submitReport() {
    if (!reason) return;
    setBusy(true);
    setError("");
    try {
      await reportProfile(profileId, reason, details.trim());
      setReported(true);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't send the report");
    } finally {
      setBusy(false);
    }
  }

  async function confirmBlock() {
    setBusy(true);
    setError("");
    try {
      await blockProfile(profileId);
      setDialog(null);
      onBlocked();
    } catch (err) {
      setError(err instanceof Error ? err.message : "Couldn't block this profile");
      setBusy(false);
    }
  }

  return (
    <>
      <div className="flex items-center gap-4 text-xs text-muted-foreground">
        <button onClick={() => open("report")} className="flex items-center gap-1.5 hover:text-foreground">
          <Flag size={13} /> Report
        </button>
        <button onClick={() => open("block")} className="flex items-center gap-1.5 hover:text-destructive">
          <Ban size={13} /> Block
        </button>
      </div>

      <Modal
        open={dialog === "report"}
        onOpenChange={(o) => !o && setDialog(null)}
        title={reported ? "Thanks for telling us." : `Report ${profileName}`}
        description={
          reported
            ? "Our team will review it. Reporting doesn't block them, so block them too if you'd rather not see them."
            : "Reports are private. They won't know it was you."
        }
      >
        {reported ? (
          <div className="flex flex-col gap-2">
            <Button variant="destructive" onClick={() => open("block")}>Block {profileName}</Button>
            <Button variant="ghost" onClick={() => setDialog(null)}>Done</Button>
          </div>
        ) : (
          <>
            <div className="grid grid-cols-2 gap-2">
              {REPORT_REASONS.map((r) => (
                <button
                  key={r.value}
                  type="button"
                  onClick={() => setReason(r.value)}
                  className={`rounded-2xl border px-3 py-2.5 text-left text-sm transition-colors ${
                    reason === r.value ? "border-primary bg-primary/5" : "border-border hover:bg-secondary/40"
                  }`}
                >
                  {r.label}
                </button>
              ))}
            </div>
            <Textarea
              value={details}
              onChange={(e) => setDetails(e.target.value)}
              maxLength={1000}
              rows={3}
              placeholder="Anything else we should know? (optional)"
              className="rounded-2xl"
            />
            {error && <p className="text-sm text-destructive">{error}</p>}
            <div className="flex justify-end gap-2">
              <Button variant="ghost" onClick={() => setDialog(null)}>Cancel</Button>
              <Button onClick={submitReport} disabled={!reason || busy}>{busy ? "Sending..." : "Send report"}</Button>
            </div>
          </>
        )}
      </Modal>

      <Modal
        open={dialog === "block"}
        onOpenChange={(o) => !o && setDialog(null)}
        title={`Block ${profileName}?`}
        description="You won't see each other anywhere on Christimony, and any conversation disappears. You can unblock later from your Profile."
      >
        {error && <p className="text-sm text-destructive">{error}</p>}
        <div className="flex justify-end gap-2">
          <Button variant="ghost" onClick={() => setDialog(null)}>Cancel</Button>
          <Button variant="destructive" onClick={confirmBlock} disabled={busy}>{busy ? "Blocking..." : "Block"}</Button>
        </div>
      </Modal>
    </>
  );
}

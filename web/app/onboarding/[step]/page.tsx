"use client";

import { use, useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { useAuth } from "@/lib/auth-context";
import {
  createProfile,
  updateProfile,
  uploadProfilePhoto,
  createPrompt,
  getDenominations,
  getPromptQuestions,
  Denomination,
} from "@/lib/profiles";
import { STEPS, EMPTY_DRAFT, loadDraft, saveDraft, clearDraft, stepIndex, OnboardingDraft } from "@/lib/onboarding";
import { WizardShell } from "@/components/onboarding/wizard-shell";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";

const MIN_PHOTOS = 2;
const REQUIRED_PROMPTS = 3;

export default function OnboardingStepPage({ params }: { params: Promise<{ step: string }> }) {
  const { step } = use(params);
  const { account } = useAuth();
  const router = useRouter();

  const [draft, setDraft] = useState<OnboardingDraft>(EMPTY_DRAFT);
  const [hydrated, setHydrated] = useState(false);
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [denominations, setDenominations] = useState<Denomination[]>([]);
  const [questionBank, setQuestionBank] = useState<string[]>([]);
  const [uploading, setUploading] = useState(false);

  const index = stepIndex(step);

  useEffect(() => {
    const loaded = loadDraft();
    const isFreshDraft = loaded === EMPTY_DRAFT;
    // eslint-disable-next-line react-hooks/set-state-in-effect -- one-time sync from sessionStorage on mount, can't be read during render (SSR)
    setDraft(isFreshDraft && account?.account_type === "parent" ? { ...loaded, accountType: "parent" } : loaded);
    setHydrated(true);
  }, [account]);

  useEffect(() => {
    if (step === "denomination" && denominations.length === 0) {
      getDenominations().then(setDenominations).catch(() => {});
    }
    if (step === "prompts" && questionBank.length === 0) {
      getPromptQuestions().then(setQuestionBank).catch(() => {});
    }
  }, [step, denominations.length, questionBank.length]);

  useEffect(() => {
    if (hydrated) saveDraft(draft);
  }, [draft, hydrated]);

  if (index === -1) {
    router.replace("/onboarding/account-type");
    return null;
  }

  if (!hydrated) return null;

  function update<K extends keyof OnboardingDraft>(key: K, value: OnboardingDraft[K]) {
    setDraft((d) => ({ ...d, [key]: value }));
  }

  function goTo(nextStep: string) {
    setError("");
    router.push(`/onboarding/${nextStep}`);
  }

  function goBack() {
    if (index === 0) return;
    goTo(STEPS[index - 1]);
  }

  async function goNext() {
    setError("");

    // The step right after basic-info collection creates the draft
    // profile server-side (it needs a profile_id before photos/prompts
    // can attach to anything).
    if (step === "education" && !draft.profileId) {
      setSubmitting(true);
      try {
        const profile = await createProfile({
          name: draft.name,
          profile_type: "self",
          gender: draft.gender,
          dob: draft.dob,
          city: draft.city,
          denomination_id: draft.denominationId ?? undefined,
          education: draft.education,
          profession: draft.profession,
        });
        update("profileId", profile.id);
        goTo("photos");
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to save your profile");
      } finally {
        setSubmitting(false);
      }
      return;
    }

    if (step === "bio" && draft.profileId) {
      setSubmitting(true);
      try {
        await updateProfile(draft.profileId, { bio: draft.bio });
        goTo("review");
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to save");
      } finally {
        setSubmitting(false);
      }
      return;
    }

    if (step === "review") {
      if (!draft.profileId) return;
      setSubmitting(true);
      try {
        await updateProfile(draft.profileId, { status: "active" });
        clearDraft();
        router.push("/discover");
      } catch (err) {
        setError(err instanceof Error ? err.message : "Failed to activate your profile");
      } finally {
        setSubmitting(false);
      }
      return;
    }

    goTo(STEPS[index + 1]);
  }

  async function handlePhotoUpload(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file || !draft.profileId) return;
    setUploading(true);
    setError("");
    try {
      await uploadProfilePhoto(draft.profileId, file);
      update("photoCount", draft.photoCount + 1);
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to upload photo");
    } finally {
      setUploading(false);
      e.target.value = "";
    }
  }

  function toggleQuestion(question: string) {
    setDraft((d) => {
      const already = d.selectedQuestions.includes(question);
      if (already) {
        const rest = { ...d.answers };
        delete rest[question];
        return { ...d, selectedQuestions: d.selectedQuestions.filter((q) => q !== question), answers: rest };
      }
      if (d.selectedQuestions.length >= REQUIRED_PROMPTS) return d;
      return { ...d, selectedQuestions: [...d.selectedQuestions, question] };
    });
  }

  async function handlePromptsNext() {
    if (!draft.profileId) return;
    setSubmitting(true);
    setError("");
    try {
      await Promise.all(
        draft.selectedQuestions.map((q) => createPrompt(draft.profileId as number, q, draft.answers[q] ?? ""))
      );
      goTo("bio");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Failed to save your prompts");
    } finally {
      setSubmitting(false);
    }
  }

  const canContinue = (() => {
    switch (step) {
      case "account-type":
        return !!draft.accountType;
      case "name":
        return draft.name.trim().length > 0;
      case "dob":
        return isAdult(draft.dob);
      case "gender":
        return !!draft.gender;
      case "denomination":
        return true;
      case "city":
        return draft.city.trim().length > 0;
      case "education":
        return true;
      case "photos":
        return draft.photoCount >= MIN_PHOTOS;
      case "prompts":
        return draft.selectedQuestions.length === REQUIRED_PROMPTS && draft.selectedQuestions.every((q) => (draft.answers[q] ?? "").trim().length > 0);
      case "bio":
        return true;
      case "review":
        return true;
      default:
        return false;
    }
  })();

  return (
    <WizardShell step={index} totalSteps={STEPS.length} onBack={index > 0 ? goBack : undefined}>
      <div className="flex-1 flex flex-col">
        {step === "account-type" && (
          <StepFrame title="Who is this for?">
            <div className="space-y-3">
              <OptionCard
                label="Myself"
                description="I'm creating my own profile."
                selected={draft.accountType === "individual"}
                onClick={() => update("accountType", "individual")}
              />
              <OptionCard
                label="My child"
                description="I'm a parent helping guide my child's search."
                selected={draft.accountType === "parent"}
                onClick={() => update("accountType", "parent")}
              />
            </div>
          </StepFrame>
        )}

        {step === "name" && (
          <StepFrame title="What's your name?">
            <Input
              autoFocus
              value={draft.name}
              onChange={(e) => update("name", e.target.value)}
              placeholder="Full name"
              className="h-14 text-lg rounded-2xl"
            />
          </StepFrame>
        )}

        {step === "dob" && (
          <StepFrame title="When were you born?">
            <Input
              type="date"
              autoFocus
              value={draft.dob}
              onChange={(e) => update("dob", e.target.value)}
              className="h-14 text-lg rounded-2xl"
            />
            {draft.dob && !isAdult(draft.dob) && (
              <p className="text-sm text-destructive mt-2">You must be 18 or older to join Christimony.</p>
            )}
          </StepFrame>
        )}

        {step === "gender" && (
          <StepFrame title="I am...">
            <div className="space-y-3">
              <OptionCard label="Male" selected={draft.gender === "male"} onClick={() => update("gender", "male")} />
              <OptionCard label="Female" selected={draft.gender === "female"} onClick={() => update("gender", "female")} />
            </div>
          </StepFrame>
        )}

        {step === "denomination" && (
          <StepFrame title="What's your denomination?" subtitle="Optional, but helps us match you well.">
            <div className="grid grid-cols-1 gap-2 max-h-96 overflow-y-auto pr-1">
              {denominations.map((d) => (
                <OptionCard
                  key={d.id}
                  label={d.name}
                  compact
                  selected={draft.denominationId === d.id}
                  onClick={() => {
                    update("denominationId", d.id);
                    update("denominationName", d.name);
                  }}
                />
              ))}
            </div>
          </StepFrame>
        )}

        {step === "city" && (
          <StepFrame title="Where are you based?">
            <Input
              autoFocus
              value={draft.city}
              onChange={(e) => update("city", e.target.value)}
              placeholder="City"
              className="h-14 text-lg rounded-2xl"
            />
          </StepFrame>
        )}

        {step === "education" && (
          <StepFrame title="Education & work" subtitle="Optional — you can always add this later.">
            <div className="space-y-4">
              <Input
                value={draft.education}
                onChange={(e) => update("education", e.target.value)}
                placeholder="Education"
                className="h-12 rounded-xl"
              />
              <Input
                value={draft.profession}
                onChange={(e) => update("profession", e.target.value)}
                placeholder="Profession"
                className="h-12 rounded-xl"
              />
            </div>
          </StepFrame>
        )}

        {step === "photos" && (
          <StepFrame title="Add your photos" subtitle={`At least ${MIN_PHOTOS} photos help people take your profile seriously.`}>
            <label className="aspect-[4/5] w-full max-w-[220px] mx-auto rounded-2xl border-2 border-dashed border-border flex flex-col items-center justify-center gap-2 cursor-pointer text-muted-foreground">
              <span className="text-3xl">{uploading ? "…" : "+"}</span>
              <span className="text-sm">{uploading ? "Uploading..." : "Add a photo"}</span>
              <input type="file" accept="image/*" onChange={handlePhotoUpload} className="hidden" disabled={uploading} />
            </label>
            <p className="text-center text-sm text-muted-foreground mt-4">{draft.photoCount} of {MIN_PHOTOS} minimum added</p>
          </StepFrame>
        )}

        {step === "prompts" && (
          <StepFrame title="Answer 3 prompts" subtitle="These show up on your profile — pick ones that feel like you.">
            <div className="space-y-3 max-h-[26rem] overflow-y-auto pr-1">
              {questionBank.map((q) => {
                const selected = draft.selectedQuestions.includes(q);
                return (
                  <div key={q} className={`rounded-2xl border p-4 space-y-2 ${selected ? "border-primary bg-primary/5" : "border-border"}`}>
                    <button
                      type="button"
                      onClick={() => toggleQuestion(q)}
                      className="text-left text-sm font-medium w-full"
                      disabled={!selected && draft.selectedQuestions.length >= REQUIRED_PROMPTS}
                    >
                      {q}
                    </button>
                    {selected && (
                      <Textarea
                        autoFocus
                        value={draft.answers[q] ?? ""}
                        onChange={(e) => update("answers", { ...draft.answers, [q]: e.target.value })}
                        placeholder="Your answer"
                        rows={2}
                        className="rounded-xl"
                      />
                    )}
                  </div>
                );
              })}
            </div>
            <p className="text-center text-sm text-muted-foreground mt-3">{draft.selectedQuestions.length} of {REQUIRED_PROMPTS} selected</p>
          </StepFrame>
        )}

        {step === "bio" && (
          <StepFrame title="Tell your story" subtitle="A few sentences about you and what you're looking for.">
            <Textarea
              autoFocus
              value={draft.bio}
              onChange={(e) => update("bio", e.target.value)}
              rows={6}
              className="rounded-2xl"
              placeholder="I'm someone who..."
            />
          </StepFrame>
        )}

        {step === "review" && (
          <StepFrame title="Ready to go" subtitle="Here's what people will see first.">
            <div className="rounded-2xl border border-border bg-card p-5 space-y-2">
              <p className="font-display text-xl">{draft.name}</p>
              <p className="text-sm text-muted-foreground">
                {[draft.city, draft.denominationName, draft.profession].filter(Boolean).join(" · ")}
              </p>
              <p className="text-sm text-muted-foreground">{draft.photoCount} photos · {draft.selectedQuestions.length} prompts</p>
              {draft.bio && <p className="text-sm pt-2 border-t border-border">{draft.bio}</p>}
            </div>
          </StepFrame>
        )}

        {error && <p className="text-sm text-destructive mt-4">{error}</p>}

        <div className="mt-auto pt-8">
          <Button
            className="w-full rounded-full h-12 text-base"
            disabled={!canContinue || submitting}
            onClick={step === "prompts" ? handlePromptsNext : goNext}
          >
            {submitting ? "Saving..." : step === "review" ? "Start browsing" : "Continue"}
          </Button>
        </div>
      </div>
    </WizardShell>
  );
}

function StepFrame({ title, subtitle, children }: { title: string; subtitle?: string; children: React.ReactNode }) {
  return (
    <div>
      <h1 className="font-display text-3xl mb-1">{title}</h1>
      {subtitle && <p className="text-muted-foreground text-sm mb-6">{subtitle}</p>}
      {!subtitle && <div className="mb-6" />}
      {children}
    </div>
  );
}

function OptionCard({
  label,
  description,
  selected,
  onClick,
  compact,
}: {
  label: string;
  description?: string;
  selected: boolean;
  onClick: () => void;
  compact?: boolean;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      className={`w-full text-left rounded-2xl border ${compact ? "p-3" : "p-4"} transition-colors ${
        selected ? "border-primary bg-primary/5" : "border-border hover:bg-secondary/40"
      }`}
    >
      <p className="font-medium">{label}</p>
      {description && <p className="text-sm text-muted-foreground mt-0.5">{description}</p>}
    </button>
  );
}

function isAdult(dob: string) {
  if (!dob) return false;
  const birth = new Date(dob);
  if (Number.isNaN(birth.getTime())) return false;
  const eighteenYearsAgo = new Date();
  eighteenYearsAgo.setFullYear(eighteenYearsAgo.getFullYear() - 18);
  return birth <= eighteenYearsAgo;
}

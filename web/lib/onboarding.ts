export const STEPS = [
  "account-type",
  "name",
  "dob",
  "gender",
  "denomination",
  "city",
  "education",
  "photos",
  "prompts",
  "bio",
  "review",
] as const;

export type Step = (typeof STEPS)[number];

export interface OnboardingDraft {
  accountType: "individual" | "parent";
  name: string;
  dob: string;
  gender: string;
  denominationId: number | null;
  denominationName: string;
  city: string;
  education: string;
  profession: string;
  bio: string;
  profileId: number | null;
  photoCount: number;
  selectedQuestions: string[];
  answers: Record<string, string>;
}

export const EMPTY_DRAFT: OnboardingDraft = {
  accountType: "individual",
  name: "",
  dob: "",
  gender: "",
  denominationId: null,
  denominationName: "",
  city: "",
  education: "",
  profession: "",
  bio: "",
  profileId: null,
  photoCount: 0,
  selectedQuestions: [],
  answers: {},
};

const STORAGE_KEY = "christimony-onboarding-draft";

export function loadDraft(): OnboardingDraft {
  if (typeof window === "undefined") return EMPTY_DRAFT;
  try {
    const raw = sessionStorage.getItem(STORAGE_KEY);
    if (!raw) return EMPTY_DRAFT;
    return { ...EMPTY_DRAFT, ...JSON.parse(raw) };
  } catch {
    return EMPTY_DRAFT;
  }
}

export function saveDraft(draft: OnboardingDraft) {
  if (typeof window === "undefined") return;
  sessionStorage.setItem(STORAGE_KEY, JSON.stringify(draft));
}

export function clearDraft() {
  if (typeof window === "undefined") return;
  sessionStorage.removeItem(STORAGE_KEY);
}

export function stepIndex(step: string): number {
  return STEPS.indexOf(step as Step);
}

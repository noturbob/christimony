"use client";

import { AnimatePresence, motion } from "motion/react";
import { ChevronLeft } from "lucide-react";
import { ReactNode } from "react";

export function WizardShell({
  step,
  totalSteps,
  onBack,
  children,
}: {
  step: number;
  totalSteps: number;
  onBack?: () => void;
  children: ReactNode;
}) {
  const progress = ((step + 1) / totalSteps) * 100;

  return (
    <div className="min-h-screen flex flex-col">
      <div className="sticky top-0 z-10 bg-background">
        <div className="max-w-md mx-auto w-full px-6 pt-6 pb-3 flex items-center gap-4">
          {onBack ? (
            <button onClick={onBack} className="text-muted-foreground hover:text-foreground -ml-1 p-1" aria-label="Back">
              <ChevronLeft size={22} />
            </button>
          ) : (
            <div className="w-6" />
          )}
          <div className="flex-1 h-1.5 rounded-full bg-secondary overflow-hidden">
            <motion.div
              className="h-full bg-primary rounded-full"
              initial={false}
              animate={{ width: `${progress}%` }}
              transition={{ duration: 0.4, ease: "easeOut" }}
            />
          </div>
        </div>
      </div>

      <div className="flex-1 max-w-md mx-auto w-full px-6 py-6 flex flex-col">
        <AnimatePresence mode="wait">
          <motion.div
            key={step}
            initial={{ opacity: 0, x: 24 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -24 }}
            transition={{ duration: 0.25, ease: "easeOut" }}
            className="flex-1 flex flex-col"
          >
            {children}
          </motion.div>
        </AnimatePresence>
      </div>
    </div>
  );
}

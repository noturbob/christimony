import Link from "next/link";
import { Button } from "@/components/ui/button";

function Eyebrow({ children }: { children: React.ReactNode }) {
  return (
    <span className="inline-flex items-center gap-2 text-xs tracking-[0.2em] uppercase text-accent font-medium">
      <span className="h-px w-6 bg-accent" />
      {children}
    </span>
  );
}

export default function LandingPage() {
  return (
    <div className="min-h-screen">
      {/* Nav */}
      <header className="sticky top-0 z-10 bg-background/90 backdrop-blur border-b border-border">
        <div className="max-w-6xl mx-auto px-6 py-4 flex items-center justify-between">
          <span className="font-display text-xl text-primary">Christimony</span>
          <div className="flex items-center gap-3">
            <Link href="/login" className="text-sm text-muted-foreground hover:text-foreground">
              Log in
            </Link>
            <Link href="/signup">
              <Button size="sm" className="rounded-full">Get started</Button>
            </Link>
          </div>
        </div>
      </header>

      {/* Hero */}
      <section className="relative overflow-hidden bg-primary text-primary-foreground">
        <div
          className="absolute inset-0 opacity-[0.07]"
          style={{
            backgroundImage:
              "radial-gradient(circle at 1px 1px, currentColor 1px, transparent 0)",
            backgroundSize: "28px 28px",
          }}
        />
        <div className="relative max-w-6xl mx-auto px-6 pt-20 pb-28">
          <p className="text-sm tracking-[0.25em] uppercase opacity-60 mb-6">
            For Christians, seeking marriage
          </p>
          <h1 className="font-display text-6xl md:text-7xl leading-[1.05] max-w-3xl">
            Marriage, sought<br />with intention.
          </h1>
          <p className="text-lg md:text-xl opacity-75 max-w-xl mt-8 leading-relaxed">
            Not swiped past. A modern space to search for a spouse with denomination-aware
            matching, real family involvement, and none of the noise.
          </p>
          <div className="flex flex-wrap gap-4 mt-10">
            <Link href="/signup">
              <Button size="lg" variant="secondary" className="rounded-full px-8">
                Create your account
              </Button>
            </Link>
            <Link href="/login">
              <Button
                size="lg"
                variant="outline"
                className="rounded-full px-8 border-primary-foreground/25 text-primary-foreground hover:bg-primary-foreground/10 bg-transparent"
              >
                Log in
              </Button>
            </Link>
          </div>
        </div>
      </section>

      {/* Positioning */}
      <section className="max-w-6xl mx-auto px-6 py-28">
        <div className="max-w-2xl">
          <Eyebrow>The difference</Eyebrow>
          <h2 className="font-display text-4xl mt-4 leading-tight">
            Not another dating app.<br />Not another old form to fill out.
          </h2>
        </div>

        <div className="grid md:grid-cols-2 gap-16 mt-16">
          <div className="border-l-2 border-border pl-6">
            <p className="font-display text-2xl mb-3">Mainstream apps</p>
            <p className="text-muted-foreground leading-relaxed">
              Built to keep you swiping, not to help you stop. Volume over intention, and
              nothing built for faith or family.
            </p>
          </div>
          <div className="border-l-2 border-primary pl-6">
            <p className="font-display text-2xl mb-3">Christimony</p>
            <p className="text-muted-foreground leading-relaxed">
              One goal: a real search for a spouse, shaped by your faith, and guided by family
              if you want it to be — with a modern experience the legacy sites never had.
            </p>
          </div>
        </div>
      </section>

      {/* Pull quote */}
      <section className="border-y border-border bg-secondary/30">
        <div className="max-w-4xl mx-auto px-6 py-24 text-center">
          <p className="font-display text-3xl md:text-4xl leading-snug italic">
            "Built for every tradition — Catholic, Orthodox, Pentecostal, Baptist, and beyond —
            so you meet people who share what matters most to you."
          </p>
        </div>
      </section>

      {/* How it works */}
      <section className="max-w-6xl mx-auto px-6 py-28">
        <Eyebrow>How it works</Eyebrow>
        <h2 className="font-display text-4xl mt-4 mb-16">Three steps, at your pace.</h2>

        <div className="grid md:grid-cols-3 gap-x-10 gap-y-14">
          {[
            {
              step: "01",
              title: "Create a profile",
              body: "For yourself, or — if you're a parent — on behalf of your child, with your own account guiding the process.",
            },
            {
              step: "02",
              title: "Browse with intention",
              body: "Filter by city and denomination. No endless feed, no games — just people seeking the same thing you are.",
            },
            {
              step: "03",
              title: "Connect, at the right pace",
              body: "Send interest, match, and message — built around consent at every step, for everyone involved.",
            },
          ].map((item) => (
            <div key={item.step}>
              <span className="font-display text-5xl text-primary/25">{item.step}</span>
              <h3 className="font-display text-xl mt-4 mb-3">{item.title}</h3>
              <p className="text-muted-foreground leading-relaxed">{item.body}</p>
            </div>
          ))}
        </div>
      </section>

      {/* Parent/ward feature */}
      <section className="max-w-6xl mx-auto px-6 pb-28">
        <div className="rounded-[2rem] bg-accent text-accent-foreground p-12 md:p-16 relative overflow-hidden">
          <div
            className="absolute inset-0 opacity-[0.08]"
            style={{
              backgroundImage:
                "radial-gradient(circle at 1px 1px, currentColor 1px, transparent 0)",
              backgroundSize: "24px 24px",
            }}
          />
          <div className="relative grid md:grid-cols-5 gap-10 items-center">
            <div className="md:col-span-2">
              <p className="text-sm tracking-[0.2em] uppercase opacity-70 mb-3">
                Our signature feature
              </p>
              <h2 className="font-display text-3xl md:text-4xl leading-tight">
                Family involvement,<br />without losing your voice.
              </h2>
            </div>
            <div className="md:col-span-3">
              <p className="opacity-90 leading-relaxed text-lg">
                Parents can create and guide a profile for their child — but a real connection
                between two families never opens a conversation automatically. Each person gets
                their own say before anything moves forward.
              </p>
              <p className="font-display text-xl mt-6">Family-guided. Never family-decided.</p>
            </div>
          </div>
        </div>
      </section>

      {/* Final CTA */}
      <section className="max-w-6xl mx-auto px-6 pb-32 text-center">
        <h2 className="font-display text-4xl md:text-5xl leading-tight">
          Your search starts here.
        </h2>
        <div className="mt-10">
          <Link href="/signup">
            <Button size="lg" className="rounded-full px-10">Create your account</Button>
          </Link>
        </div>
      </section>

      <footer className="border-t border-border">
        <div className="max-w-6xl mx-auto px-6 py-10 flex flex-col sm:flex-row gap-4 items-center justify-between text-sm text-muted-foreground">
          <span className="font-display text-base text-primary">Christimony</span>
          <span>© {new Date().getFullYear()} Christimony. Built for Christians, by faith.</span>
          <div className="flex gap-4">
            <Link href="/login" className="hover:text-foreground">Log in</Link>
            <Link href="/signup" className="hover:text-foreground">Sign up</Link>
          </div>
        </div>
      </footer>
    </div>
  );
}
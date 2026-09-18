import { LenisProvider } from "@/components/marketing/lenis-provider";
import { Preloader } from "@/components/marketing/preloader";
import { SiteHeader } from "@/components/marketing/site-header";
import { SiteFooter } from "@/components/marketing/site-footer";
import { Marquee } from "@/components/marketing/marquee";
import { HeroSection } from "@/components/marketing/sections/hero-section";
import { PositioningSection } from "@/components/marketing/sections/positioning-section";
import { QuoteSection } from "@/components/marketing/sections/quote-section";
import { HowItWorksSection } from "@/components/marketing/sections/how-it-works-section";
import { FamilySection } from "@/components/marketing/sections/family-section";
import { FaqSection } from "@/components/marketing/sections/faq-section";
import { FinalCtaSection } from "@/components/marketing/sections/final-cta-section";

export default function Home() {
  return (
    <LenisProvider>
      <div data-testid="christimony-landing-page" className="landing overflow-hidden">
        <Preloader />
        <SiteHeader />

        <main>
          <HeroSection />
          <Marquee />
          <PositioningSection />
          <QuoteSection />
          <HowItWorksSection />
          <FamilySection />
          <FaqSection />
          <FinalCtaSection />
        </main>

        <SiteFooter />
      </div>
    </LenisProvider>
  );
}

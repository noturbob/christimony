import type { Metadata, Viewport } from "next";
import { Bricolage_Grotesque, Fraunces } from "next/font/google";
import "./globals.css";
import { AuthProvider } from "@/lib/auth-context";

// Bricolage carries everything; Fraunces italic is only for emphasis
// (`.serif-italic`).
const grotesk = Bricolage_Grotesque({ subsets: ["latin"], variable: "--font-grotesk", axes: ["opsz"] });
const frauncesItalic = Fraunces({ subsets: ["latin"], variable: "--font-fraunces-italic", style: "italic", weight: "400" });

export const metadata: Metadata = {
  title: "Christimony",
  description: "A modern matrimony platform for Christians",
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1,
  viewportFit: "cover",
  themeColor: "#0f1311",
};

// Deliberately reads no request-time API (no cookies/headers) so the
// marketing landing page nested under this layout stays a static
// prerender. Auth is hydrated lower down, in (main)/layout.tsx, which is
// the only part of the tree that actually requires a session.
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en" className={`${grotesk.variable} ${frauncesItalic.variable}`} data-scroll-behavior="smooth">
      <body>
        <AuthProvider>{children}</AuthProvider>
      </body>
    </html>
  );
}

import type { Metadata } from "next";
import type { ReactNode } from "react";
import "./globals.css";

export const metadata: Metadata = {
  title: "AutoPost — Facebook · YouTube · TikTok",
  description:
    "Jadwalkan dan posting otomatis iklan, foto & video ke Facebook, YouTube, dan TikTok dari satu dashboard.",
};

export default function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang="id">
      <body className="bg-slate-950 text-slate-100 antialiased">{children}</body>
    </html>
  );
}

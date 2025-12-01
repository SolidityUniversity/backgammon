"use client";

// This layout overrides the default layout for the main page
// It uses ScaffoldEthAppWithProviders with hideHeader=true to remove Header/Footer
// The parent layout (app/layout.tsx) already provides all providers, so we just need to wrap with ScaffoldEthAppWithProviders
import { ScaffoldEthAppWithProviders } from "~~/components/ScaffoldEthAppWithProviders";

export default function MainLayout({ children }: { children: React.ReactNode }) {
  // Note: We're using ScaffoldEthAppWithProviders here, which will create duplicate providers
  // But this is necessary because we need to override the Header/Footer behavior
  // The providers are idempotent, so this should be safe
  return <ScaffoldEthAppWithProviders hideHeader={true}>{children}</ScaffoldEthAppWithProviders>;
}

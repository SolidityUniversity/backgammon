"use client";

import { usePathname } from "next/navigation";
import { ScaffoldEthAppWithProviders } from "~~/components/ScaffoldEthAppWithProviders";

export const ConditionalLayout = ({ children }: { children: React.ReactNode }) => {
  const pathname = usePathname();
  // Hide header/footer on main page (/) but show on all other pages
  const isMainPage = pathname === "/";

  return <ScaffoldEthAppWithProviders hideHeader={isMainPage}>{children}</ScaffoldEthAppWithProviders>;
};

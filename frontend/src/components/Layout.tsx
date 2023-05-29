import React, { type ReactNode } from "react";
import Header from "./Header";

export const Layout = ({ children }: { children: ReactNode }) => {
  return (
    <div className="min-h-full flex-col">
      <Header />
      <main className="mx-auto mt-20 flex w-screen max-w-7xl items-center justify-center px-4 sm:px-6 lg:px-8">
        <div className="mx-auto max-w-4xl">{children}</div>
      </main>
    </div>
  );
};

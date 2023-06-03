import { AragonProvider } from "@daobox/use-aragon";
import { RainbowKitProvider, darkTheme } from "@rainbow-me/rainbowkit";
import { Toaster } from "react-hot-toast";

import { type AppType } from "next/dist/shared/lib/utils";
import React from "react";
import { WagmiConfig } from "wagmi";
import { wagmiClient, chains } from "~/config-wagmi";
import { Layout } from "../components/Layout";

import "~/styles/globals.css";
import { TokenTransactionProvider } from "~/contexts/TransactionContext";

const MyApp: AppType = ({ Component, pageProps }) => {
  const [mounted, setMounted] = React.useState(false);

  React.useEffect(() => {
    setMounted(true);
  }, []);

  return (
    <WagmiConfig client={wagmiClient}>
      <RainbowKitProvider
        coolMode
        showRecentTransactions={true}
        chains={chains}
        theme={darkTheme()}
      >
        <AragonProvider>
          {mounted && (
            <Layout>
              <TokenTransactionProvider>
                <Component {...pageProps} />
                <Toaster position="top-left" />
              </TokenTransactionProvider>
            </Layout>
          )}
        </AragonProvider>
      </RainbowKitProvider>
    </WagmiConfig>
  );
};

export default MyApp;

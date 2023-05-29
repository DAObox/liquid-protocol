// transactionContext.tsx
import {
  createContext,
  ReactNode,
  useContext,
  useReducer,
  useState,
} from "react";

import {
  useDaoBoxTokenGetContinuousMintReward as useMintReward,
  useDaoBoxTokenGetContinuousBurnRefund as useBurnReward,
  useDaoBoxTokenMint as useMintBox,
  useDaoBoxTokenBurn as useBurnBox,
  usePrepareDaoBoxTokenMint as usePrepareMint,
  usePrepareDaoBoxTokenBurn as usePrepareBurn,
  useDaoBoxTokenBalanceOf as useBOXBalance,
} from "../hooks/wagmi/generated";

import maticLogo from "../public/matic.svg";
import daoboxLogo from "../public/logo_color.png";
import { useAddRecentTransaction } from "@rainbow-me/rainbowkit";

import React from "react";
import { TokenTransactionContextValue, TokenType } from "../Types";
import { useAccount, useBalance } from "wagmi";

export const boxToken: TokenType = {
  logo: daoboxLogo,
  alt: "daobox logo",
  name: "BOX",
};

export const maticToken: TokenType = {
  logo: maticLogo,
  alt: "matic logo",
  name: "MATIC",
};

const TokenTransactionContext =
  createContext<TokenTransactionContextValue | null>(null);

export const useTokenTransaction = () => {
  const context = useContext(TokenTransactionContext);

  if (!context) {
    throw new Error(
      "useTokenTransaction must be used within a TokenTransactionProvider"
    );
  }

  return context;
};

const tokenReducer = (state: { buyToken: TokenType; sellToken: TokenType }) => {
  return {
    ...state,
    buyToken: state.sellToken,
    sellToken: state.buyToken,
  };
};

interface TransactionsProps {
  children: ReactNode;
}

export const TokenTransactionProvider = ({ children }: TransactionsProps) => {
  const [tokens, switchTokens] = useReducer(tokenReducer, {
    sellToken: maticToken,
    buyToken: boxToken,
  });
  const { address } = useAccount();
  const {
    data: ethBalance,
    isLoading: isEthBalanceLoading,
    isError: isEthBalanceError,
  } = useBalance({
    address,
    watch: true,
  });

  const {
    data: boxBalance,
    isLoading: isBoxBalanceLoading,
    isError: isBoxBalanceError,
  } = useBOXBalance({
    args: [address!],
    watch: true,
    enabled: !!address,
  });

  const [sellAmount, setSellAmount] = useState(0n);
  const { data: boxRecieved } = useMintReward({ args: [sellAmount] });
  const { data: ethRecieved } = useBurnReward({ args: [sellAmount] });

  const tokensReceivable =
    tokens.buyToken === boxToken ? boxRecieved : ethRecieved;

  const { buyBox, isMintLoading } = useMint({ sellAmount, tokensReceivable });
  const { sellBox, isBurnLoading } = useBurn({ sellAmount, tokensReceivable });

  const handleExchange = () => {
    console.log("handleExchange");
    tokens.buyToken === boxToken ? buyBox?.() : sellBox?.();
  };

  const disableSwap = () => {
    return (
      sellAmount === 0n ||
      (tokens.buyToken === boxToken && !buyBox) ||
      (tokens.buyToken === maticToken && !sellBox) ||
      isMintLoading ||
      isBurnLoading
    );
  };

  const isLoading = isMintLoading || isBurnLoading;

  const getUserBalances = () => {
    const BOX = isBoxBalanceLoading
      ? "Loading..."
      : isBoxBalanceError
      ? "ERROR!"
      : parseFloat(formatUnits(boxBalance ?? 0n, 18)).toFixed(2);
    const ETH = isEthBalanceLoading
      ? "Loading..."
      : isEthBalanceError
      ? "ERROR!"
      : parseFloat(ethBalance?.formatted ?? "0").toFixed(2);

    return tokens.buyToken === boxToken
      ? { buyTokenBalance: BOX, saleTokenBalance: ETH }
      : { buyTokenBalance: ETH, saleTokenBalance: BOX };
  };

  const value = {
    tokens,
    switchTokens,
    sellAmount,
    setSellAmount,
    tokensReceivable,
    handleExchange,
    isLoading,
    disableSwap,
    ...getUserBalances(),
  };

  return (
    <TokenTransactionContext.Provider value={value}>
      {children}
    </TokenTransactionContext.Provider>
  );
};

const useMint = ({
  sellAmount,
  tokensReceivable,
}: Pick<TokenTransactionContextValue, "sellAmount" | "tokensReceivable">) => {
  const addRecentTransaction = useAddRecentTransaction();

  const { config: mintConfig } = usePrepareMint({
    value: sellAmount,
    enabled: sellAmount > 0n,
  });
  const { write: buyBox, isLoading: isMintLoading } = useMintBox({
    ...mintConfig,
    onSuccess: (tx) => {
      addRecentTransaction({
        hash: tx.hash,
        description: `Minted ${parseFloat(
          formatEther(tokensReceivable ?? 0n)
        ).toFixed(2)} BOX`,
      });
    },
  });

  return { buyBox, isMintLoading };
};

function useBurn({
  sellAmount,
  tokensReceivable,
}: {
  sellAmount: bigint;
  tokensReceivable: bigint | undefined;
}) {
  const addRecentTransaction = useAddRecentTransaction();

  const { config: burnConfig } = usePrepareBurn({
    args: [sellAmount],
    enabled: sellAmount > 0n,
  });

  const { write: sellBox, isLoading: isBurnLoading } = useBurnBox({
    ...burnConfig,
    onSuccess: (tx) => {
      addRecentTransaction({
        hash: tx.hash,
        description: `Burned ${parseFloat(
          formatEther(tokensReceivable ?? 0n)
        ).toFixed(2)} BOX`,
      });
    },
  });
  return { sellBox, isBurnLoading };
}

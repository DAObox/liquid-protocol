// transactionContext.tsx
import { createContext, type ReactNode, useContext, useReducer, useState } from "react";

import React from "react";
import { useAccount } from "wagmi";
import { type TokenType } from "~/types";
import {
  useBalanceBOX,
  useBalanceUSDC,
  useBurnBox,
  useBurnReward,
  useMintBox,
  useMintReward,
} from "~/hooks";
import { formatUnits } from "ethers/lib/utils.js";
import { BN, boxToken, usdcToken } from "~/lib";
import { type BigNumber } from "ethers";

type TokenTransactionContextType = {
  tokens: {
    sellToken: TokenType;
    buyToken: TokenType;
  };
  switchTokens: () => void;
  sellAmount: BigNumber;
  setSellAmount: (amount: BigNumber) => void;
  tokensReceivable: BigNumber | undefined;
  handleExchange: () => void;
  isLoading: boolean;
  disableSwap: () => boolean;
  buyTokenBalance: string;
  saleTokenBalance: string;
};

const TokenTransactionContext = createContext<TokenTransactionContextType | null>(null);

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
  /// Tokens
  const [tokens, switchTokens] = useReducer(tokenReducer, {
    sellToken: usdcToken,
    buyToken: boxToken,
  });

  /// Token Amounts
  const [sellAmount, setSellAmount] = useState(BN(0));
  const { mintReward: boxReceived } = useMintReward({ sellAmount });
  const { burnReward: usdcReceived } = useBurnReward({ sellAmount });
  const tokensReceivable = tokens.buyToken === boxToken ? boxReceived : usdcReceived;

  /// User
  const { address } = useAccount();
  const { usdcBalance, usdBalanceStatus } = useBalanceUSDC({ address });
  const { boxBalance, boxBalanceStatus } = useBalanceBOX({ address });

  /// Mutations
  const { mintBox, isMintLoading } = useMintBox(sellAmount);
  const { burnBox, isBurnLoading } = useBurnBox(sellAmount);
  const isLoading = isMintLoading || isBurnLoading;

  const handleExchange = () => {
    console.log("handleExchange");
    tokens.buyToken === boxToken ? mintBox?.() : burnBox?.();
  };

  const disableSwap = () => {
    return (
      sellAmount === BN(0) ||
      (tokens.buyToken === boxToken && !mintBox) ||
      (tokens.buyToken === usdcToken && !burnBox) ||
      isMintLoading ||
      isBurnLoading
    );
  };

  const getUserBalances = () => {
    const BOX =
      boxBalanceStatus === "loading"
        ? "Loading..."
        : boxBalanceStatus === "error"
        ? "ERROR!"
        : parseFloat(formatUnits(boxBalance ?? 0n, 18)).toFixed(2);
    const USDC =
      usdBalanceStatus === "loading"
        ? "Loading..."
        : usdBalanceStatus === "error"
        ? "ERROR!"
        : parseFloat(formatUnits(usdcBalance ?? "0")).toFixed(2);

    return tokens.buyToken === boxToken
      ? { buyTokenBalance: BOX, saleTokenBalance: USDC }
      : { buyTokenBalance: USDC, saleTokenBalance: BOX };
  };

  console.log({
    tokens,
    sellAmount: sellAmount.toString(),
    tokensReceivable,
    ...getUserBalances(),
  });

  const value: TokenTransactionContextType = {
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
    <TokenTransactionContext.Provider value={value}>{children}</TokenTransactionContext.Provider>
  );
};

export const useMarketMaker = () => {
  const context = useContext(TokenTransactionContext);
  if (!context) {
    throw new Error("useTokenTransaction must be used within a TokenTransactionProvider");
  }

  return context;
};

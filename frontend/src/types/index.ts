import { type StaticImageData } from "next/image";
import { type Dispatch, type SetStateAction } from "react";

export interface TokenType {
  logo: StaticImageData;
  alt: string;
  name: string;
}

export interface TokenTransactionContextValue {
  tokens: {
    sellToken: TokenType;
    buyToken: TokenType;
  };
  switchTokens: () => void;
  sellAmount: bigint;
  saleTokenBalance: string;
  buyTokenBalance: string;
  setSellAmount: Dispatch<SetStateAction<bigint>> | undefined;
  tokensReceivable: bigint | undefined;
  handleExchange: () => void;
  disableSwap: () => boolean;
  isLoading: boolean;
}

export type Address = `0x${string}`;

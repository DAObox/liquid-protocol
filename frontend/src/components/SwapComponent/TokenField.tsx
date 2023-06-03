import React from "react";

import { TokenSelector } from "./TokenSelector";
import { type TokenType } from "src/types";
import { TokenInput } from "../atoms/TokenInput";
import { BigNumberish, type BigNumber } from "ethers/lib/ethers";
import TextButton from "../atoms/TextButton";
import { useMarketMaker } from "~/contexts/TransactionContext";
import { tokenFormatter } from "~/lib";

interface TokenFieldProps {
  token: TokenType;
  amount: BigNumber;
  setAmount: (token: BigNumber) => void;
  max?: boolean;
  balance: BigNumberish;
}

export function TokenField({ token, amount, setAmount, max, balance }: TokenFieldProps) {
  // const {} = useMarketMaker();
  return (
    <div className="my-2 flex h-28 flex-col justify-between rounded-2xl border border-[#20242A] bg-[#20242A]  px-6 text-3xl hover:border-[#41444F]">
      <div className="flex justify-between pt-6">
        <TokenInput amount={amount} setAmount={setAmount} />
        <TokenSelector {...token} />
      </div>
      <div className="flex items-end justify-between pb-3 align-bottom">
        {max && (
          <div className="flex w-full justify-end space-x-2 text-sm">
            <div>Balance: {balance?.toString() ?? 0}</div>
            <TextButton>MAX</TextButton>
          </div>
        )}
      </div>
    </div>
  );
}

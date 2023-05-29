import React from "react";
import TextButton from "~/components/atoms/TextButton";
import daoboxLogo from "~/public/logo_color.png";
import { TokenSelector } from "./TokenSelector";
import { TokenType } from "~/types";
import { ClassValue } from "clsx";
import { TokenInput } from "../atoms/TokenInput";
import { BigNumber } from "ethers/lib/ethers";

export function TokenField({
  token,
  onChange,
  max,
}: {
  token: TokenType;
  onChange: (token: BigNumber) => void;
  max?: boolean;
}) {
  return (
    <div
      className={`my-2 flex h-28 flex-col justify-between rounded-2xl border border-[#20242A] bg-[#20242A]  px-6 text-3xl hover:border-[#41444F]`}
    >
      <div className="flex justify-between pt-6">
        <TokenInput
          token={token}
          onWeiChange={(weiValue) => {
            onChange(weiValue);
          }}
        />
        <TokenSelector {...token} />
      </div>
      <div className="flex items-end justify-between pb-3 align-bottom">
        {max && (
          <div className="flex w-full justify-end space-x-2 text-sm">
            <div>Balance: </div>
            <TextButton>MAX</TextButton>
          </div>
        )}
      </div>
    </div>
  );
}

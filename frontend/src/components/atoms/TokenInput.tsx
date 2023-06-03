import React, { useState } from "react";
import { type TokenType } from "~/types";
import { ethers, type BigNumber } from "ethers";
import clsx from "clsx";
import { twMerge } from "tailwind-merge";
import { BN, tokenFormatter } from "~/lib";

interface TokenInputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  className?: string;
  amount: BigNumber; // the amount set
  setAmount: (value: BigNumber) => void;
}

export function TokenInput({ amount, className, setAmount, ...restProps }: TokenInputProps) {
  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    console.log(event);

    const inputValue = event.target.value;
    if (inputValue === "" || parseFloat(inputValue) < 0) {
      setAmount(BN(0));
      return;
    }
    setAmount(BN(ethers.utils.parseEther(inputValue)));
  };

  return (
    <input
      type="text"
      className={clsx(
        twMerge(
          "mb-6 w-full bg-transparent text-2xl outline-none placeholder:text-[#B2B9D2]",
          className
        )
      )}
      value={tokenFormatter(amount ?? 0)}
      onChange={handleChange}
      {...restProps}
    />
  );
}

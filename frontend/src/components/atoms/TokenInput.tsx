import React, { useState } from "react";
import { type TokenType } from "~/types";
import { ethers } from "ethers";
import clsx from "clsx";
import { twMerge } from "tailwind-merge";
import { z } from "zod";

export function TokenInput({
  token,
  onWeiChange,
  className,
  ...restProps
}: TokenInputProps) {
  const [value, setValue] = useState("");
  const [isValid, setIsValid] = useState(true);

  const numberSchema = z.string().regex(/^[0-9]*[.,]?[0-9]*$/);

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = event.target.value;

    // Check if the last character is a digit, dot or comma. If not, remove it.
    const lastChar = newValue[newValue.length - 1];
    if (!lastChar?.match(/[0-9.]/)) {
      setValue(value); // Keep the previous value
      return;
    }

    setValue(newValue);

    if (numberSchema.safeParse(newValue).success) {
      setIsValid(true);

      // If the input is valid and not empty, convert the value to wei and pass it to the parent component
      if (newValue !== "") {
        const weiValue = ethers.utils.parseEther(newValue);
        onWeiChange(weiValue);
      }
    } else {
      setIsValid(false);
    }
  };

  return (
    <input
      type="text"
      className={clsx(
        twMerge(
          "mb-6 w-full bg-transparent text-2xl outline-none placeholder:text-[#B2B9D2]",
          className
        ),
        {
          "input-invalid": !isValid,
        }
      )}
      value={value}
      onChange={handleChange}
      {...restProps}
    />
  );
}
interface TokenInputProps extends React.InputHTMLAttributes<HTMLInputElement> {
  token: TokenType;
  onWeiChange: (weiValue: ethers.BigNumber) => void;
}

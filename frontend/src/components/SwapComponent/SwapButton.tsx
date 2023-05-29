"use client";
import React, { ButtonHTMLAttributes } from "react";
import clsx, { ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

interface SwapButtonProps extends React.HTMLAttributes<HTMLButtonElement> {
  disabled?: boolean;
  loading?: boolean;
  buttonProps?: ButtonHTMLAttributes<HTMLButtonElement>;
}

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(...inputs));
}

const SwapButton: React.FC<SwapButtonProps> = ({
  disabled,
  loading,
  buttonProps,
  onClick,
  className,
}) => {
  const handleClick = (e: React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
    console.log("in handleClick");
    if (onClick) onClick(e);
    if (buttonProps?.onClick) buttonProps.onClick(e);
  };

  return (
    <button
      className={cn(
        "bg-[#2172E5] my-2 w-full rounded-2xl py-6 px-8 text-xl font-semibold flex items-center justify-center cursor-pointer border border-[#2172E5]",
        { "border-[#234169]": disabled },
        { "cursor-not-allowed opacity-50": loading || disabled },
        className
      )}
      disabled={disabled || loading}
      onClick={handleClick}
      {...buttonProps}
    >
      {loading ? "Loading..." : "Swap"}
    </button>
  );
};

export default SwapButton;

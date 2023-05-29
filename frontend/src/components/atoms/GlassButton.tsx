import clsx from "clsx";
import React, { type ButtonHTMLAttributes } from "react";

type ButtonProps = ButtonHTMLAttributes<HTMLButtonElement> & {
  label: string;
  className?: string;
};
export const GlassButton = ({ label, className, ...props }: ButtonProps) => {
  return (
    <button className={clsx("glass btn w-full", className)} {...props}>
      {label}
    </button>
  );
};

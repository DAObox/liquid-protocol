import React from "react";
import clsx, { type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";
import { type AnimationProps, motion, type HTMLMotionProps } from "framer-motion";

interface TextButtonProps extends HTMLMotionProps<"button"> {
  customStyle?: ClassValue;
  whileTap?: AnimationProps;
  whileHover?: AnimationProps;
}

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(...inputs));
}

const TextButton: React.FC<TextButtonProps> = ({ customStyle, whileTap, ...buttonProps }) => {
  return (
    <motion.button
      className={cn(
        "text-blue-500 transition-colors duration-200 hover:text-blue-700",
        customStyle
      )}
      whileTap={whileTap ?? { scale: 0.95 }}
      {...buttonProps}
    >
      {buttonProps.children}
    </motion.button>
  );
};

export default TextButton;

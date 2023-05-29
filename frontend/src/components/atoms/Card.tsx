import React from "react";
import { motion } from "framer-motion";
import Link from "next/link";
import clsx, { type ClassValue } from "clsx";
import { twMerge } from "tailwind-merge";

interface DivCardProps extends React.HTMLAttributes<HTMLDivElement> {
  className?: string;
  children?: React.ReactNode;
  bordered?: boolean;
  hoverable?: boolean;
  clickable?: boolean;
  disabled?: boolean;
  href?: string;
}

type CardProps = DivCardProps;

function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(...inputs));
}

const Card: React.FC<CardProps> = ({
  className,
  children,
  bordered,
  hoverable,
  clickable,
  href,
  disabled,
  ...rest
}) => {
  const cardStyles = cn(
    "w-[35rem] rounded-2xl bg-[#191B1F] p-4",
    bordered && "ring-1 ring-[#33363f]",
    hoverable && !disabled && "hover:shadow-lg transition-shadow duration-200",
    clickable && !disabled && "cursor-pointer",
    disabled && "opacity-50 cursor-not-allowed",
    className
  );

  const motionProps = {
    whileHover: hoverable && !disabled ? { scale: 1.03 } : {},
    whileTap: clickable && !disabled ? { scale: 0.97 } : {},
  };

  if (href && !disabled) {
    return (
      <Link href={href}>
        <motion.div
          className={cardStyles}
          {...motionProps}
          {...(rest as React.HTMLAttributes<HTMLDivElement>)}
        >
          {children}
        </motion.div>
      </Link>
    );
  } else {
    return (
      <motion.div
        className={cardStyles}
        {...motionProps}
        {...(rest as React.HTMLAttributes<HTMLDivElement>)}
      >
        {children}
      </motion.div>
    );
  }
};

export default Card;

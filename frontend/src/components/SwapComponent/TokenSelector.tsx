import React from "react";
import { type TokenType } from "~/types";
import Image from "next/image";

export const TokenSelector = ({ logo, alt, name }: TokenType) => {
  return (
    <div className="mx-4 mt-[0.2rem] flex">
      <button className="btn-sm btn flex h-min cursor-pointer items-center justify-between rounded-full">
        <Image src={logo} alt={alt} height={20} width={20} />
        <div className="mx-2 flex flex-grow truncate  text-lg font-medium ">{name}</div>
      </button>
    </div>
  );
};

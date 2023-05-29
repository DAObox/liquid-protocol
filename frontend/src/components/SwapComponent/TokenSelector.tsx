import React from "react";
import { TokenType } from "~/types";
import { AiOutlineDown } from "react-icons/ai";
import Image from "next/image";

export const TokenSelector = ({ logo, alt, name }: TokenType) => {
  // console.log({ logo, alt, name });
  return (
    <div className="mx-4 mt-[0.2rem] flex">
      <button className="btn-sm btn flex h-min cursor-pointer items-center justify-between rounded-full">
        <Image src={logo} alt={alt} height={20} width={20} />
        <div className="mx-2 flex flex-grow truncate  text-lg font-medium ">
          {name}
        </div>
        {/* <AiOutlineDown className="text-lg" /> */}
      </button>
    </div>
  );
};

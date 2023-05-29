import Image, { type StaticImageData } from "next/image";
import { RiSettings3Fill } from "react-icons/ri";
import { AiOutlineDown } from "react-icons/ai";
import { MdSwapVert } from "react-icons/md";
import { TokenTransactionProvider, useTokenTransaction } from "../contexts/TransactionContext";
import { type Dispatch, type SetStateAction } from "react";

import SwapButton from "./SwapComponent/SwapButton";
import TextButton from "./atoms/TextButton";
import { parseEther, parseUnits } from "ethers/lib/utils.js";

interface TokenFieldProps extends TokenType {
  userBalance?: string;
  setSell?: Dispatch<SetStateAction<bigint>> | undefined;
  amount?: bigint | undefined;
}

interface TokenType {
  logo: StaticImageData;
  alt: string;
  name: string;
}

const Main = () => {
  const {
    tokens,
    switchTokens,
    setSellAmount,
    tokensReceivable,
    handleExchange,
    disableSwap,
    buyTokenBalance,
    saleTokenBalance,
    isLoading,
  } = useTokenTransaction();

  return (
    <div className="mt-14 flex w-screen items-center justify-center">
      <div className="w-[40rem] rounded-2xl bg-[#191B1F] p-4 ring-1 ring-[#33363f]">
        <div className="flex items-center justify-between px-2 text-xl font-semibold">
          <div>Swap</div>
          <div>
            <RiSettings3Fill />
          </div>
        </div>
        <div className="relative">
          <TokenField
            logo={tokens.sellToken.logo}
            alt={tokens.sellToken.alt}
            name={tokens.sellToken.name}
            setSell={setSellAmount}
            userBalance={saleTokenBalance}
          />
          <TokenField
            logo={tokens.buyToken.logo}
            alt={tokens.buyToken.alt}
            name={tokens.buyToken.name}
            amount={tokensReceivable ?? 0n}
            userBalance={buyTokenBalance}
          />
          <button
            onClick={() => switchTokens()}
            className="absolute left-1/2 top-1/2 flex h-10 w-10 -translate-x-1/2 -translate-y-1/2 transform items-center justify-center rounded-xl border-2 border-[#191B1F] bg-blue-500 p-2 ring-4 ring-[#191B1F]"
          >
            <MdSwapVert className="text-3xl" />
          </button>
        </div>

        <SwapButton onClick={() => handleExchange()} disabled={disableSwap()} loading={isLoading} />
      </div>
    </div>
  );
};

export default () => (
  <TokenTransactionProvider>
    <Main />
  </TokenTransactionProvider>
);

const TokenField = ({ setSell, amount, userBalance, ...token }: TokenFieldProps) => {
  return (
    <div
      className={`my-2 flex flex-col justify-between rounded-2xl  border border-[#20242A] bg-[#20242A]  px-6 text-3xl hover:border-[#41444F]`}
    >
      <div className="flex justify-between pt-6">
        <input
          type="text"
          className={`mb-6 w-full bg-transparent text-2xl outline-none placeholder:text-[#B2B9D2]`}
          placeholder={setSell?.toString() ? "0.0" : parseUnits(amount?.toString(), 18) ?? "0.0"}
          pattern="^[0-9]*[.,]?[0-9]*$"
          onChange={(e) => setSell?.(parseEther(e.target.value))}
        />
        <TokenSelector {...token} />
      </div>
      <div className="flex items-end justify-between pb-2 align-bottom">
        <div className="text-sm"></div>
        <div className="flex  space-x-2 text-sm">
          <div>Balance: {userBalance}</div>
          {setSell && <TextButton>MAX</TextButton>}
        </div>
      </div>
    </div>
  );
};

const TokenSelector = ({ logo, alt, name }: TokenType) => {
  return (
    <div className="flex w-1/4">
      <div
        className={`mt-[-0.2rem] flex h-min w-full cursor-pointer items-center justify-between rounded-3xl bg-[#2D2F36] p-2 text-xl font-medium hover:bg-[#41444F]`}
      >
        <div className="items-center` flex">
          <img src={logo.src} alt={alt} height={20} width={20} />
        </div>
        <div className="mx-2 flex">{name}</div>
        {/* <AiOutlineDown className="text-lg" /> */}
      </div>
    </div>
  );
};

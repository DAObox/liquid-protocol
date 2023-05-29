import { useContractRead } from "wagmi";
import { marketMakerABI } from "~/hooks/wagmi/generated";
import { contracts } from "~/lib/constants";

export const useIsTradingOpen = () => {
  const { data: isTradingOpen } = useContractRead({
    abi: marketMakerABI,
    address: contracts.marketMaker,
    functionName: "isHatched",
  });
  return { isTradingOpen };
};

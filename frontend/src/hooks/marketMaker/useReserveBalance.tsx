import { useContractRead } from "wagmi";
import { marketMakerABI } from "src/hooks/wagmi/generated";
import { contracts } from "src/lib/constants";

export const useReserveBalance = () => {
  const { data: reserveBalance } = useContractRead({
    abi: marketMakerABI,
    address: contracts.marketMaker,
    functionName: "reserveBalance",
  });
  return { reserveBalance };
};

import { useContractRead } from "wagmi";
import { marketMakerABI } from "src/hooks/wagmi/generated";
import { contracts } from "src/lib/constants";

export const useMarketMakerParams = () => {
  const { data: curveParams } = useContractRead({
    abi: marketMakerABI,
    address: contracts.marketMaker,
    functionName: "getCurveParameters",
  });
  return { curveParams };
};

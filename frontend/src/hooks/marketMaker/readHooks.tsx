import { useContractRead } from "wagmi";
import { marketMakerABI } from "~/hooks/wagmi/generated";
import { contracts, BN } from "~/lib";
import { type BigNumberish } from "ethers";

export const useMintReward = ({ sellAmount }: { sellAmount: BigNumberish }) => {
  const { data: mintReward } = useContractRead({
    abi: marketMakerABI,
    address: contracts.marketMaker,
    functionName: "calculateMint",
    args: [BN(sellAmount)],
    enabled: !!(sellAmount && BN(sellAmount).gte(0)),
  });
  return { mintReward };
};

export const useBurnReward = ({ sellAmount }: { sellAmount: BigNumberish }) => {
  const { data: burnReward } = useContractRead({
    abi: marketMakerABI,
    address: contracts.marketMaker,
    functionName: "calculateBurn",
    args: [BN(sellAmount)],
    enabled: !!(sellAmount && BN(sellAmount).gte(0)),
  });
  return { burnReward };
};

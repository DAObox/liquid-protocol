import { governanceBurnableErc20ABI } from "~/hooks/wagmi/generated";
import { type Address, useContractRead } from "wagmi";
import { ZERO_ADDRESS, contracts } from "~/lib/constants";

const { boxToken } = contracts;

export const useBalanceBOX = ({ address }: { address: Address | undefined }) => {
  const { data: boxBalance, status: boxBalanceStatus } = useContractRead({
    abi: governanceBurnableErc20ABI,
    address: boxToken,
    functionName: "balanceOf",
    args: [address ?? ZERO_ADDRESS],
    enabled: !!(address && address !== ZERO_ADDRESS),
  });

  return { boxBalance, boxBalanceStatus };
};

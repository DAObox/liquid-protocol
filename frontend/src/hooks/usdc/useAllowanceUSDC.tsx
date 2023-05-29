import { type Address, useContractRead } from "wagmi";
import { mockUsdcABI } from "~/hooks/wagmi/generated";
import { ZERO_ADDRESS, contracts } from "~/lib/constants";

type UseAllowanceUSDCProps = {
  from?: Address | undefined | null;
  to?: Address | undefined | null;
};

export const useAllowanceUSDC = ({ from, to }: UseAllowanceUSDCProps) => {
  const { data: allowance } = useContractRead({
    abi: mockUsdcABI,
    address: contracts.MockUSDC,
    functionName: "allowance",
    args: [from ?? ZERO_ADDRESS, to ?? ZERO_ADDRESS],
    enabled: !!(from && to && from !== ZERO_ADDRESS && to !== ZERO_ADDRESS),
  });
  return { allowance };
};

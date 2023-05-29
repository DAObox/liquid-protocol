import { mockUsdcABI } from "~/hooks/wagmi/generated";
import { type Address, useContractRead } from "wagmi";
import { ZERO_ADDRESS, contracts } from "~/lib/constants";

const { MockUSDC } = contracts;

export const useBalanceUSDC = ({ address }: { address: Address | undefined }) => {
  const { data: usdcBalance } = useContractRead({
    abi: mockUsdcABI,
    address: MockUSDC,
    functionName: "balanceOf",
    args: [address ?? ZERO_ADDRESS],
    enabled: !!(address && address !== ZERO_ADDRESS),
  });

  return { usdcBalance };
};

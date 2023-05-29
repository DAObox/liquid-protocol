import { mockUsdcABI } from "~/hooks/wagmi/generated";
import { ethers } from "ethers";
import { useAccount, useContractWrite, usePrepareContractWrite, useTransaction } from "wagmi";
import { useAddRecentTransaction } from "@rainbow-me/rainbowkit";
import { LoadingToast, SuccessToast } from "~/components/atoms/Toast";
import { ZERO_ADDRESS, contracts } from "~/lib/constants";

const { MockUSDC } = contracts;

export const useMintUSDC = (amount: string) => {
  const { address } = useAccount();

  const addRecentTransaction = useAddRecentTransaction();
  const { config } = usePrepareContractWrite({
    abi: mockUsdcABI,
    address: MockUSDC,
    functionName: "mint",
    args: [address ?? ZERO_ADDRESS, ethers.utils.parseEther(amount)],
    enabled: !!(address && address !== ZERO_ADDRESS),
  });

  const {
    write: mint,
    status: transactionStatus,
    data: transaction,
  } = useContractWrite({
    ...config,
    onSuccess(data) {
      addRecentTransaction({
        hash: data.hash,
        description: `Minting ${amount} USDC`,
      });
      LoadingToast(`Minting ${amount} USDC`);
    },
  });

  const { status: minedStatus } = useTransaction({
    hash: transaction?.hash,
    enabled: !!transaction,
    onSuccess() {
      SuccessToast(`Minted ${amount} USDC`);
    },
  });

  const isMintLoading = transactionStatus === "loading" || minedStatus === "loading";

  return { mint, isMintLoading };
};

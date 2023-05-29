import { useAddRecentTransaction } from "@rainbow-me/rainbowkit";
import {
  useAccount,
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
} from "wagmi";
import { ErrorToast, LoadingToast, SuccessToast } from "~/components/atoms/Toast";
import { marketMakerABI } from "~/hooks/wagmi/generated";

import { contracts, ZERO_ADDRESS, parseEther } from "~/lib";

// TODO: Check if the current account has Permission to hatch
export function useOpenTrading(mintTokens: string, depositUsdc: string) {
  const addRecentTransaction = useAddRecentTransaction();

  const { address } = useAccount();

  const { config } = usePrepareContractWrite({
    abi: marketMakerABI,
    address: contracts.marketMaker,
    functionName: "hatch",
    args: [parseEther(mintTokens), parseEther(depositUsdc), address ?? ZERO_ADDRESS],
    enabled: !!(address && address !== ZERO_ADDRESS),
  });

  const {
    write: openTrading,
    status: transactionStatus,
    data,
  } = useContractWrite({
    ...config,
    onSuccess(data) {
      addRecentTransaction({
        hash: data?.hash,
        description: `Trading Opened`,
      });
      LoadingToast(`Opening Trading`);
      console.log(data);
    },
    onError(error) {
      ErrorToast(`Error Opening Trading`);
      console.log(error);
    },
  });

  const { status: minedStatus } = useWaitForTransaction({
    hash: data?.hash,
    onSuccess() {
      SuccessToast(`Trading Opened`);
      console.log("Confirmed");
    },
    onError(error) {
      ErrorToast(`Error Opening Trading`);
      console.error(error);
    },
  });

  const isOpenTradingLoading = transactionStatus === "loading" || minedStatus === "loading";

  return { openTrading, isOpenTradingLoading };
}

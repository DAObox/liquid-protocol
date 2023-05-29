import {
  useAccount,
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
} from "wagmi";
import { ErrorToast, LoadingToast, SuccessToast } from "~/components/atoms/Toast";
import { mockUsdcABI } from "~/hooks/wagmi/generated";
import { ZERO_ADDRESS } from "~/lib/constants";

import { contracts } from "~/lib/constants";
import { parseEther } from "~/lib/ethFormatter";
const { MockUSDC, marketMaker } = contracts;

export function useApproveUSDC(depositUsdc: string) {
  const { address } = useAccount();

  const { config } = usePrepareContractWrite({
    abi: mockUsdcABI,
    address: MockUSDC,
    functionName: "approve",
    args: [marketMaker, parseEther(depositUsdc)],
    enabled: !!(address && address !== ZERO_ADDRESS),
  });

  const {
    write: approve,
    status: approveTransaction,
    data: approveTx,
  } = useContractWrite({
    ...config,
    onSuccess(data) {
      console.log({ data, depositUsdc });
      LoadingToast(`Approving ${depositUsdc} USDC`);
      console.log(data);
    },
    onError(error) {
      ErrorToast(`Error Approving USDC`);
      console.log(error);
    },
  });

  const { status: approveMined } = useWaitForTransaction({
    hash: approveTx?.hash,
    onSuccess() {
      SuccessToast(`Approved ${depositUsdc} USDC`);
      console.log("Confirmed");
    },
  });

  const displayLoading = approveTransaction === "loading" || approveMined === "loading";

  return { approve, displayLoading };
}

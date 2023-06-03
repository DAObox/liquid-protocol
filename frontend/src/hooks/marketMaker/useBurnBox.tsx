import { useAddRecentTransaction } from "@rainbow-me/rainbowkit";
import { type BigNumberish } from "ethers";
import {
  useAccount,
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
} from "wagmi";
import { ErrorToast, LoadingToast, SuccessToast } from "~/components/atoms/Toast";
import { marketMakerABI } from "~/hooks/wagmi/generated";

import { contracts, ZERO_ADDRESS, BN } from "~/lib";

// TODO: Check if the current account has Permission to hatch
export function useBurnBox(depositBox: BigNumberish) {
  const addRecentTransaction = useAddRecentTransaction();

  const { address } = useAccount();

  const { config } = usePrepareContractWrite({
    abi: marketMakerABI,
    address: contracts.marketMaker,
    functionName: "burn",
    args: [BN(depositBox)],
    enabled: !!(address && address !== ZERO_ADDRESS && BN(depositBox).gte(0)),
  });

  const {
    write: burnBox,
    status: transactionStatus,
    data,
  } = useContractWrite({
    ...config,
    onSuccess(data) {
      addRecentTransaction({ hash: data?.hash, description: `Burning BOX` });
      LoadingToast(`Burning BOX`);
      console.log(data);
    },
    onError(error) {
      ErrorToast(`Error Burning BOX`);
      console.log(error);
    },
  });

  const { status: minedStatus } = useWaitForTransaction({
    hash: data?.hash,
    onSuccess() {
      SuccessToast(`Burned BOX`);
    },
    onError(error) {
      ErrorToast(`Error Burning BOX`);
      console.error(error);
    },
  });

  const isBurnLoading = transactionStatus === "loading" || minedStatus === "loading";

  return { burnBox, isBurnLoading };
}

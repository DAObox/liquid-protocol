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
export function useMintBox(depositUsdc: BigNumberish) {
  console.log({ depositUsdc: depositUsdc.toString() });
  const addRecentTransaction = useAddRecentTransaction();

  const { address } = useAccount();

  const { config } = usePrepareContractWrite({
    abi: marketMakerABI,
    address: contracts.marketMaker,
    functionName: "mint",
    args: [BN(depositUsdc)],
    enabled: !!(address && address !== ZERO_ADDRESS && BN(depositUsdc).gte(0)),
  });

  const {
    write: mintBox,
    status: transactionStatus,
    data,
  } = useContractWrite({
    ...config,
    onSuccess(data) {
      addRecentTransaction({ hash: data?.hash, description: `Minting BOX` });
      LoadingToast(`Minting BOX`);
      console.log(data);
    },
    onError(error) {
      ErrorToast(`Error Minting BOX`);
      console.log(error);
    },
  });

  const { status: minedStatus } = useWaitForTransaction({
    hash: data?.hash,
    onSuccess() {
      SuccessToast(`Minted BOX`);
    },
    onError(error) {
      ErrorToast(`Error Minting BOX`);
      console.error(error);
    },
  });

  const isMintLoading = transactionStatus === "loading" || minedStatus === "loading";

  return { mintBox, isMintLoading };
}

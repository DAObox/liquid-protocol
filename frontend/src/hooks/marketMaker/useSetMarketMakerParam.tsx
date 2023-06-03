import { useAddRecentTransaction } from "@rainbow-me/rainbowkit";
import { ethers } from "ethers";
import {
  useAccount,
  useContractWrite,
  usePrepareContractWrite,
  useWaitForTransaction,
} from "wagmi";
import { ErrorToast, LoadingToast, SuccessToast } from "~/components/atoms/Toast";
import { marketMakerABI } from "~/hooks/wagmi/generated";

import { contracts, ZERO_ADDRESS, parseEther, percentToPPM, toHex, encodeUint256 } from "~/lib";

interface MarketMakerParam {
  parameter: "theta" | "friction" | "reserveRatio";
  value: string;
}

export function useSetMarketMakerParam({ parameter, value }: MarketMakerParam) {
  const addRecentTransaction = useAddRecentTransaction();

  const { address } = useAccount();

  const { config } = usePrepareContractWrite({
    abi: marketMakerABI,
    address: contracts.marketMaker,
    functionName: "setGovernance",
    args: [toHex(parameter), encodeUint256(value)],
    enabled: !!(parameter && value),
  });

  const {
    write: setParamter,
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

  // const { status: minedStatus } = useWaitForTransaction({
  //   hash: data?.hash,
  //   onSuccess() {
  //     SuccessToast(`Trading Opened`);
  //     console.log("Confirmed");
  //   },
  //   onError(error) {
  //     ErrorToast(`Error Opening Trading`);
  //     console.error(error);
  //   },
  // });

  // const isOpenTradingLoading = transactionStatus === "loading" || minedStatus === "loading";

  // return { openTrading, isOpenTradingLoading };
}

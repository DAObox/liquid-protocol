import clsx from "clsx";
import React from "react";
import { useAccount } from "wagmi";
import Card from "~/components/atoms/Card";
import { contracts } from "~/lib/constants";
import { useIsTradingOpen, useAllowanceUSDC, useApproveUSDC, useOpenTrading } from "~/hooks";
import { GlassButton } from "../components/atoms/GlassButton";
import { parseEther } from "~/lib/ethFormatter";

const { marketMaker } = contracts;

export const OpenTrading = () => {
  const [mintAmount, setMintAmount] = React.useState<string>("0");
  const [depositUsdc, setDepositUsdc] = React.useState<string>("0");

  const { address } = useAccount();
  const { allowance } = useAllowanceUSDC({ from: address, to: marketMaker });
  const { isTradingOpen } = useIsTradingOpen();
  const { approve, displayLoading } = useApproveUSDC(depositUsdc);
  const { openTrading, isOpenTradingLoading } = useOpenTrading(mintAmount, depositUsdc);

  function handleDepositUsdcChange(e: React.ChangeEvent<HTMLInputElement>) {
    const inputValue = e.target.value;
    if (inputValue === "" || parseFloat(inputValue) < 0) {
      setDepositUsdc("0");
      return;
    }
    setDepositUsdc(inputValue);
  }

  function handleMintChange(e: React.ChangeEvent<HTMLInputElement>) {
    const inputValue = e.target.value;
    if (inputValue === "" || parseFloat(inputValue) < 0) {
      setMintAmount("0");
      return;
    }
    setMintAmount(inputValue);
  }

  return (
    <Card className="flex-col space-x-2">
      <div className="flex justify-center">Pre Trading Settings</div>
      <div className="flex space-x-2 py-2">
        <div className="form-control w-full max-w-xs">
          <label className="label">
            <span className="label-text">Premint Tokens</span>
          </label>
          <input
            type="number"
            disabled={isTradingOpen}
            className="input-bordered input w-full"
            value={mintAmount}
            onChange={handleMintChange}
          />
        </div>
        <div className="form-control w-full max-w-xs">
          <label className="label">
            <span className="label-text">Initial Collateral</span>
          </label>
          <input
            type="number"
            disabled={isTradingOpen}
            className="input-bordered input w-full"
            value={depositUsdc}
            onChange={handleDepositUsdcChange}
          />
        </div>
      </div>
      <div className="flex ">
        {allowance?.gte(parseEther(depositUsdc)) ? (
          <GlassButton
            label={isTradingOpen ? "Trading Opened" : "Open Trading"}
            onClick={() => openTrading?.()}
            disabled={isOpenTradingLoading || isTradingOpen}
            className={clsx(isOpenTradingLoading && "loading")}
          />
        ) : (
          <GlassButton
            label={isTradingOpen ? "Trading Opened" : "Approve USDC"}
            onClick={() => approve?.()}
            disabled={displayLoading || isTradingOpen}
            className={clsx(displayLoading && "loading")}
          />
        )}
      </div>
    </Card>
  );
};

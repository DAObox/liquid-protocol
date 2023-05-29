/* eslint-disable @typescript-eslint/no-non-null-assertion */
import React from "react";
import { useAccount } from "wagmi";
import { usdcFormatter } from "~/lib/ethFormatter";
import { useMintUSDC, useBalanceUSDC } from "~/hooks";

export const USDCFaucet = () => {
  const [value, setValue] = React.useState<string>("0");
  const { address } = useAccount();
  const { usdcBalance } = useBalanceUSDC({ address });
  const { mint, isMintLoading } = useMintUSDC(value);

  function handleInputChange(e: React.ChangeEvent<HTMLInputElement>) {
    const inputValue = e.target.value;
    if (inputValue === "" || parseFloat(inputValue) < 0) {
      setValue("0");
      return;
    }
    setValue(inputValue);
  }
  return (
    <div className="stats w-[35rem] bg-[#191B1F]">
      <div className="stat">
        <div className="stat-title">USDC Balance</div>
        <div className="stat-value">{usdcFormatter(usdcBalance, 18)}</div>
      </div>

      <div className="stat space-y-1">
        <div className="input-group">
          <label className="input-group-xs input-group">
            <span>$</span>
            <input
              type="number"
              placeholder="0.01"
              className="input-bordered input w-full appearance-none"
              value={value}
              onChange={handleInputChange}
            />
          </label>
        </div>
        <button
          className={`btn-sm btn bg-[#2172E5] ${isMintLoading ? "loading" : ""}`}
          disabled={isMintLoading || !mint}
          onClick={() => mint?.()}
        >
          Mint
        </button>
      </div>
    </div>
  );
};

import React, { useState } from "react";
import SwapButton from "src/components/SwapComponent/SwapButton";
import { SwapSettingsButton } from "./SwapSettingsButton";
import { SwitchButton } from "./SwitchButton";
import { TokenField } from "./TokenField";
import Card from "../atoms/Card";

import { useMarketMaker } from "~/contexts/TransactionContext";

export const SwapComponent = () => {
  const { tokens, switchTokens, sellAmount, setSellAmount, buyTokenBalance, saleTokenBalance } =
    useMarketMaker();

  return (
    <Card className="w-[35rem]" bordered>
      <div className="flex items-center justify-between px-2 text-xl font-semibold">
        <div>Swap</div>
        <SwapSettingsButton />
      </div>

      <div className="relative">
        <TokenField
          token={tokens.buyToken}
          amount={sellAmount}
          setAmount={setSellAmount}
          balance={buyTokenBalance}
          max={true}
        />
        <SwitchButton switchTokens={switchTokens} />
        <TokenField
          token={tokens.sellToken}
          onChange={() => console.log}
          balance={saleTokenBalance}
        />
      </div>

      <SwapButton loading={true} />
    </Card>
  );
};

export default SwapComponent;

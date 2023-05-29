import React, { useState } from "react";
import SwapButton from "~/components/SwapComponent/SwapButton";
import { SwapSettingsButton } from "./SwapSettingsButton";
import { SwitchButton } from "./SwitchButton";
import { TokenField } from "./TokenField";
import Card from "../atoms/Card";
import daoboxLogo from "~/public/logo_color.png";
import { TokenType } from "~/types";

const BOX: TokenType = {
  logo: daoboxLogo,
  alt: "BOX",
  name: "BOX",
};

const MATIC: TokenType = {
  logo: daoboxLogo,
  alt: "MATIC",
  name: "MATIC",
};

export const SwapComponent = () => {
  const swapTokens = () => {
    console.log("swapTokens");
  };

  return (
    <Card className="w-[35rem]" bordered>
      {/* Top */}
      <div className="flex items-center justify-between px-2 text-xl font-semibold">
        <div>Swap</div>
        <SwapSettingsButton />
      </div>
      {/* Token Selectors */}
      <div className="relative">
        <TokenField token={BOX} onChange={() => console.log} max />
        <SwitchButton switchTokens={swapTokens} />
        <TokenField token={MATIC} onChange={() => console.log} />
      </div>
      <SwapButton loading={true} />
    </Card>
  );
};

export default SwapComponent;

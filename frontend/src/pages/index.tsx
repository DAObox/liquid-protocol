import React from "react";
import addresses from "~/addresses.json";
import { MarketMakerParams } from "~/components/MarketMakerParams";
import { USDCFaucet } from "../components/organisms/USDCFaucet";
import { NewDaoComponent } from "./NewDaoComponent";
import { OpenTrading } from "./OpenTrading";

export const mumbai = addresses.mumbai;

const Index = () => {
  return (
    <div className="flex-col space-y-2">
      <NewDaoComponent />
      <USDCFaucet />
      <OpenTrading />
      <MarketMakerParams />
    </div>
  );
};

export default Index;

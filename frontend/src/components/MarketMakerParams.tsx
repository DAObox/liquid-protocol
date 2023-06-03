import clsx from "clsx";
import React from "react";
import Card from "~/components/atoms/Card";
import { useMarketMakerParams } from "src/hooks";
import { ppmToPercent, percentToPPM } from "src/lib";

export const MarketMakerParams = () => {
  const { curveParams } = useMarketMakerParams();
  const currentFundingRate = curveParams?.theta ?? 0;
  const currentExitFee = curveParams?.friction ?? 0;
  const currentReserveRatio = curveParams?.reserveRatio ?? 0;

  const [fundingRate, setFundingRate] = React.useState<number>(currentFundingRate);
  const [exitFee, setExitFee] = React.useState<number>(currentExitFee);
  const [reserveRatio, setReserveRatio] = React.useState<number>(currentReserveRatio);

  return (
    <Card className="flex-col space-x-2">
      <div className="flex justify-center py-2">MarketMaker Settings</div>
      <div>
        <MMParam
          name="Funding Rate"
          value={fundingRate}
          current={currentFundingRate}
          setValue={setFundingRate}
        />
        <MMParam name="Exit Fee" value={exitFee} current={currentExitFee} setValue={setExitFee} />
        <MMParam
          name="Reserve Ratio"
          value={reserveRatio}
          current={currentReserveRatio}
          setValue={setReserveRatio}
        />
      </div>
    </Card>
  );
};

type MarketMakerParamsProps = {
  name: string;
  value: number;
  current: number;
  setValue: (value: number) => void;
};
function MMParam({ name, value, current, setValue }: MarketMakerParamsProps) {
  return (
    <div className="flex items-center space-x-2 space-y-2">
      <div className="w-28 flex-none">{name}</div>

      <input
        type="range"
        min="0"
        max="100"
        value={ppmToPercent(value)}
        className={clsx("range range-md", { "range-error": value !== current })}
        onChange={(e) => {
          setValue(percentToPPM(Number(e.target.value)));
        }}
      />

      <input
        type="text"
        value={ppmToPercent(value)}
        className="input-bordered input w-14 text-sm"
        disabled
      />
      <button className="btn-primary btn-sm btn h-12">Set</button>
    </div>
  );
}

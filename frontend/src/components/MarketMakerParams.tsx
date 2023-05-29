import React from "react";
import Card from "~/components/atoms/Card";

export const MarketMakerParams = () => {
  return (
    <Card className="flex-col space-x-2">
      <div className="flex justify-center py-2">MarketMaker Settings</div>
      <div>
        <MMParam name="Funding Rate" />
        <MMParam name="Exit Fee" />
        <MMParam name="Reserve Ratio" />
      </div>
    </Card>
  );
};
function MMParam({ name }: { name: string }) {
  const [value, setValue] = React.useState<string>("0");
  return (
    <div className="flex items-center space-x-2 space-y-2">
      <div className="w-28 flex-none">{name}</div>

      <input
        type="range"
        min="0"
        max="100"
        value={value}
        className="range range-primary range-md"
        onChange={(e) => {
          setValue(e.target.value);
        }}
      />

      <input type="text" value={value} className="input-bordered input w-14 text-sm" disabled />
      <button className="btn-primary btn-sm btn h-12">Set</button>
    </div>
  );
}

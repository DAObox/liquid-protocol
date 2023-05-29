import React from "react";

const proposals = () => {
  return (
    <div className="flex-col">
      <div>proposals</div>
      <ProposalCard />
    </div>
  );
};

export default proposals;

const ProposalCard = () => {
  return (
    <div className="w-[45rem] rounded-2xl bg-[#191B1F] p-4 ring-1 ring-[#33363f]">
      <div className="flex items-center justify-between px-2 text-xl font-semibold">
        <div>Swap</div>
        <div>Time</div>
      </div>
    </div>
  );
};

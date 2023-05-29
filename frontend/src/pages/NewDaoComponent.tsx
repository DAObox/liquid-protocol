import React from "react";
import { useNewDao, encodePluginInstallItem } from "@daobox/use-aragon";
import Card from "~/components/atoms/Card";
import { continuousDaoSetupABI } from "~/hooks/wagmi/generated";
import { useContractEvent } from "wagmi";
import { ppm } from "~/lib/ethFormatter";
import { mumbai } from ".";

export function NewDaoComponent() {
  const pluginInstallItem = encodePluginInstallItem({
    types: [
      "string",
      "string",
      "address",
      "tuple(uint8 votingMode, uint64 supportThreshold, uint64 minParticipation, uint64 minDuration, uint256 minProposerVotingPower) votingSettings",
      "tuple(uint32 theta, uint32 friction, uint32 reserveRatio, address curve) CurveParameters",
      "address",
    ],
    parameters: [
      "LiquidDAO",
      "DAO",
      mumbai.MockUSDC,
      {
        votingMode: 0,
        supportThreshold: ppm(0.5),
        minParticipation: ppm(0.1),
        minDuration: 60 * 60,
        minProposerVotingPower: 1,
      },
      {
        theta: ppm(0.5),
        friction: ppm(0.05),
        reserveRatio: ppm(0.3),
        curve: mumbai.BancorBondingCurve,
      },
      "0x47d80912400ef8f8224531EBEB1ce8f2ACf4b75a",
    ],
    repoAddress: mumbai.PluginRepo,
  });

  const daoMetadata = {
    name: "liquid test",
    description: "some description",
    links: [],
  };

  const [name, setName] = React.useState<string>("");
  const { mutate } = useNewDao({
    daoMetadata,
    ensSubdomain: name.toLowerCase(),
    plugins: [pluginInstallItem],
    onSuccess(data) {
      console.log({ success: data });
    },
  });

  useContractEvent({
    abi: continuousDaoSetupABI,
    address: "0xE387222a2154b5e7285bF23e808D68e0a213b5a1",
    eventName: "DeployedContracts",
    listener(voting, token, marketMaker, admin) {
      console.log({ voting, token, marketMaker, admin });
    },
  });

  return (
    <Card className="flex space-x-2">
      <button
        className="btn flex-none"
        disabled={!mutate}
        onClick={() => mutate?.()}
      >
        newDAO
      </button>
      <input
        type="text"
        placeholder="DAO Name"
        className="input-bordered input flex-grow"
        value={name}
        onChange={(e) => setName(e.target.value)}
      />
    </Card>
  );
}

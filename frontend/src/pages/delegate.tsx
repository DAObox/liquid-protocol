import React from "react";
import {
  ArrowRightIcon,
  IdentificationIcon,
} from "@heroicons/react/24/outline";
import Image from "next/legacy/image";
import Link from "next/link";

import { Address } from "wagmi";
import Blockies from "react-blockies";
import { truncateAddress } from "~/lib/strings";
import Card from "~/components/atoms/Card";
const delegates = () => {
  return (
    <div className="grid grid-cols-1 gap-6 md:grid-cols-2 ">
      <MemberCard member={"0x12345678909876543212345678909876543"} />
      <MemberCard member={"0x12345678909876543212345678909876543"} />{" "}
      <MemberCard member={"0x12345678909876543212345678909876543"} />{" "}
      <MemberCard member={"0x12345678909876543212345678909876543"} />{" "}
      <MemberCard member={"0x12345678909876543212345678909876543"} />{" "}
      <MemberCard member={"0x12345678909876543212345678909876543"} />
    </div>
  );
};

export default delegates;

export function MemberCard({ member }: { member: Address }) {
  // const { token } = useBalanceAndPower(member);

  return (
    <Card className="w-96" hoverable bordered clickable>
      <div className="card-body items-center space-y-1 text-center">
        <div className="flex w-full items-center justify-between">
          <div className="flex w-full items-center space-x-3">
            <div className="relative h-10 w-10 shrink-0">
              <div className="avatar">
                <Blockies
                  seed={member}
                  size={10}
                  className="overflow-hidden rounded-full ring-2 ring-primary"
                />
              </div>
            </div>
            <h2 className="card-title max-w-full truncate">
              {truncateAddress(member ?? "")}
            </h2>
          </div>
          <div></div>
        </div>
        <div className="w-full space-y-2.5">
          <div className="flex w-full items-center justify-start space-x-2">
            <div className="relative h-4 w-4">
              <Image src={"/bal-light.png"} layout="fill" alt="image" />
            </div>
            <p className="text-start text-primary">Token balance: {420 ?? 0}</p>
          </div>
          <div className="flex w-full items-center justify-start space-x-2">
            <div className="relative h-4 w-4">
              <Image
                src={"/voting-power-light.png"}
                layout="fill"
                alt="image"
              />
            </div>
            <p className="text-start text-primary">Voting power: {69 ?? 0}</p>
          </div>
          <div className="flex max-w-fit items-center justify-start space-x-0.5">
            <div>
              <p className="text-daoboxg text-start text-sm">
                View member profile
              </p>
            </div>
            <div>
              <ArrowRightIcon className="text-daoboxg h-4 w-4" />
            </div>
          </div>
        </div>
      </div>
    </Card>
  );
}

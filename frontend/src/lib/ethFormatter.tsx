import { encodeRatio } from "@daobox/use-aragon";
import { BigNumber, ethers, type BigNumberish } from "ethers";

export const parseEther = ethers.utils.parseEther;


export const ethFormatter = (value: BigNumberish) => {
  return `Ξ ${BigNumber.from(value)
    .div(BigNumber.from(10).pow(18))
    .toString()}`;
};

export const usdcFormatter = (amount: BigNumberish | undefined, decimals: number): string  =>{

  if (!amount) return "$0.00";
  console.log(amount.toString())
  console.log({num:Number(ethers.utils.formatEther(amount))})

  return Number(ethers.utils.formatEther(amount)).toLocaleString(undefined, {
    style: "currency",
    currency: "USD",
    maximumFractionDigits: 0,
  }).toString();

}

export const ppm = (n: number) => encodeRatio(n, 6);

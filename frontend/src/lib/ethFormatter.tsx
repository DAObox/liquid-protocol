import { encodeRatio } from "@daobox/use-aragon";
import { BigNumber, ethers, type BigNumberish } from "ethers";

export const parseEther = ethers.utils.parseEther;




export const tokenFormatter = (value: BigNumberish) => {
  return `${BigNumber.from(value)
    .div(BigNumber.from(10).pow(18))
    .toString()}`;
}

export const ethFormatter = (value: BigNumberish) => {
  return `Ξ ${tokenFormatter(value)}`;
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


export const ppmToPercent = (value: BigNumberish) => {
  const val = BigNumber.from(value).toNumber();
  if (val === 0) return 0;
  return val / 10000;
};

export const percentToPPM = (value: BigNumberish) => {
  const val = BigNumber.from(value).toNumber();

  if (val === 0) return 0;
  return val * 10000;
};

export function toHex(input: string) {
  return ethers.utils.hexlify(ethers.utils.toUtf8Bytes(input)) as `0x${string}`;
}

export const encodeUint256 = (value: BigNumberish) => {
  return ethers.utils.defaultAbiCoder.encode(["uint256"], [value]) as `0x${string}`
}

export const BN = (val: BigNumberish) => BigNumber.from(val)

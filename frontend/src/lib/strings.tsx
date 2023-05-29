import { Address } from "wagmi";

export function truncateAddress(
  address: Address | string | undefined,
  numCharsBefore = 6,
  numCharsAfter = 4
) {
  if (!address) return "";

  if (address.length <= numCharsBefore + numCharsAfter + 2) {
    return address;
  }

  const start = address.slice(0, numCharsBefore);
  const end = address.slice(-numCharsAfter);
  return `${start}...${end}`;
}

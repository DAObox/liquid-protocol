export const ZERO_ADDRESS: Address = `0x${"0".repeat(40)}`;
import * as z from 'zod';

type Address = `0x${string}`;

const addressSchema = z.object({
  PluginRepo: z.string() as z.Schema<Address>,
  BancorBondingCurve: z.string() as z.Schema<Address>,
  MockUSDC: z.string() as z.Schema<Address>,
  dao: z.string() as z.Schema<Address>,
  voting: z.string() as z.Schema<Address>,
  token: z.string() as z.Schema<Address>,
  marketMaker: z.string() as z.Schema<Address>,
  admin: z.string() as z.Schema<Address>,
});

type Contracts = z.infer<typeof addressSchema>;

export const contracts: Contracts = {
  PluginRepo: "0x65ffe191108f2ba792eed9ed325e759837d7a4a7",
  BancorBondingCurve: "0x08828cfe7a4e74744bc1784dda01d8b1cf569879",
  MockUSDC: "0xEb640996ed4EDE0E7797411D353d394A2b1A6DFE",
  dao: "0x7BC53DF85C5e8b500d9269F17023A3d42871f89B",
  voting: "0x9936B1d4159B49D8c6CB7811C04593D47176ac32",
  token: "0xa09bc0A647CE6c329053e0656c2CBf70279FF69D",
  marketMaker: "0xcdc1B5d8ea02c25FD8f7E5a321e46c743A711925",
  admin: "0x47d80912400ef8f8224531EBEB1ce8f2ACf4b75a",
};

addressSchema.parse(contracts);
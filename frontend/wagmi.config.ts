import { defineConfig } from "@wagmi/cli";
import { foundry, react } from "@wagmi/cli/plugins";

export default defineConfig({
  out: "src/hooks/wagmi/generated.ts",
  contracts: [],
  plugins: [
    foundry({
      project: "../",
    }),
    react(),
  ],
});

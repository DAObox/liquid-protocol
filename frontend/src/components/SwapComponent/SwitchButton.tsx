import React from "react";
import { MdSwapVert } from "react-icons/md";
import { motion } from "framer-motion";

export function SwitchButton({ switchTokens }: { switchTokens: () => void }) {
  return (
    <div className="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 transform">
      <motion.button
        onClick={() => switchTokens()}
        whileHover={{ rotate: 15 }} // slightly rotate on hover
        whileTap={{ scale: 0.95, rotate: 180 }} // half rotate on press
        className="flex h-10 w-10 items-center justify-center rounded-xl border-2 border-[#191B1F] bg-blue-500 p-2 ring-4 ring-[#191B1F]"
      >
        <MdSwapVert className="text-3xl" />
      </motion.button>
    </div>
  );
}

import React from "react";
import { RiSettings3Fill } from "react-icons/ri";
import { motion } from "framer-motion";

export function SwapSettingsButton() {
  return (
    <motion.div
      whileHover={{ scale: 1.1, rotate: 45 }} // slightly rotate on hover
      whileTap={{ scale: 0.95, rotate: 180 }} // half rotate on press
    >
      <RiSettings3Fill />
    </motion.div>
  );
}

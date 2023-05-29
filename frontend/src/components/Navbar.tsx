import { useEffect, useRef, useState } from "react";
import { FiArrowUpRight } from "react-icons/fi";
import { motion, useSpring } from "framer-motion";
import { useRouter } from "next/router";

export function Navbar() {
  const [selectedNav, setSelectedNav] = useState("swap");
  const router = useRouter();

  const refs = useRef({});

  const x = useSpring(0, { stiffness: 300, damping: 30 });
  const y = useSpring(0, { stiffness: 300, damping: 30 });
  const width = useSpring(0, { stiffness: 300, damping: 30 });
  const height = useSpring(0, { stiffness: 300, damping: 30 });

  const handleNavClick = (nav) => {
    setSelectedNav(nav);
    // get a router instance
    const navRect = refs.current[nav].getBoundingClientRect();
    const parentRect = refs.current[nav].parentNode.getBoundingClientRect();

    const relativeX = navRect.left - parentRect.left;
    const relativeY = navRect.top - parentRect.top;

    x.set(relativeX);
    y.set(relativeY);
    width.set(navRect.width);
    height.set(navRect.height);

    // navigate to the new page
    nav === "home" ? router.push("/") : router.push(`${nav}`);
  };

  useEffect(() => {
    const {
      x: initX,
      y: initY,
      width: initWidth,
      height: initHeight,
    } = refs.current[selectedNav].getBoundingClientRect();
    const parentRect =
      refs.current[selectedNav].parentNode.getBoundingClientRect();

    const relativeX = initX - parentRect.left;
    const relativeY = initY - parentRect.top;

    x.set(relativeX);
    y.set(relativeY);
    width.set(initWidth);
    height.set(initHeight);
  }, []); // run thi effect only once on initial

  const registerRef = (node) => {
    if (node !== null) {
      refs.current[node.textContent.toLowerCase()] = node;
    }
  };

  return (
    <div className="relative flex rounded-3xl bg-[#191B1F]">
      <motion.div
        className="absolute rounded-3xl bg-[#20242A]/50"
        style={{ x, y, width, height }}
      />
      <NavItem
        onClick={() => handleNavClick("home")}
        selectedNav={selectedNav === "home"}
        name="Home"
        register={registerRef}
      />
      <NavItem
        onClick={() => handleNavClick("swap")}
        selectedNav={selectedNav === "swap"}
        name="Swap"
        register={registerRef}
      />

      <a href="https://discord.gg/d5nCgVt4kE" target="_blank" rel="noreferrer">
        <div
          className={`m-1 flex cursor-pointer items-center rounded-3xl px-4 py-2 text-[0.9rem] text-lg font-semibold`}
        >
          Community <FiArrowUpRight />
        </div>
      </a>
    </div>
  );
}
function NavItem({ selectedNav, name, onClick, register }) {
  return (
    <div
      ref={register}
      onClick={onClick}
      className={`m-1 flex cursor-pointer items-center rounded-3xl px-4 py-2 text-[0.9rem] text-lg font-semibold ${
        selectedNav && "bg-[#20242A]"
      }`}
    >
      {name}
    </div>
  );
}

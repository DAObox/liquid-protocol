import { ConnectButton } from "@rainbow-me/rainbowkit";
import { Navbar } from "./Navbar";

const Header = () => {
  return (
    <div className="flex w-screen items-center justify-between p-4">
      <div className="flex w-1/4 items-center justify-start"></div>
      <Navbar />
      <div className="flex w-1/4 items-center justify-end">
        <ConnectButton />
      </div>
    </div>
  );
};

export default Header;

"use client";

import type { NextPage } from "next";
import { BackgammonBoard } from "~~/components/BackgammonBoard";
import { RainbowKitCustomConnectButton } from "~~/components/scaffold-eth/RainbowKitCustomConnectButton";

const Home: NextPage = () => {
  return (
    <>
      <div className="flex flex-col min-h-screen">
        {/* Wallet Connect Button - Top Right */}
        <div className="flex justify-end p-4">
          <RainbowKitCustomConnectButton />
        </div>
        {/* Main Game Board */}
        <div className="flex items-center flex-col grow pt-10">
          <div className="px-5 w-auto rounded-lg">
            <BackgammonBoard />
          </div>
        </div>
      </div>
    </>
  );
};

export default Home;

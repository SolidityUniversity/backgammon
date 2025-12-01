"use client";

import type { NextPage } from "next";
import { BackgammonBoard } from "~~/components/BackgammonBoard";

const Home: NextPage = () => {
  return (
    <>
      <div className="flex items-center flex-col grow pt-10">
        <div className="px-5 w-auto rounded-lg">
          <BackgammonBoard />
        </div>
      </div>
    </>
  );
};

export default Home;

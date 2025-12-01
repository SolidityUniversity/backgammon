import React from "react";

/**
 * Site footer
 */
export const Footer = () => {
  return (
    <div className="min-h-0 py-5 px-1 mb-11 lg:mb-0">
      <div className="w-full">
        <div className="flex justify-center items-center text-sm w-full">
          <p className="m-0 text-center">
            Built with ❤️ by{" "}
            <a href="https://www.solidity.university/" target="_blank" rel="noreferrer" className="link">
              Solidity University
            </a>
          </p>
        </div>
      </div>
    </div>
  );
};

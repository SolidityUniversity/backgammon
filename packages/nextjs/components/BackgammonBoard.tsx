"use client";

import { useScaffoldReadContract } from "~~/hooks/scaffold-eth";

export const BackgammonBoard = () => {
  // Read white positions for cells 1-24 (cell 0 is reserved for dead checkers)
  const white1 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [1n] });
  const white2 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [2n] });
  const white3 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [3n] });
  const white4 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [4n] });
  const white5 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [5n] });
  const white6 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [6n] });
  const white7 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [7n] });
  const white8 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [8n] });
  const white9 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [9n] });
  const white10 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [10n] });
  const white11 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [11n] });
  const white12 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [12n] });
  const white13 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [13n] });
  const white14 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [14n] });
  const white15 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [15n] });
  const white16 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [16n] });
  const white17 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [17n] });
  const white18 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [18n] });
  const white19 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [19n] });
  const white20 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [20n] });
  const white21 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [21n] });
  const white22 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [22n] });
  const white23 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [23n] });
  const white24 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "white", args: [24n] });

  // Read black positions for cells 1-24 (cell 0 is reserved for dead checkers)
  const black1 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [1n] });
  const black2 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [2n] });
  const black3 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [3n] });
  const black4 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [4n] });
  const black5 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [5n] });
  const black6 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [6n] });
  const black7 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [7n] });
  const black8 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [8n] });
  const black9 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [9n] });
  const black10 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [10n] });
  const black11 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [11n] });
  const black12 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [12n] });
  const black13 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [13n] });
  const black14 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [14n] });
  const black15 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [15n] });
  const black16 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [16n] });
  const black17 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [17n] });
  const black18 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [18n] });
  const black19 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [19n] });
  const black20 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [20n] });
  const black21 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [21n] });
  const black22 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [22n] });
  const black23 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [23n] });
  const black24 = useScaffoldReadContract({ contractName: "Backgammon", functionName: "black", args: [24n] });

  // Direct mapping: cell 1 → index 1, cell 24 → index 24
  const whiteReads = [
    white1, // cell 1
    white2, // cell 2
    white3, // cell 3
    white4, // cell 4
    white5, // cell 5
    white6, // cell 6
    white7, // cell 7
    white8, // cell 8
    white9, // cell 9
    white10, // cell 10
    white11, // cell 11
    white12, // cell 12
    white13, // cell 13
    white14, // cell 14
    white15, // cell 15
    white16, // cell 16
    white17, // cell 17
    white18, // cell 18
    white19, // cell 19
    white20, // cell 20
    white21, // cell 21
    white22, // cell 22
    white23, // cell 23
    white24, // cell 24
  ];

  const blackReads = [
    black1, // cell 1
    black2, // cell 2
    black3, // cell 3
    black4, // cell 4
    black5, // cell 5
    black6, // cell 6
    black7, // cell 7
    black8, // cell 8
    black9, // cell 9
    black10, // cell 10
    black11, // cell 11
    black12, // cell 12
    black13, // cell 13
    black14, // cell 14
    black15, // cell 15
    black16, // cell 16
    black17, // cell 17
    black18, // cell 18
    black19, // cell 19
    black20, // cell 20
    black21, // cell 21
    black22, // cell 22
    black23, // cell 23
    black24, // cell 24
  ];

  const white = whiteReads.map(read => read.data || 0n);
  const black = blackReads.map(read => read.data || 0n);

  const isLoading = whiteReads.some(r => r.isLoading) || blackReads.some(r => r.isLoading);

  if (isLoading) {
    return (
      <div className="flex justify-center items-center p-8">
        <span className="loading loading-spinner loading-lg"></span>
      </div>
    );
  }

  const renderPoint = (cell: number, isTop: boolean) => {
    // Direct mapping: cell 1-24 maps directly to array index 0-23
    // cell 1 → array[0], cell 2 → array[1], ..., cell 24 → array[23]
    const arrayIndex = cell - 1;
    const whiteCount = Number(white[arrayIndex] || 0);
    const blackCount = Number(black[arrayIndex] || 0);
    const totalCount = whiteCount + blackCount;

    return (
      <div key={cell} className="relative w-16 h-64">
        {/* Triangle background */}
        <div
          className={`absolute inset-0 ${isTop ? "justify-start" : "justify-end"}`}
          style={{
            clipPath: isTop ? "polygon(0 0, 100% 0, 50% 100%)" : "polygon(50% 0, 100% 100%, 0 100%)",
            backgroundColor: cell % 2 === 0 ? "#d4a574" : "#8b6f47",
          }}
        ></div>

        {/* Point number - shows cell number (1-24) */}
        <div
          className={`absolute z-10 ${isTop ? "top-2" : "bottom-2"} left-1/2 transform -translate-x-1/2 text-xs font-bold text-base-content/60`}
        >
          {cell}
        </div>

        {/* Checkers */}
        <div
          className={`absolute z-30 left-1/2 transform -translate-x-1/2 flex flex-col gap-1 ${isTop ? "top-8" : "bottom-8"} ${totalCount > 0 ? "items-center" : ""}`}
        >
          {/* White checkers */}
          {Array.from({ length: whiteCount }).map((_, i) => (
            <div
              key={`white-${i}`}
              className="w-10 h-10 rounded-full bg-white border-2 border-gray-400 shadow-md flex items-center justify-center"
            >
              <div className="w-6 h-6 rounded-full bg-white border border-gray-300"></div>
            </div>
          ))}

          {/* Black checkers */}
          {Array.from({ length: blackCount }).map((_, i) => (
            <div
              key={`black-${i}`}
              className="w-10 h-10 rounded-full bg-gray-800 border-2 border-gray-900 shadow-md flex items-center justify-center"
            >
              <div className="w-6 h-6 rounded-full bg-gray-900"></div>
            </div>
          ))}

          {/* Count indicator if more than 5 checkers */}
          {totalCount > 5 && (
            <div className="text-xs font-bold text-base-content bg-base-100 rounded-full w-6 h-6 flex items-center justify-center border border-base-content/20">
              {totalCount}
            </div>
          )}
        </div>
      </div>
    );
  };

  return (
    <div className="w-full max-w-6xl mx-auto p-4">
      <div className="bg-amber-100 rounded-lg p-6 shadow-xl">
        <h2 className="text-2xl font-bold text-center mb-6 text-amber-900">Backgammon Board</h2>

        {/* Top half: cells 12-1 (right to left) */}
        <div className="flex gap-4 mb-[100px]">
          {Array.from({ length: 12 }, (_, i) => 12 - i).map(cell => renderPoint(cell, true))}
        </div>

        {/* Bottom half: cells 13-24 (left to right) */}
        <div className="flex gap-4">
          {Array.from({ length: 12 }, (_, i) => 13 + i).map(cell => renderPoint(cell, false))}
        </div>

        {/* Legend */}
        <div className="flex justify-center gap-8 mt-6">
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 rounded-full bg-white border-2 border-gray-400"></div>
            <span className="text-sm font-medium">White</span>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-6 h-6 rounded-full bg-gray-800 border-2 border-gray-900"></div>
            <span className="text-sm font-medium">Black</span>
          </div>
        </div>
      </div>
    </div>
  );
};

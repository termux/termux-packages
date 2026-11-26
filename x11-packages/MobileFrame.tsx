import React, { useState } from 'react';
import { Smartphone, Monitor, Shield } from 'lucide-react';

interface MobileFrameProps {
  children: React.ReactNode;
}

export const MobileFrame: React.FC<MobileFrameProps> = ({ children }) => {
  const [isPhoneFrame, setIsPhoneFrame] = useState<boolean>(true);

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col items-center justify-center p-0 sm:p-4 font-sans selection:bg-cyan-500 selection:text-slate-950">
      {/* Top Bar for Switcher */}
      <header className="w-full max-w-md hidden sm:flex items-center justify-between py-2 px-3 text-xs text-slate-400 select-none">
        <div className="flex items-center gap-2">
          <div className="w-5 h-5 rounded-md bg-cyan-500/20 text-cyan-400 flex items-center justify-center font-black text-xs">
            <Shield className="w-3.5 h-3.5" />
          </div>
          <span className="font-bold text-white tracking-tight">Aegis Mobile Antivirus</span>
        </div>

        <button
          onClick={() => setIsPhoneFrame(!isPhoneFrame)}
          className="flex items-center gap-1.5 px-2.5 py-1 rounded-lg bg-slate-900 border border-slate-800 text-slate-300 hover:text-white transition"
        >
          {isPhoneFrame ? (
            <>
              <Monitor className="w-3.5 h-3.5 text-cyan-400" />
              <span>Full View</span>
            </>
          ) : (
            <>
              <Smartphone className="w-3.5 h-3.5 text-cyan-400" />
              <span>Phone Frame</span>
            </>
          )}
        </button>
      </header>

      {/* Frame Container */}
      <div
        className={`w-full transition-all duration-300 ${
          isPhoneFrame
            ? 'max-w-[420px] sm:h-[844px] sm:border-[8px] sm:border-slate-800/90 sm:rounded-[44px] sm:shadow-[0_25px_70px_rgba(0,0,0,0.8)] sm:ring-1 sm:ring-slate-700/50 relative overflow-hidden flex flex-col bg-slate-950'
            : 'max-w-xl min-h-screen sm:min-h-0 sm:rounded-2xl sm:border sm:border-slate-800 flex flex-col bg-slate-950 overflow-hidden'
        }`}
      >
        {/* Dynamic Island / Punch Hole on Mobile Frame */}
        {isPhoneFrame && (
          <div className="hidden sm:block absolute top-2.5 left-1/2 -translate-x-1/2 w-24 h-4 bg-black rounded-full z-40 border border-slate-800/80 shadow-sm" />
        )}

        {/* Inner Content Area */}
        <div className="flex-1 flex flex-col overflow-hidden relative">
          {children}
        </div>

        {/* Bottom Home Indicator Bar on Mobile Frame */}
        {isPhoneFrame && (
          <div className="hidden sm:flex justify-center pb-2 bg-slate-950 pt-1">
            <div className="w-32 h-1 bg-slate-700/80 rounded-full" />
          </div>
        )}
      </div>
    </div>
  );
};

import React, { useState, useEffect } from 'react';
import { Wifi, BatteryMedium, ShieldCheck, ShieldAlert, Sparkles } from 'lucide-react';

interface TopStatusBarProps {
  threatCount: number;
  isScanning: boolean;
}

export const TopStatusBar: React.FC<TopStatusBarProps> = ({ threatCount, isScanning }) => {
  const [time, setTime] = useState<string>('09:41');

  useEffect(() => {
    const updateTime = () => {
      const now = new Date();
      setTime(now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit', hour12: false }));
    };
    updateTime();
    const timer = setInterval(updateTime, 30000);
    return () => clearInterval(timer);
  }, []);

  return (
    <div className="w-full px-5 pt-3 pb-2 flex items-center justify-between text-xs font-semibold text-slate-300 select-none border-b border-slate-800/60 bg-slate-950/80 backdrop-blur-md sticky top-0 z-30">
      <div className="flex items-center gap-1.5">
        <span className="tracking-tight text-white font-mono">{time}</span>
        {threatCount > 0 ? (
          <span className="flex items-center gap-1 px-1.5 py-0.5 rounded bg-rose-500/20 text-rose-400 text-[10px] font-medium border border-rose-500/30 animate-pulse">
            <ShieldAlert className="w-3 h-3 text-rose-400" />
            {threatCount} Threat{threatCount > 1 ? 's' : ''}
          </span>
        ) : isScanning ? (
          <span className="flex items-center gap-1 px-1.5 py-0.5 rounded bg-cyan-500/20 text-cyan-400 text-[10px] font-medium border border-cyan-500/30 animate-pulse">
            <Sparkles className="w-3 h-3 text-cyan-400 animate-spin" />
            Scanning...
          </span>
        ) : (
          <span className="flex items-center gap-1 px-1.5 py-0.5 rounded bg-emerald-500/10 text-emerald-400 text-[10px] font-medium border border-emerald-500/20">
            <ShieldCheck className="w-3 h-3 text-emerald-400" />
            Shield Active
          </span>
        )}
      </div>

      <div className="flex items-center gap-2 text-slate-400">
        <span className="text-[10px] font-mono tracking-wider text-slate-400">5G</span>
        <Wifi className="w-3.5 h-3.5 text-slate-300" />
        <div className="flex items-center gap-1">
          <span className="text-[11px] font-mono">98%</span>
          <BatteryMedium className="w-4 h-4 text-emerald-400" />
        </div>
      </div>
    </div>
  );
};

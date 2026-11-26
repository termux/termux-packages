import React, { useState } from 'react';
import { motion } from 'motion/react';
import { Trash2, Zap, CheckCircle2, RefreshCw, HardDrive, Cpu, Sparkles, FolderArchive, Layers } from 'lucide-react';
import { StorageCleanSummary } from '../types/antivirus';

interface JunkCleanerProps {
  summary: StorageCleanSummary;
  onCleanSuccess: () => void;
}

export const JunkCleaner: React.FC<JunkCleanerProps> = ({
  summary,
  onCleanSuccess
}) => {
  const [isCleaning, setIsCleaning] = useState<boolean>(false);
  const [cleaned, setCleaned] = useState<boolean>(summary.isCleaned);
  const [currentCleanTarget, setCurrentCleanTarget] = useState<string>('');

  const handleStartClean = () => {
    setIsCleaning(true);
    setCurrentCleanTarget('Purging app cache & thumbdata...');

    setTimeout(() => {
      setCurrentCleanTarget('Removing obsolete installer APKs...');
      setTimeout(() => {
        setCurrentCleanTarget('Terminating zombie background processes...');
        setTimeout(() => {
          setIsCleaning(false);
          setCleaned(true);
          onCleanSuccess();
        }, 800);
      }, 800);
    }, 800);
  };

  return (
    <div className="space-y-4">
      {/* Top Banner */}
      <div className="bg-gradient-to-br from-slate-900 to-slate-950 border border-slate-800 rounded-2xl p-4 text-center relative overflow-hidden">
        <div className="relative z-10 flex flex-col items-center">
          <div className="w-12 h-12 rounded-2xl bg-cyan-500/10 border border-cyan-500/20 flex items-center justify-center text-cyan-400 mb-2 shadow-inner">
            {cleaned ? <CheckCircle2 className="w-6 h-6 text-emerald-400" /> : <Trash2 className="w-6 h-6 text-cyan-400" />}
          </div>

          <h3 className="text-sm font-bold text-white uppercase tracking-wider">
            Storage & Performance Booster
          </h3>

          <div className="my-2">
            <span className="text-3xl font-black font-mono text-white tracking-tight">
              {cleaned ? '0' : (summary.totalCleanableMb / 1024).toFixed(1)}
            </span>
            <span className="text-sm font-bold text-slate-400 ml-1">
              {cleaned ? 'MB Cleaned' : 'GB Recoverable'}
            </span>
          </div>

          <p className="text-xs text-slate-400 max-w-xs leading-relaxed">
            {cleaned
              ? 'Storage optimized. App cache wiped and background RAM freed up.'
              : 'Safe to clean: System junk, residual app leftovers, and temporary APK files.'}
          </p>
        </div>

        {/* Dynamic Glow */}
        <div className="absolute -top-16 -right-16 w-32 h-32 bg-cyan-500/10 rounded-full blur-3xl pointer-events-none" />
      </div>

      {/* Clean Button */}
      {!cleaned && (
        <button
          onClick={handleStartClean}
          disabled={isCleaning}
          className="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-cyan-500 via-blue-600 to-indigo-600 hover:from-cyan-400 hover:to-indigo-500 text-slate-950 font-bold text-xs uppercase tracking-wider transition shadow-lg shadow-cyan-900/30 flex items-center justify-center gap-2 disabled:opacity-50"
        >
          {isCleaning ? (
            <>
              <Sparkles className="w-4 h-4 animate-spin text-slate-950" />
              <span>{currentCleanTarget}</span>
            </>
          ) : (
            <>
              <Zap className="w-4 h-4 text-slate-950" />
              <span>Clean & Boost Device (~2.1 GB)</span>
            </>
          )}
        </button>
      )}

      {cleaned && (
        <div className="p-3 rounded-xl bg-emerald-500/10 border border-emerald-500/30 text-emerald-300 flex items-center justify-between text-xs">
          <div className="flex items-center gap-2">
            <CheckCircle2 className="w-4 h-4 text-emerald-400 flex-shrink-0" />
            <span>2.1 GB of junk eliminated & 1.1 GB RAM freed</span>
          </div>
          <button
            onClick={() => setCleaned(false)}
            className="text-[11px] font-bold text-emerald-400 hover:underline flex items-center gap-1"
          >
            <RefreshCw className="w-3 h-3" /> Rescan
          </button>
        </div>
      )}

      {/* Breakdown Cards */}
      <div className="space-y-2">
        <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block px-1">
          Junk File Breakdown:
        </span>

        {/* Row 1 */}
        <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between text-xs">
          <div className="flex items-center gap-2.5">
            <Layers className="w-4 h-4 text-cyan-400" />
            <div>
              <span className="font-semibold text-white">App Cache & Thumbnails</span>
              <p className="text-[10px] text-slate-400">Temporary images & streaming cache</p>
            </div>
          </div>
          <span className="font-mono font-bold text-slate-200">
            {cleaned ? '0 MB' : `${summary.systemCacheMb} MB`}
          </span>
        </div>

        {/* Row 2 */}
        <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between text-xs">
          <div className="flex items-center gap-2.5">
            <FolderArchive className="w-4 h-4 text-indigo-400" />
            <div>
              <span className="font-semibold text-white">Residual Files</span>
              <p className="text-[10px] text-slate-400">Orphaned files from uninstalled apps</p>
            </div>
          </div>
          <span className="font-mono font-bold text-slate-200">
            {cleaned ? '0 MB' : `${summary.residualFilesMb} MB`}
          </span>
        </div>

        {/* Row 3 */}
        <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between text-xs">
          <div className="flex items-center gap-2.5">
            <HardDrive className="w-4 h-4 text-amber-400" />
            <div>
              <span className="font-semibold text-white">Obsolete Temp APKs</span>
              <p className="text-[10px] text-slate-400">Unused package installer packages</p>
            </div>
          </div>
          <span className="font-mono font-bold text-slate-200">
            {cleaned ? '0 MB' : `${summary.tempApkMb} MB`}
          </span>
        </div>

        {/* Row 4 */}
        <div className="p-3 rounded-xl bg-slate-900/80 border border-slate-800 flex items-center justify-between text-xs">
          <div className="flex items-center gap-2.5">
            <Cpu className="w-4 h-4 text-emerald-400" />
            <div>
              <span className="font-semibold text-white">RAM Memory Booster</span>
              <p className="text-[10px] text-slate-400">Suspends 18 idle background processes</p>
            </div>
          </div>
          <span className="font-mono font-bold text-slate-200">
            {cleaned ? 'Optimized' : `${summary.ramFreeableMb} MB`}
          </span>
        </div>
      </div>
    </div>
  );
};

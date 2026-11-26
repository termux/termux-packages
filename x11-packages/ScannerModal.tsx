import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { ShieldCheck, ShieldAlert, Sparkles, X, CheckCircle, AlertTriangle, FileText, Zap, ChevronRight, Lock } from 'lucide-react';
import { ThreatItem, ScanType } from '../types/antivirus';
import { SCAN_PATHS_STREAM } from '../data/mockSecurityData';

interface ScannerModalProps {
  isOpen: boolean;
  onClose: () => void;
  scanType: ScanType;
  threats: ThreatItem[];
  onQuarantineThreat: (id: string) => void;
  onQuarantineAll: () => void;
}

export const ScannerModal: React.FC<ScannerModalProps> = ({
  isOpen,
  onClose,
  scanType,
  threats,
  onQuarantineThreat,
  onQuarantineAll
}) => {
  const [progress, setProgress] = useState<number>(0);
  const [currentPath, setCurrentPath] = useState<string>('/system/bin/init');
  const [scannedFilesCount, setScannedFilesCount] = useState<number>(0);
  const [detectedCount, setDetectedCount] = useState<number>(0);
  const [isFinished, setIsFinished] = useState<boolean>(false);
  const [phase, setPhase] = useState<'scanning' | 'results'>('scanning');

  useEffect(() => {
    if (!isOpen) {
      setProgress(0);
      setIsFinished(false);
      setPhase('scanning');
      setScannedFilesCount(0);
      setDetectedCount(0);
      return;
    }

    const duration = scanType === 'quick' ? 6000 : 10000;
    const intervalTime = 60;
    const totalSteps = duration / intervalTime;
    let currentStep = 0;

    const interval = setInterval(() => {
      currentStep++;
      const currentPct = Math.min(100, Math.round((currentStep / totalSteps) * 100));
      setProgress(currentPct);

      const pathIndex = currentStep % SCAN_PATHS_STREAM.length;
      setCurrentPath(SCAN_PATHS_STREAM[pathIndex]);
      setScannedFilesCount((prev) => prev + Math.floor(Math.random() * 8 + 3));

      // Simulate discovering threats at specific stages
      if (currentPct > 35 && detectedCount < 1 && threats.length > 0) {
        setDetectedCount(1);
      }
      if (currentPct > 65 && detectedCount < 2 && threats.length > 1) {
        setDetectedCount(2);
      }
      if (currentPct > 85 && detectedCount < 3 && threats.length > 2) {
        setDetectedCount(threats.filter(t => t.status === 'active').length);
      }

      if (currentStep >= totalSteps) {
        clearInterval(interval);
        setProgress(100);
        setIsFinished(true);
        setPhase('results');
      }
    }, intervalTime);

    return () => clearInterval(interval);
  }, [isOpen, scanType, threats]);

  if (!isOpen) return null;

  const activeThreats = threats.filter((t) => t.status === 'active');

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-slate-950/90 backdrop-blur-xl p-4 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0, scale: 0.95, y: 20 }}
        animate={{ opacity: 1, scale: 1, y: 0 }}
        exit={{ opacity: 0, scale: 0.95, y: 20 }}
        className="w-full max-w-md bg-slate-900 border border-slate-800 rounded-3xl p-5 sm:p-6 shadow-2xl relative flex flex-col max-h-[90vh]"
      >
        {/* Close button */}
        <button
          onClick={onClose}
          className="absolute top-4 right-4 p-2 text-slate-400 hover:text-white rounded-full bg-slate-800/60 hover:bg-slate-800 transition"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Header */}
        <div className="text-center mt-2 mb-4">
          <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-cyan-500/10 border border-cyan-500/20 text-cyan-400 text-xs font-semibold uppercase tracking-wider mb-2">
            <Zap className="w-3.5 h-3.5" />
            {scanType === 'quick' ? 'Quick Heuristic Scan' : 'Deep Full System Scan'}
          </div>
          <h2 className="text-xl font-bold text-white tracking-tight">
            {phase === 'scanning' ? 'Inspecting Android Subsystems' : 'Scan Analysis Completed'}
          </h2>
          <p className="text-xs text-slate-400 mt-1">
            {phase === 'scanning'
              ? 'Real-time telemetry, Dalvik bytecodes & rootkits'
              : `Checked ${scannedFilesCount} files & process trees`}
          </p>
        </div>

        {/* Dynamic Scanning Visualization */}
        {phase === 'scanning' ? (
          <div className="flex flex-col items-center justify-center my-4">
            {/* Animated Radar Pulse */}
            <div className="relative w-44 h-44 flex items-center justify-center my-2">
              <div className="absolute inset-0 rounded-full border border-cyan-500/20 animate-ping opacity-30" />
              <div className="absolute inset-3 rounded-full border border-slate-700/60" />
              <div className="absolute inset-8 rounded-full border border-cyan-500/30" />
              <div className="absolute inset-0 rounded-full border-2 border-transparent border-t-cyan-400 animate-spin" style={{ animationDuration: '2s' }} />

              {/* Center Status Ring */}
              <div className="w-24 h-24 rounded-full bg-slate-950/80 border border-cyan-500/40 flex flex-col items-center justify-center shadow-lg shadow-cyan-500/10">
                <span className="text-2xl font-black font-mono text-white tracking-tight">
                  {progress}%
                </span>
                <span className="text-[10px] text-cyan-400 font-semibold tracking-wider uppercase">
                  Checking
                </span>
              </div>
            </div>

            {/* Current Target Path */}
            <div className="w-full bg-slate-950/70 border border-slate-800/80 rounded-xl p-3 my-3">
              <div className="flex items-center justify-between text-[11px] text-slate-400 mb-1">
                <span className="flex items-center gap-1 font-mono">
                  <FileText className="w-3 h-3 text-cyan-400" />
                  Inspecting:
                </span>
                <span className="text-slate-300 font-mono">{scannedFilesCount} objects</span>
              </div>
              <div className="text-[11px] font-mono text-cyan-300 truncate bg-slate-900/90 px-2 py-1.5 rounded border border-slate-800">
                {currentPath}
              </div>
            </div>

            {/* Live Threat Counter Badge */}
            <div className="flex items-center justify-between w-full px-2 text-xs">
              <span className="text-slate-400">Threats Flagged:</span>
              <span className={`font-mono font-bold px-2 py-0.5 rounded ${detectedCount > 0 ? 'bg-rose-500/20 text-rose-400 border border-rose-500/30' : 'bg-emerald-500/20 text-emerald-400'}`}>
                {detectedCount} detected
              </span>
            </div>
          </div>
        ) : (
          /* Scan Results View */
          <div className="flex-1 flex flex-col overflow-hidden my-2">
            {activeThreats.length > 0 ? (
              <div className="flex-1 flex flex-col overflow-hidden">
                <div className="flex items-center gap-3 p-3.5 rounded-2xl bg-rose-500/10 border border-rose-500/30 mb-3 text-rose-300">
                  <ShieldAlert className="w-7 h-7 text-rose-400 flex-shrink-0" />
                  <div>
                    <h3 className="text-sm font-bold text-rose-200">
                      {activeThreats.length} High-Risk Threat{activeThreats.length > 1 ? 's' : ''} Found
                    </h3>
                    <p className="text-xs text-rose-300/80 mt-0.5 leading-snug">
                      Malicious packages detected attempting unauthorized access. Immediate isolation advised.
                    </p>
                  </div>
                </div>

                {/* Threat list */}
                <div className="flex-1 overflow-y-auto space-y-2.5 pr-1 max-h-56">
                  {activeThreats.map((threat) => (
                    <div
                      key={threat.id}
                      className="p-3 rounded-xl bg-slate-950 border border-rose-500/20 flex flex-col gap-1.5"
                    >
                      <div className="flex items-start justify-between gap-2">
                        <div>
                          <div className="flex items-center gap-1.5">
                            <span className="px-1.5 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-rose-500/20 text-rose-400">
                              {threat.type}
                            </span>
                            <span className="text-xs font-bold text-slate-100">{threat.name}</span>
                          </div>
                          <p className="text-[11px] text-slate-400 mt-1 font-mono truncate max-w-xs">
                            {threat.targetPath}
                          </p>
                        </div>
                        <button
                          onClick={() => onQuarantineThreat(threat.id)}
                          className="px-2.5 py-1 rounded-lg bg-rose-600 hover:bg-rose-500 text-white text-xs font-semibold transition flex items-center gap-1 flex-shrink-0"
                        >
                          <Lock className="w-3 h-3" />
                          Quarantine
                        </button>
                      </div>
                      <p className="text-[11px] text-slate-400 leading-relaxed">
                        {threat.description}
                      </p>
                    </div>
                  ))}
                </div>
              </div>
            ) : (
              <div className="flex-1 flex flex-col items-center justify-center text-center p-6">
                <div className="w-16 h-16 rounded-full bg-emerald-500/10 border border-emerald-500/30 flex items-center justify-center mb-3">
                  <ShieldCheck className="w-8 h-8 text-emerald-400" />
                </div>
                <h3 className="text-lg font-bold text-white">System 100% Protected</h3>
                <p className="text-xs text-slate-400 mt-1.5 max-w-xs">
                  All active processes, sideloaded binaries, and system partitions verified safe with zero malware signatures.
                </p>
              </div>
            )}
          </div>
        )}

        {/* Actions */}
        <div className="mt-4 pt-3 border-t border-slate-800 flex items-center gap-2">
          {phase === 'scanning' ? (
            <button
              onClick={onClose}
              className="w-full py-2.5 px-4 rounded-xl bg-slate-800 hover:bg-slate-750 text-slate-300 font-semibold text-xs transition"
            >
              Run in Background
            </button>
          ) : activeThreats.length > 0 ? (
            <button
              onClick={() => {
                onQuarantineAll();
                onClose();
              }}
              className="w-full py-3 px-4 rounded-xl bg-gradient-to-r from-rose-600 to-red-600 hover:from-rose-500 hover:to-red-500 text-white font-bold text-xs tracking-wide uppercase transition shadow-lg shadow-rose-900/30 flex items-center justify-center gap-2"
            >
              <Lock className="w-4 h-4" />
              Quarantine All {activeThreats.length} Threats Now
            </button>
          ) : (
            <button
              onClick={onClose}
              className="w-full py-2.5 px-4 rounded-xl bg-emerald-600 hover:bg-emerald-500 text-white font-bold text-xs transition"
            >
              Done & Return to Dashboard
            </button>
          )}
        </div>
      </motion.div>
    </div>
  );
};

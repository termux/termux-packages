import React from 'react';
import { motion } from 'motion/react';
import {
  ShieldCheck,
  ShieldAlert,
  Zap,
  HardDrive,
  Cpu,
  Smartphone,
  Globe,
  Trash2,
  Lock,
  Sparkles,
  Search,
  ChevronRight,
  Wifi,
  ToggleLeft,
  ToggleRight,
  AlertOctagon,
  CheckCircle2,
  FileSearch
} from 'lucide-react';
import { ThreatItem, ScanType, RealtimeShieldConfig } from '../types/antivirus';

interface SecurityDashboardProps {
  threats: ThreatItem[];
  shieldConfig: RealtimeShieldConfig;
  onToggleShield: (key: keyof RealtimeShieldConfig) => void;
  onStartScan: (type: ScanType) => void;
  onNavigateTab: (tab: 'apps' | 'network' | 'cleaner' | 'advisor') => void;
  onOpenVault: () => void;
  onOpenFileInspector: () => void;
  onResolveAllThreats: () => void;
}

export const SecurityDashboard: React.FC<SecurityDashboardProps> = ({
  threats,
  shieldConfig,
  onToggleShield,
  onStartScan,
  onNavigateTab,
  onOpenVault,
  onOpenFileInspector,
  onResolveAllThreats
}) => {
  const activeThreats = threats.filter((t) => t.status === 'active');
  const quarantinedThreats = threats.filter((t) => t.status === 'quarantined');
  const isThreatFree = activeThreats.length === 0;

  return (
    <div className="space-y-4">
      {/* Dynamic Main Shield Status Card */}
      <div
        className={`relative overflow-hidden rounded-3xl p-5 border text-center transition-all ${
          isThreatFree
            ? 'bg-gradient-to-b from-slate-900 via-slate-950 to-slate-950 border-emerald-500/30 shadow-[0_0_30px_rgba(16,185,129,0.12)]'
            : 'bg-gradient-to-b from-slate-900 via-slate-950 to-slate-950 border-rose-500/40 shadow-[0_0_30px_rgba(244,63,94,0.15)]'
        }`}
      >
        {/* Subtle background glow */}
        <div
          className={`absolute -top-20 left-1/2 -translate-x-1/2 w-48 h-48 rounded-full blur-3xl pointer-events-none ${
            isThreatFree ? 'bg-emerald-500/15' : 'bg-rose-500/20'
          }`}
        />

        {/* Central Pulse Shield */}
        <div className="relative mx-auto w-32 h-32 flex items-center justify-center my-2">
          <div
            className={`absolute inset-0 rounded-full border ${
              isThreatFree
                ? 'border-emerald-500/20 animate-pulse'
                : 'border-rose-500/30 animate-ping'
            }`}
          />
          <div
            className={`w-24 h-24 rounded-full flex items-center justify-center shadow-inner ${
              isThreatFree
                ? 'bg-emerald-950/40 border border-emerald-500/40 text-emerald-400'
                : 'bg-rose-950/40 border border-rose-500/40 text-rose-400'
            }`}
          >
            {isThreatFree ? (
              <ShieldCheck className="w-12 h-12 stroke-[1.8]" />
            ) : (
              <ShieldAlert className="w-12 h-12 stroke-[1.8]" />
            )}
          </div>
        </div>

        {/* Status Text */}
        <h2 className="text-lg font-black text-white tracking-tight">
          {isThreatFree ? 'Device Fully Protected' : `${activeThreats.length} Critical Threats Flagged`}
        </h2>
        <p className="text-xs text-slate-400 mt-1 max-w-xs mx-auto leading-relaxed">
          {isThreatFree
            ? 'Live heuristics, anti-phishing, and app guard active.'
            : 'Malicious packages attempting elevated access detected.'}
        </p>

        {/* Threat Alert Action */}
        {!isThreatFree ? (
          <div className="mt-4 pt-3 border-t border-slate-800/80">
            <button
              onClick={onResolveAllThreats}
              className="w-full py-2.5 px-4 rounded-xl bg-gradient-to-r from-rose-600 to-red-600 hover:from-rose-500 hover:to-red-500 text-white font-bold text-xs uppercase tracking-wider transition shadow-lg shadow-rose-900/30 flex items-center justify-center gap-2"
            >
              <Lock className="w-4 h-4" />
              Resolve All ({activeThreats.length}) Threats
            </button>
          </div>
        ) : null}

        {/* Scan Actions */}
        <div className="grid grid-cols-2 gap-2 mt-4 pt-3 border-t border-slate-800/60">
          <button
            onClick={() => onStartScan('quick')}
            className="py-2.5 px-3 rounded-xl bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-bold text-xs transition flex items-center justify-center gap-1.5 shadow-sm"
          >
            <Zap className="w-4 h-4" />
            Quick Scan
          </button>
          <button
            onClick={() => onStartScan('full')}
            className="py-2.5 px-3 rounded-xl bg-slate-800 hover:bg-slate-750 text-white font-bold text-xs border border-slate-700 transition flex items-center justify-center gap-1.5"
          >
            <Search className="w-4 h-4 text-cyan-400" />
            Full System Scan
          </button>
        </div>
      </div>

      {/* Real-Time Shields Module */}
      <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-4 space-y-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <ShieldCheck className="w-4 h-4 text-cyan-400" />
            <h3 className="text-xs font-bold text-white uppercase tracking-wider">
              Real-Time Security Shields
            </h3>
          </div>
          <span className="text-[10px] font-mono text-emerald-400 font-bold">ALL LIVE</span>
        </div>

        <div className="grid grid-cols-2 gap-2 text-xs">
          {/* Shield 1 */}
          <div
            onClick={() => onToggleShield('fileWatcher')}
            className="p-2.5 rounded-xl bg-slate-950/80 border border-slate-800 hover:border-slate-700 transition cursor-pointer flex items-center justify-between"
          >
            <div className="min-w-0 pr-1">
              <span className="font-semibold text-slate-200 block truncate">File Guard</span>
              <span className="text-[10px] text-slate-400">Continuous scans</span>
            </div>
            {shieldConfig.fileWatcher ? (
              <ToggleRight className="w-6 h-6 text-cyan-400 flex-shrink-0" />
            ) : (
              <ToggleLeft className="w-6 h-6 text-slate-600 flex-shrink-0" />
            )}
          </div>

          {/* Shield 2 */}
          <div
            onClick={() => onToggleShield('webShield')}
            className="p-2.5 rounded-xl bg-slate-950/80 border border-slate-800 hover:border-slate-700 transition cursor-pointer flex items-center justify-between"
          >
            <div className="min-w-0 pr-1">
              <span className="font-semibold text-slate-200 block truncate">Web & Phish</span>
              <span className="text-[10px] text-slate-400">Malicious URLs</span>
            </div>
            {shieldConfig.webShield ? (
              <ToggleRight className="w-6 h-6 text-cyan-400 flex-shrink-0" />
            ) : (
              <ToggleLeft className="w-6 h-6 text-slate-600 flex-shrink-0" />
            )}
          </div>

          {/* Shield 3 */}
          <div
            onClick={() => onToggleShield('appInstallGuard')}
            className="p-2.5 rounded-xl bg-slate-950/80 border border-slate-800 hover:border-slate-700 transition cursor-pointer flex items-center justify-between"
          >
            <div className="min-w-0 pr-1">
              <span className="font-semibold text-slate-200 block truncate">Install Guard</span>
              <span className="text-[10px] text-slate-400">Pre-install checks</span>
            </div>
            {shieldConfig.appInstallGuard ? (
              <ToggleRight className="w-6 h-6 text-cyan-400 flex-shrink-0" />
            ) : (
              <ToggleLeft className="w-6 h-6 text-slate-600 flex-shrink-0" />
            )}
          </div>

          {/* Shield 4 */}
          <div
            onClick={() => onToggleShield('wifiProtection')}
            className="p-2.5 rounded-xl bg-slate-950/80 border border-slate-800 hover:border-slate-700 transition cursor-pointer flex items-center justify-between"
          >
            <div className="min-w-0 pr-1">
              <span className="font-semibold text-slate-200 block truncate">Wi-Fi Guard</span>
              <span className="text-[10px] text-slate-400">Anti-ARP spoof</span>
            </div>
            {shieldConfig.wifiProtection ? (
              <ToggleRight className="w-6 h-6 text-cyan-400 flex-shrink-0" />
            ) : (
              <ToggleLeft className="w-6 h-6 text-slate-600 flex-shrink-0" />
            )}
          </div>
        </div>
      </div>

      {/* Feature Navigation Grid */}
      <div className="grid grid-cols-2 gap-2.5">
        {/* Custom APK / File Inspector */}
        <div
          onClick={onOpenFileInspector}
          className="p-3.5 rounded-2xl bg-slate-900/80 border border-slate-800 hover:border-cyan-500/40 transition cursor-pointer flex flex-col justify-between group"
        >
          <div className="flex items-start justify-between">
            <div className="w-9 h-9 rounded-xl bg-cyan-500/10 border border-cyan-500/20 flex items-center justify-center text-cyan-400 group-hover:scale-105 transition-transform">
              <FileSearch className="w-5 h-5" />
            </div>
            <ChevronRight className="w-4 h-4 text-slate-500 group-hover:text-cyan-400 transition" />
          </div>
          <div className="mt-3">
            <h4 className="text-xs font-bold text-white">APK Sandbox</h4>
            <p className="text-[10px] text-slate-400 mt-0.5">Custom SHA-256 test</p>
          </div>
        </div>

        {/* App Privacy Audit */}
        <div
          onClick={() => onNavigateTab('apps')}
          className="p-3.5 rounded-2xl bg-slate-900/80 border border-slate-800 hover:border-cyan-500/40 transition cursor-pointer flex flex-col justify-between group"
        >
          <div className="flex items-start justify-between">
            <div className="w-9 h-9 rounded-xl bg-amber-500/10 border border-amber-500/20 flex items-center justify-center text-amber-400 group-hover:scale-105 transition-transform">
              <Smartphone className="w-5 h-5" />
            </div>
            <ChevronRight className="w-4 h-4 text-slate-500 group-hover:text-amber-400 transition" />
          </div>
          <div className="mt-3">
            <h4 className="text-xs font-bold text-white">Privacy Audit</h4>
            <p className="text-[10px] text-slate-400 mt-0.5">Permissions inspector</p>
          </div>
        </div>

        {/* Storage Cleaner */}
        <div
          onClick={() => onNavigateTab('cleaner')}
          className="p-3.5 rounded-2xl bg-slate-900/80 border border-slate-800 hover:border-cyan-500/40 transition cursor-pointer flex flex-col justify-between group"
        >
          <div className="flex items-start justify-between">
            <div className="w-9 h-9 rounded-xl bg-indigo-500/10 border border-indigo-500/20 flex items-center justify-center text-indigo-400 group-hover:scale-105 transition-transform">
              <Trash2 className="w-5 h-5" />
            </div>
            <ChevronRight className="w-4 h-4 text-slate-500 group-hover:text-indigo-400 transition" />
          </div>
          <div className="mt-3">
            <h4 className="text-xs font-bold text-white">Clean 2.1 GB</h4>
            <p className="text-[10px] text-slate-400 mt-0.5">Cache & junk booster</p>
          </div>
        </div>

        {/* Quarantine Vault */}
        <div
          onClick={onOpenVault}
          className="p-3.5 rounded-2xl bg-slate-900/80 border border-slate-800 hover:border-cyan-500/40 transition cursor-pointer flex flex-col justify-between group"
        >
          <div className="flex items-start justify-between">
            <div className="w-9 h-9 rounded-xl bg-rose-500/10 border border-rose-500/20 flex items-center justify-center text-rose-400 group-hover:scale-105 transition-transform">
              <Lock className="w-5 h-5" />
            </div>
            {quarantinedThreats.length > 0 && (
              <span className="px-1.5 py-0.2 rounded-full text-[9px] font-bold bg-rose-500 text-white">
                {quarantinedThreats.length}
              </span>
            )}
          </div>
          <div className="mt-3">
            <h4 className="text-xs font-bold text-white">Quarantine Vault</h4>
            <p className="text-[10px] text-slate-400 mt-0.5">Isolated malware</p>
          </div>
        </div>
      </div>

      {/* Telemetry Footer */}
      <div className="bg-slate-950/70 border border-slate-800/80 rounded-2xl p-3 flex items-center justify-between text-[11px] text-slate-400">
        <div>
          <span className="block text-slate-300 font-semibold">Aegis Engine v2026.09</span>
          <span className="text-[10px] text-slate-500">Database: 28,491,200 Signatures</span>
        </div>
        <div className="text-right">
          <span className="text-emerald-400 font-semibold">Definitions: Current</span>
          <span className="block text-[10px] text-slate-500">Auto-Update: On</span>
        </div>
      </div>
    </div>
  );
};

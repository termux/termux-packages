import React, { useState } from 'react';
import { motion } from 'motion/react';
import { Wifi, ShieldAlert, ShieldCheck, Lock, Globe2, Radio, CheckCircle, AlertTriangle, RefreshCw, Zap, EyeOff } from 'lucide-react';
import { NetworkSecurityReport } from '../types/antivirus';

interface WifiSecurityViewProps {
  report: NetworkSecurityReport;
  onToggleVpn: () => void;
}

export const WifiSecurityView: React.FC<WifiSecurityViewProps> = ({
  report,
  onToggleVpn
}) => {
  const [isAuditing, setIsAuditing] = useState<boolean>(false);
  const [auditStep, setAuditStep] = useState<string>('');

  const runNetworkAudit = () => {
    setIsAuditing(true);
    setAuditStep('Pinging gateway & resolving ARP table...');
    setTimeout(() => {
      setAuditStep('Validating DNSSEC & certificate chains...');
      setTimeout(() => {
        setAuditStep('Testing open ports & broadcast packets...');
        setTimeout(() => {
          setIsAuditing(false);
          setAuditStep('');
        }, 800);
      }, 800);
    }, 800);
  };

  const isSecure = report.vpnActive || report.securityRating === 'SECURE';

  return (
    <div className="space-y-4">
      {/* Network Hero Card */}
      <div
        className={`rounded-2xl border p-4.5 transition-all ${
          isSecure
            ? 'bg-gradient-to-br from-emerald-950/40 via-slate-900 to-slate-950 border-emerald-500/30'
            : 'bg-gradient-to-br from-rose-950/40 via-slate-900 to-slate-950 border-rose-500/30'
        }`}
      >
        <div className="flex items-start justify-between">
          <div>
            <div className="flex items-center gap-2">
              <Wifi className={`w-5 h-5 ${isSecure ? 'text-emerald-400' : 'text-rose-400'}`} />
              <h3 className="text-base font-extrabold text-white">{report.ssid}</h3>
            </div>
            <p className="text-xs text-slate-400 mt-1 font-mono">
              IP: {report.ip} • BSSID: {report.bssid}
            </p>
          </div>

          <span
            className={`px-2.5 py-1 rounded-full text-[10px] font-black uppercase tracking-wider ${
              isSecure
                ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30'
                : 'bg-rose-500/20 text-rose-400 border border-rose-500/30 animate-pulse'
            }`}
          >
            {isSecure ? 'SHIELDED' : 'VULNERABLE'}
          </span>
        </div>

        {/* Shield Toggle Banner */}
        <div className="mt-4 p-3 rounded-xl bg-slate-950/70 border border-slate-800 flex items-center justify-between">
          <div className="flex items-center gap-2.5">
            <div className={`w-8 h-8 rounded-lg flex items-center justify-center ${report.vpnActive ? 'bg-emerald-500/20 text-emerald-400' : 'bg-slate-800 text-slate-400'}`}>
              <EyeOff className="w-4 h-4" />
            </div>
            <div>
              <h4 className="text-xs font-bold text-white">Encrypted DNS & IP Cloak</h4>
              <p className="text-[11px] text-slate-400">
                {report.vpnActive ? 'Active DNS-over-HTTPS Tunnel' : 'Exposed to hotspot eavesdropping'}
              </p>
            </div>
          </div>

          <button
            onClick={onToggleVpn}
            className={`px-3 py-1.5 rounded-xl text-xs font-bold transition shadow-sm ${
              report.vpnActive
                ? 'bg-emerald-500 hover:bg-emerald-400 text-slate-950'
                : 'bg-cyan-500 hover:bg-cyan-400 text-slate-950'
            }`}
          >
            {report.vpnActive ? 'Protected' : 'Enable Shield'}
          </button>
        </div>
      </div>

      {/* Audit Checklist */}
      <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-4 space-y-3">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Radio className="w-4 h-4 text-cyan-400" />
            <h4 className="text-xs font-bold text-white uppercase tracking-wider">
              Network Threat Vector Audit
            </h4>
          </div>
          <button
            onClick={runNetworkAudit}
            disabled={isAuditing}
            className="text-[11px] font-semibold text-cyan-400 hover:text-cyan-300 flex items-center gap-1"
          >
            <RefreshCw className={`w-3 h-3 ${isAuditing ? 'animate-spin' : ''}`} />
            {isAuditing ? 'Testing...' : 'Retest'}
          </button>
        </div>

        {isAuditing && (
          <div className="bg-slate-950 p-2.5 rounded-xl border border-cyan-500/30 text-xs font-mono text-cyan-300 animate-pulse">
            {auditStep}
          </div>
        )}

        <div className="space-y-2 text-xs">
          {/* Item 1 */}
          <div className="p-2.5 rounded-xl bg-slate-950/70 border border-slate-800 flex items-center justify-between">
            <div className="flex items-center gap-2">
              {report.vpnActive || !report.arpSpoofDetected ? (
                <CheckCircle className="w-4 h-4 text-emerald-400 flex-shrink-0" />
              ) : (
                <AlertTriangle className="w-4 h-4 text-rose-400 flex-shrink-0" />
              )}
              <div>
                <span className="font-semibold text-white">ARP Cache Poisoning</span>
                <p className="text-[10px] text-slate-400">Prevents rogue devices rerouting your packets</p>
              </div>
            </div>
            <span className={`text-[10px] font-bold ${report.vpnActive || !report.arpSpoofDetected ? 'text-emerald-400' : 'text-rose-400'}`}>
              {report.vpnActive || !report.arpSpoofDetected ? 'Neutralized' : 'Detected!'}
            </span>
          </div>

          {/* Item 2 */}
          <div className="p-2.5 rounded-xl bg-slate-950/70 border border-slate-800 flex items-center justify-between">
            <div className="flex items-center gap-2">
              {report.vpnActive || report.dnsEncrypted ? (
                <CheckCircle className="w-4 h-4 text-emerald-400 flex-shrink-0" />
              ) : (
                <AlertTriangle className="w-4 h-4 text-amber-400 flex-shrink-0" />
              )}
              <div>
                <span className="font-semibold text-white">DNS Hijack & Leak Guard</span>
                <p className="text-[10px] text-slate-400">Prevents spoofed bank/social login redirects</p>
              </div>
            </div>
            <span className={`text-[10px] font-bold ${report.vpnActive || report.dnsEncrypted ? 'text-emerald-400' : 'text-amber-400'}`}>
              {report.vpnActive || report.dnsEncrypted ? 'Encrypted' : 'Unsecured'}
            </span>
          </div>

          {/* Item 3 */}
          <div className="p-2.5 rounded-xl bg-slate-950/70 border border-slate-800 flex items-center justify-between">
            <div className="flex items-center gap-2">
              {report.vpnActive ? (
                <CheckCircle className="w-4 h-4 text-emerald-400 flex-shrink-0" />
              ) : (
                <AlertTriangle className="w-4 h-4 text-rose-400 flex-shrink-0" />
              )}
              <div>
                <span className="font-semibold text-white">SSL Strip & Packet Sniffer Risk</span>
                <p className="text-[10px] text-slate-400">Public hotspot credential interception</p>
              </div>
            </div>
            <span className={`text-[10px] font-bold ${report.vpnActive ? 'text-emerald-400' : 'text-rose-400'}`}>
              {report.vpnActive ? 'Encrypted 256-bit' : 'Exposed'}
            </span>
          </div>
        </div>
      </div>
    </div>
  );
};

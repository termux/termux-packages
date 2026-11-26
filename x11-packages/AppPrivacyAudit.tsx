import React, { useState } from 'react';
import { motion } from 'motion/react';
import { ShieldAlert, ShieldCheck, AlertTriangle, Smartphone, ChevronDown, ChevronUp, Lock, Trash2, Eye, Sliders, CheckCircle2, XCircle } from 'lucide-react';
import { AppAuditItem } from '../types/antivirus';

interface AppPrivacyAuditProps {
  apps: AppAuditItem[];
  onTogglePermission: (appId: string, permName: string) => void;
  onQuarantineApp: (appId: string) => void;
}

export const AppPrivacyAudit: React.FC<AppPrivacyAuditProps> = ({
  apps,
  onTogglePermission,
  onQuarantineApp
}) => {
  const [filter, setFilter] = useState<'all' | 'high_risk' | 'sideloaded'>('all');
  const [expandedAppId, setExpandedAppId] = useState<string | null>(apps[0]?.id || null);

  const filteredApps = apps.filter((app) => {
    if (filter === 'high_risk') return app.riskScore >= 70;
    if (filter === 'sideloaded') return app.isSideloaded;
    return true;
  });

  const highRiskCount = apps.filter(a => a.riskScore >= 70 && !a.isQuarantined).length;
  const sideloadedCount = apps.filter(a => a.isSideloaded).length;

  return (
    <div className="space-y-4">
      {/* Header Stat Box */}
      <div className="bg-gradient-to-br from-slate-900 to-slate-950 border border-slate-800 rounded-2xl p-4">
        <div className="flex items-center justify-between mb-3">
          <div className="flex items-center gap-2">
            <Smartphone className="w-5 h-5 text-cyan-400" />
            <h3 className="text-sm font-bold text-white">App Permission & Privacy Guard</h3>
          </div>
          <span className="px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-slate-800 text-slate-300">
            {apps.length} Apps Monitored
          </span>
        </div>

        {/* Quick summary metrics */}
        <div className="grid grid-cols-2 gap-2 text-xs">
          <div className="bg-slate-950/70 border border-rose-500/20 rounded-xl p-2.5">
            <span className="text-[11px] text-slate-400">High Risk Permissions</span>
            <div className="flex items-baseline gap-1.5 mt-0.5">
              <span className="text-lg font-black font-mono text-rose-400">{highRiskCount}</span>
              <span className="text-[10px] text-rose-400/80">Require Review</span>
            </div>
          </div>
          <div className="bg-slate-950/70 border border-amber-500/20 rounded-xl p-2.5">
            <span className="text-[11px] text-slate-400">Sideloaded Packages</span>
            <div className="flex items-baseline gap-1.5 mt-0.5">
              <span className="text-lg font-black font-mono text-amber-400">{sideloadedCount}</span>
              <span className="text-[10px] text-amber-400/80">Unverified Origin</span>
            </div>
          </div>
        </div>
      </div>

      {/* Filter Tabs */}
      <div className="flex items-center gap-1.5 bg-slate-900/60 p-1 rounded-xl border border-slate-800/80 text-xs">
        <button
          onClick={() => setFilter('all')}
          className={`flex-1 py-1.5 rounded-lg font-semibold transition ${
            filter === 'all'
              ? 'bg-slate-800 text-cyan-400 shadow-sm'
              : 'text-slate-400 hover:text-white'
          }`}
        >
          All ({apps.length})
        </button>
        <button
          onClick={() => setFilter('high_risk')}
          className={`flex-1 py-1.5 rounded-lg font-semibold transition ${
            filter === 'high_risk'
              ? 'bg-rose-500/20 text-rose-400 border border-rose-500/30'
              : 'text-slate-400 hover:text-white'
          }`}
        >
          Risky ({highRiskCount})
        </button>
        <button
          onClick={() => setFilter('sideloaded')}
          className={`flex-1 py-1.5 rounded-lg font-semibold transition ${
            filter === 'sideloaded'
              ? 'bg-amber-500/20 text-amber-400 border border-amber-500/30'
              : 'text-slate-400 hover:text-white'
          }`}
        >
          Sideloaded ({sideloadedCount})
        </button>
      </div>

      {/* App List */}
      <div className="space-y-2.5">
        {filteredApps.map((app) => {
          const isExpanded = expandedAppId === app.id;
          const isHighRisk = app.riskScore >= 70;
          const isMediumRisk = app.riskScore >= 30 && app.riskScore < 70;

          return (
            <div
              key={app.id}
              className={`rounded-2xl border transition-all ${
                app.isQuarantined
                  ? 'bg-slate-950/60 border-slate-800 opacity-60'
                  : isHighRisk
                  ? 'bg-slate-900/90 border-rose-500/30'
                  : isMediumRisk
                  ? 'bg-slate-900/90 border-amber-500/20'
                  : 'bg-slate-900/70 border-slate-800/80'
              }`}
            >
              {/* App Summary Row */}
              <div
                onClick={() => setExpandedAppId(isExpanded ? null : app.id)}
                className="p-3.5 flex items-center justify-between cursor-pointer select-none"
              >
                <div className="flex items-center gap-3 min-w-0">
                  <div
                    className={`w-10 h-10 rounded-xl flex items-center justify-center font-black text-sm flex-shrink-0 ${
                      app.isQuarantined
                        ? 'bg-slate-800 text-slate-400'
                        : isHighRisk
                        ? 'bg-rose-500/20 text-rose-400 border border-rose-500/30'
                        : isMediumRisk
                        ? 'bg-amber-500/20 text-amber-400 border border-amber-500/30'
                        : 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30'
                    }`}
                  >
                    {app.appName.charAt(0)}
                  </div>

                  <div className="min-w-0">
                    <div className="flex items-center gap-2">
                      <h4 className="text-xs font-bold text-white truncate">{app.appName}</h4>
                      {app.isSideloaded && (
                        <span className="px-1.5 py-0.2 rounded text-[9px] font-extrabold uppercase bg-amber-500/20 text-amber-300 border border-amber-500/30">
                          Sideloaded
                        </span>
                      )}
                    </div>
                    <p className="text-[11px] text-slate-400 truncate font-mono mt-0.5">
                      {app.packageName}
                    </p>
                  </div>
                </div>

                <div className="flex items-center gap-2.5 flex-shrink-0">
                  {app.isQuarantined ? (
                    <span className="px-2 py-0.5 rounded text-[10px] font-bold bg-slate-800 text-slate-400">
                      Isolated
                    </span>
                  ) : (
                    <div className="text-right">
                      <div className="flex items-center gap-1 justify-end">
                        <span
                          className={`text-xs font-black font-mono ${
                            isHighRisk ? 'text-rose-400' : isMediumRisk ? 'text-amber-400' : 'text-emerald-400'
                          }`}
                        >
                          {app.riskScore}
                        </span>
                        <span className="text-[9px] text-slate-500">/100</span>
                      </div>
                      <span className="text-[9px] text-slate-400">
                        {isHighRisk ? 'Critical Risk' : isMediumRisk ? 'Medium' : 'Safe'}
                      </span>
                    </div>
                  )}

                  {isExpanded ? (
                    <ChevronUp className="w-4 h-4 text-slate-400" />
                  ) : (
                    <ChevronDown className="w-4 h-4 text-slate-400" />
                  )}
                </div>
              </div>

              {/* Expanded Permissions & Actions Drawer */}
              {isExpanded && (
                <motion.div
                  initial={{ opacity: 0, height: 0 }}
                  animate={{ opacity: 1, height: 'auto' }}
                  className="px-3.5 pb-3.5 pt-1 border-t border-slate-800 space-y-3"
                >
                  <div className="flex items-center justify-between text-[11px] text-slate-400">
                    <span>Installed: {app.installDate}</span>
                    <span>Version: {app.version}</span>
                  </div>

                  {/* Permissions Audit */}
                  <div className="space-y-1.5">
                    <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block">
                      Granted Privileges & Permissions:
                    </span>
                    {app.permissions.map((perm) => (
                      <div
                        key={perm.name}
                        className="p-2 rounded-xl bg-slate-950/80 border border-slate-800/80 flex items-center justify-between gap-2 text-xs"
                      >
                        <div className="min-w-0">
                          <div className="flex items-center gap-1.5">
                            <span className="font-mono text-[11px] font-bold text-slate-200 truncate">
                              {perm.name}
                            </span>
                            {perm.isHighRisk && (
                              <span className="px-1 py-0.2 rounded text-[9px] font-bold bg-rose-500/20 text-rose-400">
                                High Risk
                              </span>
                            )}
                          </div>
                          <p className="text-[10px] text-slate-400 mt-0.5">{perm.description}</p>
                        </div>

                        <button
                          onClick={() => onTogglePermission(app.id, perm.name)}
                          className={`px-2.5 py-1 rounded-lg text-[10px] font-bold transition flex items-center gap-1 flex-shrink-0 ${
                            perm.granted
                              ? 'bg-rose-500/20 text-rose-300 border border-rose-500/30 hover:bg-rose-500/30'
                              : 'bg-slate-800 text-slate-400 hover:bg-slate-700'
                          }`}
                        >
                          {perm.granted ? (
                            <>
                              <XCircle className="w-3 h-3" /> Revoke
                            </>
                          ) : (
                            <>
                              <CheckCircle2 className="w-3 h-3" /> Grant
                            </>
                          )}
                        </button>
                      </div>
                    ))}
                  </div>

                  {/* App Action Buttons */}
                  {!app.isQuarantined && isHighRisk && (
                    <div className="pt-1 flex gap-2">
                      <button
                        onClick={() => onQuarantineApp(app.id)}
                        className="flex-1 py-2 px-3 rounded-xl bg-rose-600 hover:bg-rose-500 text-white font-bold text-xs transition flex items-center justify-center gap-1.5 shadow-sm"
                      >
                        <Lock className="w-3.5 h-3.5" />
                        Quarantine & Freeze Package
                      </button>
                    </div>
                  )}
                </motion.div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
};

import React, { useState } from 'react';
import { motion } from 'motion/react';
import { Lock, ShieldAlert, Trash2, RotateCcw, CheckCircle2, FileText, AlertTriangle, ShieldCheck } from 'lucide-react';
import { ThreatItem } from '../types/antivirus';

interface QuarantineVaultProps {
  threats: ThreatItem[];
  onDeleteThreat: (id: string) => void;
  onRestoreThreat: (id: string) => void;
  onEmptyVault: () => void;
}

export const QuarantineVault: React.FC<QuarantineVaultProps> = ({
  threats,
  onDeleteThreat,
  onRestoreThreat,
  onEmptyVault
}) => {
  const quarantined = threats.filter((t) => t.status === 'quarantined');
  const [shreddingId, setShreddingId] = useState<string | null>(null);

  const handleShred = (id: string) => {
    setShreddingId(id);
    setTimeout(() => {
      onDeleteThreat(id);
      setShreddingId(null);
    }, 600);
  };

  return (
    <div className="space-y-4">
      {/* Header */}
      <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-4 flex items-center justify-between">
        <div className="flex items-center gap-2.5">
          <div className="w-9 h-9 rounded-xl bg-indigo-500/20 border border-indigo-500/30 flex items-center justify-center text-indigo-400">
            <Lock className="w-5 h-5" />
          </div>
          <div>
            <h3 className="text-sm font-bold text-white">Quarantine Security Vault</h3>
            <p className="text-[11px] text-slate-400">
              Isolated binaries rendered harmless in encrypted sandbox
            </p>
          </div>
        </div>

        {quarantined.length > 0 && (
          <button
            onClick={onEmptyVault}
            className="px-2.5 py-1.5 rounded-lg bg-rose-500/20 hover:bg-rose-500/30 text-rose-300 border border-rose-500/30 text-xs font-bold transition flex items-center gap-1"
          >
            <Trash2 className="w-3.5 h-3.5" />
            Shred All
          </button>
        )}
      </div>

      {quarantined.length === 0 ? (
        <div className="p-8 rounded-2xl bg-slate-950/60 border border-slate-800/80 text-center flex flex-col items-center justify-center space-y-2">
          <div className="w-12 h-12 rounded-full bg-emerald-500/10 border border-emerald-500/20 flex items-center justify-center text-emerald-400">
            <ShieldCheck className="w-6 h-6" />
          </div>
          <h4 className="text-xs font-bold text-white">Quarantine Vault is Empty</h4>
          <p className="text-[11px] text-slate-400 max-w-xs">
            No dangerous malware payloads are currently isolated. Any threats detected during scans will be safely caged here.
          </p>
        </div>
      ) : (
        <div className="space-y-2.5">
          {quarantined.map((item) => (
            <motion.div
              key={item.id}
              initial={{ opacity: 1 }}
              exit={{ opacity: 0, scale: 0.9 }}
              className={`p-3.5 rounded-2xl bg-slate-900 border border-slate-800 space-y-2 transition-all ${
                shreddingId === item.id ? 'opacity-40 scale-95' : ''
              }`}
            >
              <div className="flex items-start justify-between gap-2">
                <div>
                  <div className="flex items-center gap-2">
                    <span className="px-1.5 py-0.2 rounded text-[9px] font-black uppercase tracking-wider bg-rose-500/20 text-rose-400">
                      {item.type}
                    </span>
                    <h4 className="text-xs font-bold text-white">{item.name}</h4>
                  </div>
                  <p className="text-[10px] font-mono text-slate-400 truncate max-w-xs mt-1">
                    {item.targetPath}
                  </p>
                </div>

                <div className="flex items-center gap-1.5">
                  <button
                    onClick={() => onRestoreThreat(item.id)}
                    title="Restore file"
                    className="p-1.5 rounded-lg bg-slate-800 hover:bg-slate-700 text-slate-300 text-xs transition"
                  >
                    <RotateCcw className="w-3.5 h-3.5" />
                  </button>
                  <button
                    onClick={() => handleShred(item.id)}
                    title="Secure shred"
                    className="p-1.5 rounded-lg bg-rose-600 hover:bg-rose-500 text-white text-xs transition flex items-center gap-1"
                  >
                    <Trash2 className="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>

              {item.sha256 && (
                <div className="text-[10px] font-mono text-slate-500 truncate bg-slate-950 px-2 py-1 rounded border border-slate-800/80">
                  SHA-256: {item.sha256}
                </div>
              )}
            </motion.div>
          ))}
        </div>
      )}
    </div>
  );
};

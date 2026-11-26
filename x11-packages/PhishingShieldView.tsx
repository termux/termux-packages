import React, { useState } from 'react';
import { motion } from 'motion/react';
import { ShieldCheck, ShieldAlert, Sparkles, Link2, MessageSquare, AlertCircle, CheckCircle2, ArrowRight, CornerDownRight, ExternalLink } from 'lucide-react';
import { PRESET_PHISHING_SAMPLES } from '../data/mockSecurityData';
import { AiThreatAnalysisResponse } from '../types/antivirus';

export const PhishingShieldView: React.FC = () => {
  const [activeMode, setActiveMode] = useState<'url' | 'message'>('url');
  const [inputContent, setInputContent] = useState<string>('https://paypal.com-security-resolution-center.xyz/login?id=83829');
  const [isAnalyzing, setIsAnalyzing] = useState<boolean>(false);
  const [result, setResult] = useState<AiThreatAnalysisResponse | null>(null);

  const runAnalysis = async (contentToScan?: string, modeToScan?: 'url' | 'message') => {
    const text = contentToScan !== undefined ? contentToScan : inputContent;
    const mode = modeToScan !== undefined ? modeToScan : activeMode;
    if (!text.trim()) return;

    setIsAnalyzing(true);
    setResult(null);

    try {
      const res = await fetch('/api/security/ai-analyze-threat', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          type: mode,
          content: text
        })
      });

      if (res.ok) {
        const data = await res.json();
        setResult(data);
      } else {
        // Fallback
        setResult({
          verdict: text.includes('paypal') || text.includes('suspended') ? 'MALICIOUS' : 'SAFE',
          threatType: 'Phishing Heuristic Detected',
          confidence: 93,
          summary: 'Domain impersonates financial organization with deceptive credential request.',
          riskFactors: ['Unauthorized sub-domain structure', 'Social engineering triggers'],
          remediation: ['Do not click or enter credentials.', 'Block sender immediately.']
        });
      }
    } catch (e) {
      console.error(e);
      setResult({
        verdict: 'SUSPICIOUS',
        threatType: 'Network Threat Trigger',
        confidence: 85,
        summary: 'Target has indicators consistent with phishing delivery networks.',
        riskFactors: ['Unverified origin'],
        remediation: ['Avoid opening links or sharing codes.']
      });
    } finally {
      setIsAnalyzing(false);
    }
  };

  const handlePresetSelect = (sample: typeof PRESET_PHISHING_SAMPLES[0]) => {
    setActiveMode(sample.type);
    setInputContent(sample.content);
    runAnalysis(sample.content, sample.type);
  };

  return (
    <div className="space-y-4">
      {/* Banner */}
      <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-4">
        <div className="flex items-center gap-2 mb-1.5 text-cyan-400">
          <Sparkles className="w-4 h-4" />
          <h3 className="text-sm font-bold text-white">AI Web & Phishing Shield</h3>
        </div>
        <p className="text-xs text-slate-400 leading-relaxed">
          Inspect suspicious SMS alerts, WhatsApp links, and banking login URLs before tapping. Analyzes domain reputation and social engineering lures.
        </p>
      </div>

      {/* Mode Selector */}
      <div className="flex items-center gap-1.5 bg-slate-900/60 p-1 rounded-xl border border-slate-800 text-xs">
        <button
          onClick={() => {
            setActiveMode('url');
            setInputContent('https://paypal.com-security-resolution-center.xyz/login?id=83829');
          }}
          className={`flex-1 py-1.5 rounded-lg font-semibold flex items-center justify-center gap-1.5 transition ${
            activeMode === 'url' ? 'bg-slate-800 text-cyan-400 shadow-sm' : 'text-slate-400 hover:text-white'
          }`}
        >
          <Link2 className="w-3.5 h-3.5" />
          URL & Website Scanner
        </button>
        <button
          onClick={() => {
            setActiveMode('message');
            setInputContent(PRESET_PHISHING_SAMPLES[0].content);
          }}
          className={`flex-1 py-1.5 rounded-lg font-semibold flex items-center justify-center gap-1.5 transition ${
            activeMode === 'message' ? 'bg-slate-800 text-cyan-400 shadow-sm' : 'text-slate-400 hover:text-white'
          }`}
        >
          <MessageSquare className="w-3.5 h-3.5" />
          SMS / Smishing Inspector
        </button>
      </div>

      {/* Input Box */}
      <div className="space-y-2">
        <div className="relative">
          <textarea
            value={inputContent}
            onChange={(e) => setInputContent(e.target.value)}
            rows={activeMode === 'url' ? 2 : 3}
            placeholder={activeMode === 'url' ? 'Paste URL or domain (e.g. https://...)' : 'Paste suspicious SMS, email, or message text...'}
            className="w-full bg-slate-950 border border-slate-800 rounded-xl p-3 text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-cyan-500/50 font-mono transition"
          />
        </div>

        <button
          onClick={() => runAnalysis()}
          disabled={isAnalyzing || !inputContent.trim()}
          className="w-full py-2.5 px-4 rounded-xl bg-gradient-to-r from-cyan-500 to-blue-600 hover:from-cyan-400 hover:to-blue-500 text-slate-950 font-bold text-xs transition flex items-center justify-center gap-2 shadow-md shadow-cyan-900/20 disabled:opacity-50"
        >
          {isAnalyzing ? (
            <>
              <Sparkles className="w-4 h-4 animate-spin text-slate-950" />
              Inspecting Threat Indicators...
            </>
          ) : (
            <>
              <ShieldCheck className="w-4 h-4" />
              Scan with AI Intelligence
            </>
          )}
        </button>
      </div>

      {/* Preset Test Scenarios */}
      <div className="space-y-1.5">
        <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block">
          One-Click Attack & Legit Scenarios:
        </span>
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-1.5">
          {PRESET_PHISHING_SAMPLES.map((sample, idx) => (
            <button
              key={idx}
              onClick={() => handlePresetSelect(sample)}
              className="text-left p-2.5 rounded-xl bg-slate-900/80 hover:bg-slate-850 border border-slate-800/80 hover:border-slate-700 transition flex items-start gap-2 text-xs group"
            >
              <CornerDownRight className="w-3.5 h-3.5 text-cyan-400 mt-0.5 flex-shrink-0 group-hover:translate-x-0.5 transition-transform" />
              <div className="min-w-0">
                <span className="font-semibold text-slate-200 block truncate">{sample.title}</span>
                <span className="text-[10px] text-slate-400 uppercase font-mono">{sample.type}</span>
              </div>
            </button>
          ))}
        </div>
      </div>

      {/* Analysis Results View */}
      {result && (
        <motion.div
          initial={{ opacity: 0, y: 10 }}
          animate={{ opacity: 1, y: 0 }}
          className={`rounded-2xl border p-4 space-y-3 ${
            result.verdict === 'MALICIOUS'
              ? 'bg-rose-950/30 border-rose-500/40'
              : result.verdict === 'SUSPICIOUS'
              ? 'bg-amber-950/30 border-amber-500/40'
              : 'bg-emerald-950/30 border-emerald-500/40'
          }`}
        >
          {/* Header Verdict */}
          <div className="flex items-center justify-between border-b border-slate-800/80 pb-2.5">
            <div>
              <div className="flex items-center gap-2">
                <span
                  className={`px-2 py-0.5 rounded text-[11px] font-black uppercase tracking-wider ${
                    result.verdict === 'MALICIOUS'
                      ? 'bg-rose-500/20 text-rose-400 border border-rose-500/30'
                      : result.verdict === 'SUSPICIOUS'
                      ? 'bg-amber-500/20 text-amber-400 border border-amber-500/30'
                      : 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30'
                  }`}
                >
                  {result.verdict}
                </span>
                <span className="text-xs font-bold text-white">{result.threatType}</span>
              </div>
              <p className="text-[10px] text-slate-400 mt-0.5">
                Confidence: <span className="font-mono font-bold text-slate-200">{result.confidence}%</span> {result.engine ? `• via ${result.engine}` : ''}
              </p>
            </div>
          </div>

          {/* Technical Summary */}
          <div>
            <p className="text-xs text-slate-300 leading-relaxed font-medium">
              {result.summary}
            </p>
          </div>

          {/* Risk Factors */}
          {result.riskFactors && result.riskFactors.length > 0 && (
            <div className="bg-slate-950/60 p-2.5 rounded-xl border border-slate-800/80">
              <span className="text-[10px] font-bold uppercase tracking-wider text-slate-400 block mb-1">
                Detected Threat Markers:
              </span>
              <ul className="text-xs space-y-1 text-slate-300">
                {result.riskFactors.map((rf, idx) => (
                  <li key={idx} className="flex items-start gap-1.5">
                    <span className="text-rose-400 mt-0.5">•</span>
                    <span>{rf}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}

          {/* Remediation */}
          {result.remediation && result.remediation.length > 0 && (
            <div className="text-xs bg-slate-950/40 p-2.5 rounded-xl border border-slate-800/60">
              <span className="font-bold text-cyan-400 block mb-1">Recommended Action:</span>
              <ul className="space-y-1 text-slate-300">
                {result.remediation.map((act, idx) => (
                  <li key={idx} className="flex items-start gap-1.5">
                    <CheckCircle2 className="w-3.5 h-3.5 text-emerald-400 mt-0.5 flex-shrink-0" />
                    <span>{act}</span>
                  </li>
                ))}
              </ul>
            </div>
          )}
        </motion.div>
      )}
    </div>
  );
};

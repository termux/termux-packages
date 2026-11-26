import React, { useState } from 'react';
import { motion } from 'motion/react';
import { Bot, Send, Sparkles, User, ShieldCheck, HelpCircle } from 'lucide-react';

interface AiSecurityAdvisorProps {
  threatCount: number;
  isWifiSecure: boolean;
}

interface Message {
  sender: 'user' | 'ai';
  text: string;
}

export const AiSecurityAdvisor: React.FC<AiSecurityAdvisorProps> = ({
  threatCount,
  isWifiSecure
}) => {
  const [messages, setMessages] = useState<Message[]>([
    {
      sender: 'ai',
      text: `Hello! I am Aegis AI, your mobile cyber defense specialist. Your system currently has ${threatCount > 0 ? `${threatCount} high-risk threat(s)` : '0 detected threats'} and Wi-Fi protection is ${isWifiSecure ? 'active' : 'unsecured'}. How can I assist with your mobile security today?`
    }
  ]);
  const [input, setInput] = useState<string>('');
  const [isLoading, setIsLoading] = useState<boolean>(false);

  const quickPrompts = [
    'Is Accessibility Service dangerous?',
    'How do banking trojans steal OTPs?',
    'Signs of hidden spyware on mobile?',
    'Should I turn off Developer Options?'
  ];

  const handleSend = async (queryText?: string) => {
    const textToSend = queryText || input;
    if (!textToSend.trim() || isLoading) return;

    const userMsg: Message = { sender: 'user', text: textToSend };
    setMessages((prev) => [...prev, userMsg]);
    setInput('');
    setIsLoading(true);

    try {
      const res = await fetch('/api/security/ai-chat-advisor', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          query: textToSend,
          context: {
            threatsFound: threatCount,
            wifiSecure: isWifiSecure,
            os: 'Android 15 / Security Patch 2026'
          }
        })
      });

      if (res.ok) {
        const data = await res.json();
        setMessages((prev) => [...prev, { sender: 'ai', text: data.reply || 'Analysis complete.' }]);
      } else {
        setMessages((prev) => [
          ...prev,
          {
            sender: 'ai',
            text: 'Ensure unknown sources are disabled in settings and audit apps with overlay permissions.'
          }
        ]);
      }
    } catch (e) {
      setMessages((prev) => [
        ...prev,
        {
          sender: 'ai',
          text: 'Regularly audit app permissions and never share one-time passcodes over SMS.'
        }
      ]);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="space-y-3 flex flex-col h-[520px]">
      {/* Header */}
      <div className="bg-slate-900/90 border border-slate-800 rounded-2xl p-3.5 flex items-center justify-between">
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-xl bg-cyan-500/20 border border-cyan-500/30 flex items-center justify-center text-cyan-400">
            <Bot className="w-4 h-4" />
          </div>
          <div>
            <h3 className="text-xs font-bold text-white flex items-center gap-1.5">
              Aegis Cyber AI Advisor
              <span className="w-2 h-2 rounded-full bg-emerald-400 animate-pulse" />
            </h3>
            <p className="text-[10px] text-slate-400">Powered by Gemini Threat Intelligence</p>
          </div>
        </div>
      </div>

      {/* Chat Messages */}
      <div className="flex-1 bg-slate-950/80 border border-slate-800/80 rounded-2xl p-3.5 overflow-y-auto space-y-3 text-xs">
        {messages.map((m, idx) => (
          <div
            key={idx}
            className={`flex items-start gap-2 ${
              m.sender === 'user' ? 'justify-end' : 'justify-start'
            }`}
          >
            {m.sender === 'ai' && (
              <div className="w-6 h-6 rounded-lg bg-cyan-500/20 text-cyan-400 flex items-center justify-center flex-shrink-0 mt-0.5">
                <Bot className="w-3.5 h-3.5" />
              </div>
            )}
            <div
              className={`p-3 rounded-2xl max-w-[85%] leading-relaxed ${
                m.sender === 'user'
                  ? 'bg-cyan-600 text-white rounded-br-none shadow-sm'
                  : 'bg-slate-900 border border-slate-800 text-slate-200 rounded-bl-none'
              }`}
            >
              {m.text}
            </div>
            {m.sender === 'user' && (
              <div className="w-6 h-6 rounded-lg bg-slate-800 text-slate-300 flex items-center justify-center flex-shrink-0 mt-0.5">
                <User className="w-3.5 h-3.5" />
              </div>
            )}
          </div>
        ))}

        {isLoading && (
          <div className="flex items-center gap-2 text-slate-400 text-xs">
            <Bot className="w-4 h-4 text-cyan-400 animate-bounce" />
            <span>Consulting cyber threat intelligence...</span>
          </div>
        )}
      </div>

      {/* Suggested chips */}
      <div className="flex gap-1.5 overflow-x-auto pb-1 text-[11px] no-scrollbar">
        {quickPrompts.map((prompt, i) => (
          <button
            key={i}
            onClick={() => handleSend(prompt)}
            className="px-2.5 py-1 rounded-full bg-slate-900 hover:bg-slate-850 border border-slate-800 text-slate-300 hover:text-white whitespace-nowrap transition"
          >
            {prompt}
          </button>
        ))}
      </div>

      {/* Input Bar */}
      <div className="flex items-center gap-2 pt-1">
        <input
          type="text"
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === 'Enter') handleSend();
          }}
          placeholder="Ask security advisor anything..."
          className="flex-1 bg-slate-950 border border-slate-800 rounded-xl px-3 py-2.5 text-xs text-slate-200 placeholder-slate-500 focus:outline-none focus:border-cyan-500/50"
        />
        <button
          onClick={() => handleSend()}
          disabled={!input.trim() || isLoading}
          className="p-2.5 rounded-xl bg-cyan-500 hover:bg-cyan-400 text-slate-950 font-bold transition disabled:opacity-40"
        >
          <Send className="w-4 h-4" />
        </button>
      </div>
    </div>
  );
};

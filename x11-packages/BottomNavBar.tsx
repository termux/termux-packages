import React from 'react';
import { Shield, Smartphone, Globe, Trash2, Bot } from 'lucide-react';

export type ActiveTab = 'dashboard' | 'apps' | 'network' | 'cleaner' | 'advisor';

interface BottomNavBarProps {
  activeTab: ActiveTab;
  setActiveTab: (tab: ActiveTab) => void;
  threatCount: number;
}

export const BottomNavBar: React.FC<BottomNavBarProps> = ({
  activeTab,
  setActiveTab,
  threatCount
}) => {
  const navItems: { id: ActiveTab; label: string; icon: React.FC<{ className?: string }>; badge?: number }[] = [
    { id: 'dashboard', label: 'Security', icon: Shield, badge: threatCount > 0 ? threatCount : undefined },
    { id: 'apps', label: 'App Audit', icon: Smartphone },
    { id: 'network', label: 'Net & Web', icon: Globe },
    { id: 'cleaner', label: 'Storage', icon: Trash2 },
    { id: 'advisor', label: 'AI Advisor', icon: Bot },
  ];

  return (
    <nav className="w-full bg-slate-950/95 backdrop-blur-lg border-t border-slate-800/80 px-2 py-2 sticky bottom-0 z-30">
      <div className="flex items-center justify-around max-w-lg mx-auto">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = activeTab === item.id;
          return (
            <button
              key={item.id}
              onClick={() => setActiveTab(item.id)}
              className={`relative flex flex-col items-center justify-center py-1 px-2.5 rounded-xl transition-all duration-200 ${
                isActive
                  ? 'text-cyan-400 font-semibold'
                  : 'text-slate-400 hover:text-slate-200 font-medium'
              }`}
            >
              <div className="relative">
                <Icon
                  className={`w-5 h-5 transition-transform ${
                    isActive ? 'scale-110 stroke-[2.2]' : 'scale-100 stroke-[1.8]'
                  }`}
                />
                {item.badge !== undefined && item.badge > 0 && (
                  <span className="absolute -top-1.5 -right-2.5 flex items-center justify-center min-w-[16px] h-4 px-1 rounded-full bg-rose-500 text-white text-[9px] font-extrabold shadow-sm animate-bounce">
                    {item.badge}
                  </span>
                )}
              </div>
              <span className={`text-[10px] mt-1 tracking-tight ${isActive ? 'text-cyan-400' : 'text-slate-400'}`}>
                {item.label}
              </span>
              {isActive && (
                <div className="w-4 h-0.5 bg-cyan-400 rounded-full mt-0.5 shadow-[0_0_8px_rgba(34,211,238,0.8)]" />
              )}
            </button>
          );
        })}
      </div>
    </nav>
  );
};

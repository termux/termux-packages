import { AppAuditItem, ThreatItem, NetworkSecurityReport, StorageCleanSummary } from '../types/antivirus';

export const INITIAL_THREATS: ThreatItem[] = [
  {
    id: 'th-1',
    name: 'Android.Banker.SharkBot.Dropper',
    type: 'trojan',
    severity: 'critical',
    targetPath: '/storage/emulated/0/Download/Update_Flash_Player_v14.apk',
    detectionSource: 'Aegis Signature Engine v2026.09',
    description: 'Deceptive installer attempting to harvest Accessibility Services and overlay fake login interfaces across banking apps.',
    status: 'active',
    discoveredAt: '10 mins ago',
    sha256: '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08'
  },
  {
    id: 'th-2',
    name: 'Adware.AndroidOS.HiddenAds.gen',
    type: 'adware',
    severity: 'high',
    targetPath: '/data/app/com.battery.superbooster.fast-1/base.apk',
    detectionSource: 'Heuristic Behavioral Guard',
    description: 'Background app aggressively spawns non-dismissible full-screen ads, intercepts clipboard data, and attempts battery draining persistence.',
    status: 'active',
    discoveredAt: '1 hour ago',
    sha256: 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
  },
  {
    id: 'th-3',
    name: 'Spyware.SMSForwarder.Heuristic',
    type: 'spyware',
    severity: 'critical',
    targetPath: '/data/data/com.sys.carrier.service.sync/lib/libsync.so',
    detectionSource: 'Static Behavioral Sandbox',
    description: 'Unauthorized package monitors incoming 2FA verification SMS codes and relays telemetry to an unverified C2 endpoint.',
    status: 'active',
    discoveredAt: 'Yesterday',
    sha256: '5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8'
  }
];

export const INITIAL_APPS: AppAuditItem[] = [
  {
    id: 'app-1',
    packageName: 'com.battery.superbooster.fast',
    appName: 'Super Battery Booster 2026',
    category: 'sideloaded',
    riskScore: 88,
    isSideloaded: true,
    version: '4.1.2',
    installDate: '3 days ago',
    permissions: [
      { name: 'SYSTEM_ALERT_WINDOW', description: 'Draw over other applications (Screen overlay)', isHighRisk: true, granted: true },
      { name: 'BIND_ACCESSIBILITY_SERVICE', description: 'Inspect screen contents & keystrokes', isHighRisk: true, granted: true },
      { name: 'ACCESS_FINE_LOCATION', description: 'Continuous background GPS tracking', isHighRisk: true, granted: true },
      { name: 'RECEIVE_BOOT_COMPLETED', description: 'Launch immediately on device startup', isHighRisk: false, granted: true }
    ]
  },
  {
    id: 'app-2',
    packageName: 'com.quickcrypto.trade.wallet',
    appName: 'FastCrypto Daily Staker',
    category: 'sideloaded',
    riskScore: 74,
    isSideloaded: true,
    version: '1.0.8',
    installDate: '5 days ago',
    permissions: [
      { name: 'READ_EXTERNAL_STORAGE', description: 'Access photos and documents', isHighRisk: true, granted: true },
      { name: 'READ_CLIPBOARD', description: 'Inspect copied seed phrases and addresses', isHighRisk: true, granted: true },
      { name: 'INTERNET', description: 'Unrestricted network communication', isHighRisk: false, granted: true }
    ]
  },
  {
    id: 'app-3',
    packageName: 'org.telegram.messenger',
    appName: 'Telegram',
    category: 'social',
    riskScore: 18,
    isSideloaded: false,
    version: '10.12.0',
    installDate: '3 months ago',
    permissions: [
      { name: 'CAMERA', description: 'Take photos and videos for messages', isHighRisk: true, granted: true },
      { name: 'RECORD_AUDIO', description: 'Record voice messages and calls', isHighRisk: true, granted: true },
      { name: 'READ_CONTACTS', description: 'Sync mobile contacts', isHighRisk: true, granted: true }
    ]
  },
  {
    id: 'app-4',
    packageName: 'com.chase.sig.android',
    appName: 'Chase Mobile',
    category: 'finance',
    riskScore: 5,
    isSideloaded: false,
    version: '4.380.0',
    installDate: '6 months ago',
    permissions: [
      { name: 'USE_BIOMETRIC', description: 'Fingerprint & Face biometric unlock', isHighRisk: false, granted: true },
      { name: 'CAMERA', description: 'Mobile check deposit scan', isHighRisk: false, granted: true }
    ]
  },
  {
    id: 'app-5',
    packageName: 'com.adobe.reader',
    appName: 'Adobe Acrobat Reader',
    category: 'tools',
    riskScore: 12,
    isSideloaded: false,
    version: '24.1.0',
    installDate: '2 months ago',
    permissions: [
      { name: 'READ_EXTERNAL_STORAGE', description: 'Open local PDF files', isHighRisk: true, granted: true },
      { name: 'WRITE_EXTERNAL_STORAGE', description: 'Save edited PDF documents', isHighRisk: false, granted: true }
    ]
  }
];

export const SCAN_PATHS_STREAM: string[] = [
  '/system/bin/app_process64',
  '/system/framework/framework.jar',
  '/system/lib64/libbinder.so',
  '/data/app/com.battery.superbooster.fast-1/base.apk',
  '/data/app/com.quickcrypto.trade.wallet/base.apk',
  '/data/dalvik-cache/x86_64/system@framework@boot.art',
  '/storage/emulated/0/Download/Update_Flash_Player_v14.apk',
  '/storage/emulated/0/DCIM/.thumbnails/temp_cache.bin',
  '/storage/emulated/0/Android/data/com.suspicious.sync/cache',
  '/data/system/users/0/package-restrictions.xml',
  '/data/data/com.sys.carrier.service.sync/lib/libsync.so',
  '/system/etc/security/cacerts/wpa_supplicant.conf',
  '/sdcard/WhatsApp/Media/.temp_keys.db',
  '/storage/emulated/0/Download/bank_statement_signed.pdf'
];

export const INITIAL_NETWORK_REPORT: NetworkSecurityReport = {
  ssid: 'Airport_Guest_HighSpeed_Free',
  bssid: '88:DE:A9:3F:11:02',
  ip: '192.168.43.118',
  protocol: 'Open / Insecure',
  signalStrength: 82,
  dnsServer: '192.168.43.1 (Unencrypted)',
  dnsEncrypted: false,
  arpSpoofDetected: true,
  mitmProtection: false,
  sslInspectionRisk: true,
  vpnActive: false,
  dataLeakShield: false,
  securityRating: 'VULNERABLE'
};

export const INITIAL_STORAGE_CLEAN: StorageCleanSummary = {
  systemCacheMb: 840,
  residualFilesMb: 620,
  tempApkMb: 215,
  duplicateCacheMb: 430,
  ramFreeableMb: 1120,
  totalCleanableMb: 2105, // ~2.1 GB
  isCleaned: false
};

export const PRESET_PHISHING_SAMPLES = [
  {
    title: 'Chase Bank Account Suspended',
    type: 'message' as const,
    content: 'CHASE ALERT: Your checking debit card has been suspended due to unusual activity. To restore access immediately within 24h, verify credentials at http://chase-secure-verification.top/auth'
  },
  {
    title: 'PayPal Unauthorized Transfer',
    type: 'url' as const,
    content: 'https://paypal.com-security-resolution-center.xyz/login?id=83829'
  },
  {
    title: 'USPS Delivery Fee Pending',
    type: 'message' as const,
    content: 'USPS tracking #US9405: Your parcel delivery is held at terminal due to unpaid custom duty ($1.85). Visit https://usps-post-redelivery.work/pay before shipment is returned.'
  },
  {
    title: 'Legitimate Google Security Notice',
    type: 'message' as const,
    content: 'Google verification code: 829104. Use this to complete your 2-step verification. Do not share this code with anyone.'
  }
];

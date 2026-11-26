import express from "express";
import path from "path";
import { fileURLToPath } from "url";
import { createServer as createViteServer } from "vite";
import { GoogleGenAI } from "@google/genai";
import dotenv from "dotenv";

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

let genAIClient: GoogleGenAI | null = null;
function getGenAI(): GoogleGenAI | null {
  if (!genAIClient && process.env.GEMINI_API_KEY) {
    genAIClient = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });
  }
  return genAIClient;
}

// Fallback heuristic analyzer for URLs and Messages if Gemini API is unreachable or offline
function analyzeHeuristic(type: string, content: string) {
  const lower = content.toLowerCase();

  if (type === "url") {
    const isSuspiciousTLD = /\.(xyz|top|work|click|country|gq|cf|tk|loan|zip|download)$/i.test(content);
    const hasIPAddress = /(https?:\/\/)?(\d{1,3}\.){3}\d{1,3}/.test(content);
    const hasSpoofBrand = /(paypal|apple|google|netflix|amazon|bank|chase|wellsfargo|binance|crypto|secure-login)/i.test(content) &&
      !/(paypal\.com|apple\.com|google\.com|netflix\.com|amazon\.com|chase\.com|wellsfargo\.com|binance\.com)/i.test(content);
    const hasPhishKeywords = /(login|verify|update-account|wallet-sync|claim-reward|airdrop|free-bonus)/i.test(lower);

    if (hasSpoofBrand || (isSuspiciousTLD && hasPhishKeywords) || (hasIPAddress && hasPhishKeywords)) {
      return {
        verdict: "MALICIOUS",
        threatType: "Phishing & Credential Harvester",
        confidence: 94,
        summary: "High-risk URL detected mimicking trusted institutions with suspicious domain structure and credential harvesting triggers.",
        riskFactors: [
          hasSpoofBrand ? "Brand impersonation attempt detected" : "Suspicious top-level domain frequently used in phishing campaigns",
          hasPhishKeywords ? "Deceptive action triggers (account verification/login prompts)" : "Unverified domain routing",
          hasIPAddress ? "Direct raw IP access bypasses DNS reputation filters" : "Non-standard SSL/domain structure"
        ],
        remediation: [
          "Do not click the link or enter sensitive credentials.",
          "Block this sender and domain on your device.",
          "Clear your browser cookies and active cache if visited."
        ]
      };
    } else if (isSuspiciousTLD || hasPhishKeywords) {
      return {
        verdict: "SUSPICIOUS",
        threatType: "Potentially Unwanted / Deceptive Link",
        confidence: 76,
        summary: "This link contains indicators common in promotional spam and misleading redirect campaigns.",
        riskFactors: [
          "Uncommon domain extension or URL shortener redirect",
          "Potential deceptive promotional landing page"
        ],
        remediation: [
          "Avoid downloading APKs or executables from this website.",
          "Ensure your mobile browser secure browsing mode is enabled."
        ]
      };
    }

    return {
      verdict: "SAFE",
      threatType: "Clean",
      confidence: 91,
      summary: "No immediate malicious patterns, credential theft hooks, or known malware delivery vectors found.",
      riskFactors: ["Standard domain structure verified"],
      remediation: ["Domain appears legitimate. Maintain standard security hygiene."]
    };
  } else if (type === "message") {
    const hasUrgency = /(urgent|immediate action required|suspended|locked out|within 24 hours|warrant|arrest|legal action)/i.test(lower);
    const hasFinancialLure = /(won|lottery|prize|refund|crypto deposit|transfer pending|\$|\€|\£|tax refund|irs)/i.test(lower);
    const hasAuthTrigger = /(otp|2fa|verification code|password reset|verify your identity|click here to confirm)/i.test(lower);
    const hasLink = /(https?:\/\/|bit\.ly|t\.co|tinyurl|is\.gd|cutt\.ly)/i.test(lower);

    if ((hasUrgency && hasLink) || (hasFinancialLure && hasLink) || (hasAuthTrigger && hasLink)) {
      return {
        verdict: "MALICIOUS",
        threatType: "Smishing (SMS Phishing) / Social Engineering",
        confidence: 95,
        summary: "Detected classic SMS phishing/social engineering bait designed to induce panic or greed into tapping unauthorized links.",
        riskFactors: [
          hasUrgency ? "Artificial urgency cues designed to bypass critical judgment" : "Financial lure / unauthorized reward claim",
          hasAuthTrigger ? "Targeting authentication credentials or one-time passcodes" : "Deceptive call-to-action",
          hasLink ? "Embedded external redirect link" : "Unverified communication origin"
        ],
        remediation: [
          "Do not tap any links or reply to the sender.",
          "Never share SMS verification codes or two-factor pins.",
          "Report this number as spam and block immediately."
        ]
      };
    } else if (hasUrgency || hasFinancialLure) {
      return {
        verdict: "SUSPICIOUS",
        threatType: "Unsolicited Marketing / Low-Trust Hook",
        confidence: 72,
        summary: "Unsolicited notification with commercial or unsolicited clickbait language.",
        riskFactors: ["Unverified notification pattern", "High emotional trigger language"],
        remediation: ["Verify the sender's identity through official channels directly."]
      };
    }

    return {
      verdict: "SAFE",
      threatType: "Clean",
      confidence: 88,
      summary: "No deceptive coercion, smishing hooks, or fraudulent payload triggers detected in this text.",
      riskFactors: [],
      remediation: ["Message looks standard. Exercise normal mobile awareness."]
    };
  } else {
    // App permission / package heuristic
    const highRiskPerms = /(bind_accessibility_service|system_alert_window|request_install_packages|read_sms|send_sms|record_audio|camera|access_fine_location)/i.test(lower);
    const overlayRisk = /(system_alert_window|draw_over_other_apps)/i.test(lower);
    const accessibilityRisk = /bind_accessibility_service/i.test(lower);

    if (overlayRisk && accessibilityRisk) {
      return {
        verdict: "MALICIOUS",
        threatType: "Banking Trojan / Screen Stealer Combination",
        confidence: 96,
        summary: "Critical combination: Accessibility Service + Window Overlay allows malware to record keystrokes, capture OTPs, and perform unauthorized touch events.",
        riskFactors: [
          "Accessibility Service can intercept keystrokes and screen contents",
          "System Alert Window enables invisible overlay screens over banking apps",
          "Automated background interaction capability"
        ],
        remediation: [
          "Uninstall this application immediately.",
          "Revoke Accessibility and Display Over Other Apps permissions in Android Settings."
        ]
      };
    } else if (highRiskPerms) {
      return {
        verdict: "SUSPICIOUS",
        threatType: "Elevated Privilege Threat",
        confidence: 78,
        summary: "The application requests permissions capable of accessing sensitive hardware, location, or private communications.",
        riskFactors: ["Demands background access to private sensor or messaging subsystems"],
        remediation: ["Inspect whether the app genuinely requires these permissions to function."]
      };
    }

    return {
      verdict: "SAFE",
      threatType: "Standard Mobile Permissions",
      confidence: 90,
      summary: "Permission footprint aligns with normal mobile application standards.",
      riskFactors: [],
      remediation: ["No malicious permission combinations observed."]
    };
  }
}

async function startServer() {
  const app = express();
  const PORT = 3000;

  app.use(express.json({ limit: "10mb" }));

  // Health check
  app.get("/api/health", (_req, res) => {
    res.json({ status: "ok", timestamp: new Date().toISOString() });
  });

  // Threat Analysis Endpoint
  app.post("/api/security/ai-analyze-threat", async (req, res) => {
    try {
      const { type, content } = req.body;
      if (!content || typeof content !== "string") {
        return res.status(400).json({ error: "Missing or invalid content to analyze." });
      }

      const genAI = getGenAI();

      if (genAI) {
        try {
          const prompt = `You are a world-class mobile cyber threat intelligence and antivirus engine.
Analyze the following mobile security target:
Type: ${type}
Target Content: "${content}"

Analyze for phishing, mobile trojans (like Flubot, Joker, Anatsa, SharkBot), smishing, fake updates, credential theft, or unauthorized privacy violations.
Return STRICTLY a JSON object with this schema and no markdown formatting around it:
{
  "verdict": "SAFE" | "SUSPICIOUS" | "MALICIOUS",
  "threatType": "Short category description, e.g., Banking Trojan, Phishing Scam, Clean",
  "confidence": number from 50 to 99,
  "summary": "2 concise sentences explaining the technical threat analysis",
  "riskFactors": ["Specific indicator 1", "Specific indicator 2"],
  "remediation": ["Action step 1", "Action step 2"]
}`;

          const result = await genAI.models.generateContent({
            model: "gemini-3.8-flash",
            contents: prompt,
          });

          const rawText = result.text?.trim() || "";
          const cleanedText = rawText.replace(/```json/g, "").replace(/```/g, "").trim();
          const parsed = JSON.parse(cleanedText);
          return res.json({ ...parsed, engine: "gemini-3.8-flash" });
        } catch (apiErr) {
          console.warn("Gemini API call failed, falling back to heuristic engine:", apiErr);
        }
      }

      // Heuristic fallback
      const fallbackResult = analyzeHeuristic(type || "url", content);
      return res.json({ ...fallbackResult, engine: "heuristic-shield" });
    } catch (err: any) {
      console.error("Analysis error:", err);
      res.status(500).json({ error: err.message || "Threat analysis failed" });
    }
  });

  // AI Security Advisor Chat
  app.post("/api/security/ai-chat-advisor", async (req, res) => {
    try {
      const { query, context } = req.body;
      if (!query) {
        return res.status(400).json({ error: "Query is required" });
      }

      const genAI = getGenAI();
      if (genAI) {
        try {
          const prompt = `You are Aegis AI, an advanced mobile cybersecurity specialist and antivirus advisor.
Provide crisp, authoritative, friendly, and directly actionable security advice.
User question: "${query}"
Current device context: ${JSON.stringify(context || {})}
Keep response between 2 and 4 sentences. Focus on mobile defense: permissions, malware removal, safe browsing, Wi-Fi hygiene, or device protection.`;

          const result = await genAI.models.generateContent({
            model: "gemini-3.8-flash",
            contents: prompt,
          });

          return res.json({
            reply: result.text?.trim(),
            engine: "gemini-3.8-flash"
          });
        } catch (e) {
          console.warn("Gemini chat advisor failed, using fallback:", e);
        }
      }

      // Fallback helpful responses
      const q = (query as string).toLowerCase();
      let reply = "Ensure you only install applications from verified repositories, audit sensitive permissions regularly (like Accessibility and Screen Overlay), and avoid connecting to unencrypted public Wi-Fi without a secure VPN.";
      if (q.includes("permission") || q.includes("accessibility")) {
        reply = "Accessibility and Display Over Apps are the two highest-risk permissions on mobile. Malicious trojans use them to read two-factor OTPs and record screen interactions. Never grant these to unknown apps.";
      } else if (q.includes("clean") || q.includes("storage") || q.includes("cache")) {
        reply = "Clearing app cache and residual temp APKs recovers storage and eliminates temporary tracking artifacts without deleting personal photos or documents.";
      } else if (q.includes("wifi") || q.includes("network")) {
        reply = "When using public or guest Wi-Fi networks, enable DNS-over-HTTPS or an encrypted VPN shield to prevent Man-in-the-Middle (MitM) packet sniffing and rogue router redirections.";
      } else if (q.includes("phish") || q.includes("sms") || q.includes("link")) {
        reply = "Never click links in unexpected SMS messages claiming your bank account is locked or a package delivery is pending. Genuine banks never request verification passwords via SMS.";
      }

      return res.json({ reply, engine: "heuristic-advisor" });
    } catch (err: any) {
      res.status(500).json({ error: err.message || "Failed to get advice" });
    }
  });

  // Vite middleware setup
  if (process.env.NODE_ENV !== "production") {
    const vite = await createViteServer({
      server: { middlewareMode: true },
      appType: "spa",
    });
    app.use(vite.middlewares);
  } else {
    const distPath = path.join(process.cwd(), "dist");
    app.use(express.static(distPath));
    app.get("*", (_req, res) => {
      res.sendFile(path.join(distPath, "index.html"));
    });
  }

  app.listen(PORT, "0.0.0.0", () => {
    console.log(`Aegis Mobile Antivirus Server running on port ${PORT}`);
  });
}

startServer();

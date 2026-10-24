const Module = require('module');
const https = require('https');
const fs = require('fs');
const path = require('path');

const configDir = process.env.CONFIG_DIRECTORY || path.join(process.env.HOME || '', '.config/seerr');
const logFile = path.join(configDir, 'logs/tmdb-retry.log');

function logRetry(msg) {
  const line = `${new Date().toISOString()} ${msg}\n`;
  try {
    fs.mkdirSync(path.dirname(logFile), { recursive: true });
    fs.appendFileSync(logFile, line);
  } catch (e) {}
}

const origRequire = Module.prototype.require;
Module.prototype.require = function (id) {
  const exp = origRequire.apply(this, arguments);

  let isExternalApi = false;
  if (typeof id === 'string') {
    if (
      id === '../externalapi' ||
      id === './externalapi' ||
      id.endsWith('/api/externalapi') ||
      id.endsWith('/api/externalapi.js')
    ) {
      isExternalApi = true;
    } else {
      try {
        const resolved = Module._resolveFilename(id, this);
        if (resolved.endsWith('/api/externalapi.js') || resolved.endsWith('/api/externalapi')) {
          isExternalApi = true;
        }
      } catch (e) {}
    }
  }

  if (
    isExternalApi &&
    exp &&
    exp.default &&
    !exp.default.__retryPatched
  ) {
    const OrigExternalAPI = exp.default;

    class PatchedExternalAPI extends OrigExternalAPI {
      constructor(baseUrl, params, options) {
        super(baseUrl, params, options);

        if (typeof baseUrl === 'string' && baseUrl.includes('api.themoviedb.org')) {
          this.axios.interceptors.response.use(
            (response) => {
              const state = response.config?.__retryState;
              if (state && state.retryCount > 0) {
                logRetry(
                  `[TMDB Retry] SUCCESS: Succeeded after ${state.retryCount} retries (${state.retryCount + 1} total attempts) for ${response.config.url}`
                );
              }
              return response;
            },
            async (error) => {
              const config = error.config;
              if (!config) return Promise.reject(error);

              // Strictly match only the handshake disconnect before request bytes were sent
              const isHandshakeError =
                !error.response &&
                error.message &&
                error.message.includes('Client network socket disconnected before secure TLS connection was established');

              if (!isHandshakeError) {
                return Promise.reject(error);
              }

              const maxAttempts = 15;
              const maxTimeoutMs = 8000;
              const now = Date.now();

              if (!config.__retryState) {
                config.__retryState = { startTime: now, retryCount: 0, oldAgents: [] };
              }
              const state = config.__retryState;

              if (state.retryCount < maxAttempts && (now - state.startTime) < maxTimeoutMs) {
                state.retryCount += 1;

                const delay = Math.floor(40 * Math.pow(1.2, state.retryCount) + Math.random() * 50);

                logRetry(
                  `[TMDB Retry] HANDSHAKE RESET: Retrying (${state.retryCount}/${maxAttempts}) in ${delay}ms for ${config.url}`
                );

                const currentAgent = config.httpsAgent;
                const isProxyAgent = currentAgent && (currentAgent.proxy || currentAgent.proxyUrl || currentAgent.constructor?.name?.includes('Proxy'));

                if (!isProxyAgent) {
                  if (currentAgent && typeof currentAgent.destroy === 'function' && state.oldAgents.includes(currentAgent)) {
                    try { currentAgent.destroy(); } catch (e) {}
                  }
                  const freshAgent = new https.Agent({ keepAlive: false });
                  state.oldAgents.push(freshAgent);
                  config.httpsAgent = freshAgent;
                }

                await new Promise((resolve) => setTimeout(resolve, delay));
                return this.axios(config);
              }

              logRetry(`[TMDB Retry] EXHAUSTED: Failed after ${state.retryCount} attempts for ${config.url}`);
              return Promise.reject(error);
            }
          );
        }
      }
    }

    PatchedExternalAPI.__retryPatched = true;
    exp.default = PatchedExternalAPI;
    logRetry(`[TMDB Retry] Successfully hooked ExternalAPI for TMDB`);
  }

  return exp;
};

const util = require('util');
const child_process = require('child_process');
const pexec = util.promisify(child_process.exec);


function bind(command, { json = false } = {}) {
  return function run(argv, options) {
    if (!options && argv && !Array.isArray(argv) && typeof argv !== 'string') {
      options = argv;
      argv = [];
    }
    const args = Object.entries(options).reduce((a, [k, v]) => {
      const key = k[0];
      if (v === true) a.push(`-${key}`);
      else a.push(`-${key} ${v}`);
      return a;
    }, []).join(' ');
    argv = Array.isArray(argv) ? argv.length ? ` ${argv.join(' ')}` : '' : ` ${argv}`.trim();
    pexec(`${command}${argv} ${args}`.trim())
      .then((ret) => {
        if (json) return { stdout: JSON.parse(ret.stdout), stderr: JSON.parse(ret.stderr) };
        return ret;
      });
  };
}

const API_COMMANDS = [
  'battery-status',
  'camera-info',
  'camera-photo',
  'clipboard-get',
  'clipboard-set',
  'contact-list',
  'dialog',
  'download',
  'infrared-frequencies',
  'infrared-transmit',
  'location',
  'notification',
  'share',
  'sms-inbox',
  'sms-send',
  'storage-get',
  'telephony-call',
  'telephony-cellinfo',
  'telephony-deviceinfo',
  'toast',
  'tts-engines',
  'tts-speak',
  'vibrate',
  'wifi-connectioninfo',
  'wifi-scaninfo',
];

module.exports.api = {};
for (const command of API_COMMANDS) {
  const props = command.split('-');
  const last = props.pop();
  let value = module.exports.api;
  for (const prop of props) {
    if (!value[prop]) value[prop] = {};
    value = value[prop];
  }
  value[last] = bind(`termux-${command}`, { json: true });
}

module.exports.wake = {
  lock: bind('termux-wake-lock'),
  unlock: bind('termux-wake-unlock'),
};

module.exports.open = bind('termux-open');
module.exports.open.url = bind('termux-open-url');

module.exports.fixShebang = bind('termux-fix-shebang');

module.exports.playAudio = bind('play-audio');

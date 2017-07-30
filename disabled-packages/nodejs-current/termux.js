const util = require('util');
const child_process = require('child_process');
const pexec = util.promisify(child_process.exec);

const exec = function exec(command, argv = [], options = {}) {
  const args = Object.entries(options).reduce((a, [k, v]) => {
    const key = k[0];
    if (v === true) a.push('-' + key);
    else a.push(`-${key} ${v}`);
    return a;
  }, []).join(' ');
  argv = Array.isArray(argv) ? argv.length ? ` ${argv.join(' ')}` : '' : ` ${argv}`;
  return pexec(`${command}${argv} ${args}`)
    .then(({ stdout, stderr }) =>
      ({ stdout: JSON.parse(stdout), stderr: JSON.parse(stderr) }));
};

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
  'telephony-cellinfo',
  'telephony-deviceinfo',
  'toast',
  'tts-engines',
  'tts-speak',
  'vibrate',
];

function bind(command) {
  return function(args, options) {
    if (!options && args && !Array.isArray(args) && typeof args !== 'string') {
      options = args;
      args = [];
    }
    return exec(command, args, options);
  }
}

module.exports.api = {};
for (const command of API_COMMANDS) {
  const props = command.split('-');
  const last = props.pop();
  let value = module.exports.api;
  for (const prop of props) {
    if (!value[prop]) value[prop] = {};
    value = value[prop];
  }
  value[last] = bind(`termux-${command}`);
}

module.exports.playAudio = bind('play-audio');

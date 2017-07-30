const util = require('util');
const child_process = require('child_process');
const pexec = util.promisify(child_process.exec);
const exec = function exec(command, args) {
  args = Object.entries(args).reduce((a, [k, v]) => {
    const key = k[0];
    if (v === true) a.push('-' + key);
    else a.push(`-${key} ${v}`);
    return a;
  }, []).join(' ');
  return pexec(`${command} ${args}`)
    .then(({ stdout, stderr }) =>
      ({ stdout: JSON.parse(stdout), stderr: JSON.parse(stderr) }));
};

const commands = [
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

for (const command of commands) {
  const props = command.split('-');
  const last = props.pop();
  let value = module.exports;
  for (const prop of props) {
    if (!value[prop]) value[prop] = {};
    value = value[prop];
  }
  value[last] = (options = {}) => exec(`termux-${command}`, options);
}

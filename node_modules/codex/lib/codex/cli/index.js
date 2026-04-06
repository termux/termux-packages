var Drip = require('drip')
  , Tea = require('tea')
  , connect = require('connect')
  , ncp = require('ncp').ncp
  , colors = require('./colors')
  , fs = require('fs')
  , path = require('path')
  , join = path.join
  , exists = path.existsSync || fs.existsSync;

var codex = require('../../codex')
  , Project = require('../project')
  , _ = require('../utils');

var log = new Tea.Logger({
    levels: 'syslog'
  , namespace: 'codex'
  , transports: [
        'console'
    ]
});


var cli = module.exports = new Drip({ delimeter: ' ' });

function pad(str, width) {
  return Array(width - str.length).join(' ') + str;
}

var help = [

  { name: 'build'
  , description: 'Render your codex.'
  , options: [
        { '-i, --in [inDir]': 'Specify the project root directory instead of [cwd].' }
      , { '-o, --out [outDir]': 'Specify the path where generated files should placed' }
      , { '-t, --template [templateDir]': 'Specify the path to use as the project template' }
      , { '-d, --data [dataDir]': 'Specify the location where project data files are located' }
    ]
  },

  // WATCH
  { name: 'watch'
  , description: 'Automatically regenerate if data or templates change.'
  , options: [
        { '-i, --in [inDir]': 'Specify the project root directory instead of [cwd].' }
      , { '-o, --out [outDir]': 'Specify the path where generated files should placed' }
      , { '-t, --template [templateDir]': 'Specify the path to use as the project template' }
      , { '-d, --data [dataDir]': 'Specify the location where project data files are located' }
      , { '-p, --port [n]': 'Specify port. Defaults to 3030.' }
      , { '-m, --mount [base]': 'Specify the folder path to mount the static server at.' }
    ]
  },

  // SERVE
  { name: 'serve'
  , description: 'Starts a static server to view the generated files.'
  , options: [
        { '-p, --port [n]': 'Specify port. Defaults to 3030.' }
      , { '-d, --dir [outDir]': 'Specify the directory to serve.' }
      , { '-m, --mount [base]': 'Specify the folder path to mount the static server at.' }
    ]
  },

  // SKELETON
  { name: 'skeleton [name]'
  , description: 'Create a skeleton site using the codex provided template'
  }
];

cli.on('--version', function () {
  console.log(codex.version);
});

cli.on('--help', function () {
  var w = 15;

  i = function (s) {
    console.log('  ' + s);
  };

  i('');
  i('CODEX HELP'.magenta);
  i('');
  i('Options Defaults');
  i('   inDir:       '.red + '[cwd]'.gray);
  i('   outDir:      '.red + '[cwd]/out'.gray);
  i('   dataDir:     '.red + '[cwd]/data'.gray);
  i('   templateDir: '.red + '[cwd]/template'.gray);
  i('');

  help.forEach(function (c) {
    i(c.description.blue);
    i(pad('', 4) + 'codex '.gray + c.name.green +
          ((c.commands) ? ' <command>'.magenta : '') +
          (c.options ?   ' <options>' :  ''));

    if (c.options) {
      c.options.forEach(function (option) {
        for (var opt in option) {
          i(pad('', 6) + opt + ' ' + option[opt].gray);
        }
      });
    }
    i('');
  });
  i('');
  process.exit();
});

cli.on('build', function (args) {
  header();
  var inDir = args.i || args.in || args.cwd
    , opts = {
          inDir: args.i || args.in || args.cwd
        , outDir: args.o || args.out || join(inDir, 'out')
        , dataDir: args.d || args.data || join(inDir, 'data')
        , templateDir: args.t || args.template || join(inDir, 'template')
      };

  for (var dir in opts) {
    if (!_.isPathAbsolute(opts[dir]))
      opts[dir] = path.resolve(args.cwd, opts[dir]);
  }

  log.info('');
  log.info('Loaded configuration...'.blue);
  logObject('info', opts);
  log.info('');

  var project = new Project(opts);

  project.on('error', function (d) {
    log.error(d.message);
    logObject('error', d.data);
    footerNotOk();
  });

  project.on('progress', function (d) {
    if (d.message) log.info(d.message.blue);
    if (d.data) logObject('info', d.data);
    if (d.array) logArray('info', d.array);
    log.info('');
  });

  project.build(function () {
    log.info('Codex build cycle complete.');
    footerOk();
  });
});

cli.on('serve', function (args) {
  header();
  var dir = args.d || args.dir || args.o || args.out;
  if (!dir) {
    dir = join(args.cwd, 'out');
  } else if (!_.isPathAbsolute(dir)) {
    dir = path.resolve(args.cwd, dir);
  }

  var app = connect()
    , port = args.p || args.port || 1227
    , mount = args.m || args.mount || '';

  app.use(mount, connect.static(dir));
  app.listen(port);
  log.info('Static server running on port ['.gray + port.toString().green + ']'.gray);
  log.info('Serving dir: ' + dir.gray);
  if (mount != '')
    log.info('on mount point:' + mount.gray);
});

cli.on('skeleton', function (args) {
  header();
  log.warn('No skeleton project name provided. See help for more info.');
  footerNot();
});

cli.on('skeleton *', function (args) {
  header();
  var dir = args._[1];
  if (!_.isPathAbsolute(dir)){
    dir = path.resolve(args.cwd, dir);
  }

  if (exists(dir)) {
    log.error('Skeleton folder already exists.');
    log.error(dir);
    footerNotOk();
  }

  ncp(join(__dirname, '..', '..', '..', 'skeleton'), dir, function (err) {
    if (err && err.length > 0) {
      log.error(err[0].message);
      footerNotOk();
    }

    log.info('Skeleton successfully created'.blue);
    log.info(dir);
    footerOk();
  });
});

cli.on('watch', function (args) {
  header();

  var inDir = args.i || args.in || args.cwd
    , opts = {
          inDir: args.i || args.in || args.cwd
        , outDir: args.o || args.out || join(inDir, 'out')
        , dataDir: args.d || args.data || join(inDir, 'data')
        , templateDir: args.t || args.template || join(inDir, 'template')
      };

  for (var dir in opts) {
    if (!_.isPathAbsolute(opts[dir]))
      opts[dir] = path.resolve(args.cwd, opts[dir]);
  }

  log.info('');
  log.info('Loaded configuration...'.blue);
  logObject('info', opts);
  log.info('');

  // simulate a serve call
  cli.emit('serve', {
    d: opts.outDir, cwd: args.cwd,
    p: args.p, port: args.port,
    m: args.m, mount: args.mount
  });

  log.info('Starting watch session...');

  var project = new Project(opts);

  project.on('error', function (d) {
    log.error(d.message);
    logObject('error', d.data);
  });

  function rebuild() {
    project.flush();
    project.build(function () {
      log.info('Project rebuilt successfully');
      log.info('Watching...');
    });
  }

  fs.watch(opts.dataDir, rebuild);
  fs.watch(opts.templateDir, rebuild);
});

function padAfter (str, len) {
  return str + Array(len - str.length).join(' ');
}

function logArray (t, arr) {
  arr.forEach(function (line) {
    log[t](line.gray);
  });
}

function logObject (t, obj) {
  var longest = 0;
  for (var name in obj)
    if (name.length > longest) longest = name.length;

  for (var name in obj)
    log[t](padAfter(name + ':', longest + 4) + obj[name].gray);
}

function header() {
  log.info('Codex'.blue + ' v'.gray + codex.version.gray);
  log.info('It works if it ends with ' + 'Codex '.gray + 'ok'.green);
}

function footerOk() {
  log.info('Codex '.gray + 'ok'.green);
  process.exit();
}

function footerNotOk() {
  log.warn('Codex '.gray + 'not ok'.red);
  process.exit(1);
}

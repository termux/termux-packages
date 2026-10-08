#!/usr/bin/electron
// don't edit the electron binary name here! simply change the variable in the build.sh and we will sed it into the correct one :)
import { app } from "electron/main";
import * as path from "node:path";
import * as fs from "node:fs";

const name = "code-oss";

// Change command name.
const fd = fs.openSync("/proc/self/comm", fs.constants.O_WRONLY);
fs.writeSync(fd, name);
fs.closeSync(fd);

// Remove all extra prefix arguments
process.argv.splice(
  0,
  process.argv.findIndex((arg) => arg.endsWith("/code.mjs")),
);

// Set application paths.
const appPath = import.meta.dirname + "/resources/app";
const packageJson = JSON.parse(fs.readFileSync(new URL("./resources/app/package.json", import.meta.url)));
app.setAppPath(appPath);
app.setDesktopName(name + ".desktop");
app.setName(name);
app.setPath("userCache", path.join(app.getPath("cache"), name));
app.setPath("userData", path.join(app.getPath("appData"), name));
app.setVersion(packageJson.version);

// Run the application.
await import(appPath + "/out/main.js");

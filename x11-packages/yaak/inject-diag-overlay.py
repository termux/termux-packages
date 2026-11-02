#!/usr/bin/env python3
# DIAGNOSTIC (Termux): surfaces any error/hang during the very first React
# mount directly on the white page, since it can be silent in a production
# build. Run from $TERMUX_PKG_SRCDIR before `npm run build`. Only touches
# apps/yaak-client/index.html; safe to drop once the blank-page issue is
# understood.
import sys

path = "apps/yaak-client/index.html"
marker = '<body class="text-base">\n    <div id="root"></div>'

with open(path) as f:
    html = f.read()

if marker not in html:
    sys.exit(f"inject-diag-overlay.py: marker not found in {path}")

script = """<body class="text-base">
    <script>
      (function () {
        var t0 = performance.now();
        function box() {
          var b = document.getElementById("__yaak_diag");
          if (!b) {
            b = document.createElement("pre");
            b.id = "__yaak_diag";
            b.style.cssText =
              "position:fixed;inset:0;margin:0;padding:12px;background:#111;" +
              "color:#0f0;font:12px monospace;white-space:pre-wrap;overflow:auto;z-index:999999;";
            document.body.appendChild(b);
          }
          return b;
        }
        function log(msg) {
          box().textContent += "[" + (performance.now() - t0).toFixed(0) + "ms] " + msg + "\\n";
        }
        window.addEventListener("error", function (e) {
          log("ERROR: " + (e.message || "") + "\\n" + ((e.error && e.error.stack) || ""));
        });
        window.addEventListener("unhandledrejection", function (e) {
          var r = e.reason;
          log("UNHANDLED REJECTION: " + (r && (r.stack || r.message || String(r))));
        });

        // React DevTools hook: react-dom calls hook.inject(renderer) once it
        // loads, then hook.onScheduleFiberRoot()/onCommitFiberRoot() around
        // each render pass. Installing a stub before react-dom evaluates lets
        // us see whether react-dom runs at all, and whether it ever schedules
        // or commits work, even without a real DevTools extension present.
        // onCommitFiberRoot also hands us the FiberRootNode directly, so we
        // can walk the committed tree even if it produced no DOM output
        // (e.g. a Suspense boundary showing a null fallback).
        function fiberName(f) {
          var t = f.type;
          if (typeof t === "string") return t;
          if (t == null) return "tag" + f.tag;
          return t.displayName || t.name || "tag" + f.tag;
        }
        function dumpTree(root) {
          var out = [];
          function walk(f, d) {
            while (f && out.length < 120) {
              var extra = "";
              if (f.tag === 13) {
                // SuspenseComponent: non-null memoizedState means it's showing the fallback
                extra = f.memoizedState ? " <SUSPENDED, showing fallback>" : " <resolved>";
              }
              out.push(new Array(d + 1).join("  ") + fiberName(f) + extra);
              walk(f.child, d + 1);
              f = f.sibling;
            }
          }
          walk(root.current.child, 0);
          return out.length ? out.join("\\n") : "(committed tree has no fibers at all)";
        }
        var scheduled = false, committed = false;
        window.__REACT_DEVTOOLS_GLOBAL_HOOK__ = {
          isDisabled: false,
          supportsFiber: true,
          renderers: new Map(),
          inject: function (renderer) {
            var id = this.renderers.size + 1;
            this.renderers.set(id, renderer);
            log("react-dom loaded and injected into devtools hook (id=" + id + ")");
            return id;
          },
          onScheduleFiberRoot: function () {
            if (!scheduled) { scheduled = true; log("React scheduled its first render"); }
          },
          onCommitFiberRoot: function (id, root) {
            var first = !committed;
            committed = true;
            try {
              log((first ? "React committed its first render" : "React committed again") +
                ":\\n" + dumpTree(root));
            } catch (e) {
              log("onCommitFiberRoot: failed to walk tree: " + e);
            }
          },
          onCommitFiberUnmount: function () {},
          onPostCommitFiberRoot: function () {},
        };

        setTimeout(function () {
          var root = document.getElementById("root");
          if (root && root.children.length === 0) {
            log(
              "root still empty after 6s. hook.inject called=" +
                (window.__REACT_DEVTOOLS_GLOBAL_HOOK__.renderers.size > 0) +
                ", scheduled=" + scheduled + ", committed=" + committed
            );
          }
        }, 6000);
      })();
    </script>
    <div id="root"></div>"""

html = html.replace(marker, script)

with open(path, "w") as f:
    f.write(html)

print("inject-diag-overlay.py: injected diagnostic overlay into", path)

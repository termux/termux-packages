diff --git a/swiftpm/Sources/Workspace/Destination.swift b/swiftpm/Sources/Workspace/Destination.swift
index ac03fb84..99048b80 100644
--- a/swiftpm/Sources/Workspace/Destination.swift
+++ b/swiftpm/Sources/Workspace/Destination.swift
@@ -130,7 +130,7 @@ public struct Destination: Encodable, Equatable {
       #else
         return Destination(
             target: hostTargetTriple,
-            sdk: .root,
+            sdk: AbsolutePath("@TERMUX_APP_PREFIX@"),
             binDir: binDir,
             extraCCFlags: ["-fPIC"],
             extraSwiftCFlags: [],

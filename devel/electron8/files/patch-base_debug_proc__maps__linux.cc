--- base/debug/proc_maps_linux.cc.orig	2020-03-03 07:02:14 UTC
+++ base/debug/proc_maps_linux.cc
@@ -12,7 +12,7 @@
 #include "base/strings/string_split.h"
 #include "build/build_config.h"
 
-#if defined(OS_LINUX) || defined(OS_ANDROID)
+#if defined(OS_LINUX) || defined(OS_BSD) || defined(OS_ANDROID)
 #include <inttypes.h>
 #endif
 

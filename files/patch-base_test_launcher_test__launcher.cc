--- base/test/launcher/test_launcher.cc.orig	2019-03-15 06:36:56 UTC
+++ base/test/launcher/test_launcher.cc
@@ -53,6 +53,7 @@
 #include "testing/gtest/include/gtest/gtest.h"
 
 #if defined(OS_POSIX)
+#include <signal.h>
 #include <fcntl.h>
 
 #include "base/files/file_descriptor_watcher_posix.h"

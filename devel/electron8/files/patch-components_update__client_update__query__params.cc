--- components/update_client/update_query_params.cc.orig	2020-03-03 07:02:59 UTC
+++ components/update_client/update_query_params.cc
@@ -39,6 +39,8 @@ const char kOs[] =
     "fuchsia";
 #elif defined(OS_OPENBSD)
     "openbsd";
+#elif defined(OS_FREEBSD)
+    "freebsd";
 #else
 #error "unknown os"
 #endif

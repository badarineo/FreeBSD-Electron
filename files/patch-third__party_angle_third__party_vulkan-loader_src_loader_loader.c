--- third_party/angle/third_party/vulkan-loader/src/loader/loader.c.orig	2019-03-15 06:41:41 UTC
+++ third_party/angle/third_party/vulkan-loader/src/loader/loader.c
@@ -213,7 +213,7 @@ void *loader_device_heap_realloc(const struct loader_d
 }
 
 // Environment variables
-#if defined(__linux__) || defined(__APPLE__)
+#if defined(__linux__) || defined(__APPLE__) || defined(__FreeBSD__)
 
 static inline char *loader_getenv(const char *name, const struct loader_instance *inst) {
     // No allocation of memory necessary for Linux, but we should at least touch

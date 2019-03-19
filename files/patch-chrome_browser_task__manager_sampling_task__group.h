--- chrome/browser/task_manager/sampling/task_group.h.orig	2019-03-15 06:37:06 UTC
+++ chrome/browser/task_manager/sampling/task_group.h
@@ -103,9 +103,9 @@ class TaskGroup {
   int nacl_debug_stub_port() const { return nacl_debug_stub_port_; }
 #endif  // BUILDFLAG(ENABLE_NACL)
 
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) || defined(OS_BSD)
   int open_fd_count() const { return open_fd_count_; }
-#endif  // defined(OS_LINUX)
+#endif  // defined(OS_LINUX) || defined(OS_BSD)
 
   int idle_wakeups_per_second() const { return idle_wakeups_per_second_; }
 
@@ -119,9 +119,9 @@ class TaskGroup {
   void RefreshNaClDebugStubPort(int child_process_unique_id);
   void OnRefreshNaClDebugStubPortDone(int port);
 #endif
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) || defined(OS_BSD)
   void OnOpenFdCountRefreshDone(int open_fd_count);
-#endif  // defined(OS_LINUX)
+#endif  // defined(OS_LINUX) || defined(OS_BSD)
 
   void OnCpuRefreshDone(double cpu_usage);
   void OnSwappedMemRefreshDone(int64_t swapped_mem_bytes);
@@ -181,10 +181,10 @@ class TaskGroup {
 #if BUILDFLAG(ENABLE_NACL)
   int nacl_debug_stub_port_;
 #endif  // BUILDFLAG(ENABLE_NACL)
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) || defined(OS_BSD)
   // The number of file descriptors currently open by the process.
   int open_fd_count_;
-#endif  // defined(OS_LINUX)
+#endif  // defined(OS_LINUX) || defined(OS_BSD)
   int idle_wakeups_per_second_;
   bool gpu_memory_has_duplicates_;
   bool is_backgrounded_;

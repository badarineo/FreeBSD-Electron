--- content/utility/utility_main.cc.orig	2019-03-15 06:37:23 UTC
+++ content/utility/utility_main.cc
@@ -64,7 +64,7 @@ int UtilityMain(const MainFunctionParams& parameters) 
   if (parameters.command_line.HasSwitch(switches::kUtilityStartupDialog))
     WaitForDebugger("Utility");
 
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) && !defined(OS_BSD)
   // Initializes the sandbox before any threads are created.
   // TODO(jorgelo): move this after GTK initialization when we enable a strict
   // Seccomp-BPF policy.

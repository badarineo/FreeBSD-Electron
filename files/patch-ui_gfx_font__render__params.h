--- ui/gfx/font_render_params.h.orig	2019-03-15 06:38:28 UTC
+++ ui/gfx/font_render_params.h
@@ -111,13 +111,13 @@ GFX_EXPORT FontRenderParams GetFontRenderParams(
     const FontRenderParamsQuery& query,
     std::string* family_out);
 
-#if defined(OS_LINUX)
+#if defined(OS_LINUX) || defined(OS_BSD)
 // Clears GetFontRenderParams()'s cache. Intended to be called by tests that are
 // changing Fontconfig's configuration.
 GFX_EXPORT void ClearFontRenderParamsCacheForTest();
 #endif
 
-#if defined(OS_LINUX) || (defined(OS_ANDROID) && BUILDFLAG(ENABLE_VR))
+#if defined(OS_LINUX) || (defined(OS_ANDROID) && BUILDFLAG(ENABLE_VR)) || defined(OS_BSD)
 // Gets the device scale factor to query the FontRenderParams.
 GFX_EXPORT float GetFontRenderParamsDeviceScaleFactor();
 

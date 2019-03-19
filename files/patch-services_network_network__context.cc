--- services/network/network_context.cc.orig	2019-03-16 09:15:20 UTC
+++ services/network/network_context.cc
@@ -103,7 +103,7 @@
 #endif  // defined(USE_NSS_CERTS)
 
 #if defined(OS_ANDROID) || defined(OS_FUCHSIA) || \
-    (defined(OS_LINUX) && !defined(OS_CHROMEOS)) || defined(OS_MACOSX)
+    ((defined(OS_BSD) || defined(OS_LINUX)) && !defined(OS_CHROMEOS)) || defined(OS_MACOSX)
 #include "net/cert/cert_net_fetcher.h"
 #include "net/cert_net/cert_net_fetcher_impl.h"
 #endif
@@ -380,7 +380,7 @@ NetworkContext::~NetworkContext() {
 #endif
 
 #if defined(OS_ANDROID) || defined(OS_FUCHSIA) || \
-    (defined(OS_LINUX) && !defined(OS_CHROMEOS)) || defined(OS_MACOSX)
+    ((defined(OS_BSD) || defined(OS_LINUX)) && !defined(OS_CHROMEOS)) || defined(OS_MACOSX)
     net::ShutdownGlobalCertNetFetcher();
 #endif
   }
@@ -833,7 +833,7 @@ URLRequestContextOwner NetworkContext::ApplyContextPar
 
     net::CookieCryptoDelegate* crypto_delegate = nullptr;
     if (params_->enable_encrypted_cookies) {
-#if defined(OS_LINUX) && !defined(OS_CHROMEOS) && !defined(IS_CHROMECAST)
+#if (defined(OS_BSD) || defined(OS_LINUX)) && !defined(OS_CHROMEOS) && !defined(IS_CHROMECAST)
       DCHECK(network_service_->os_crypt_config_set())
           << "NetworkService::SetCryptConfig must be called before creating a "
              "NetworkContext with encrypted cookies.";
@@ -1105,7 +1105,7 @@ URLRequestContextOwner NetworkContext::ApplyContextPar
     net::SetURLRequestContextForNSSHttpIO(result.url_request_context.get());
 #endif
 #if defined(OS_ANDROID) || defined(OS_FUCHSIA) || \
-    (defined(OS_LINUX) && !defined(OS_CHROMEOS)) || defined(OS_MACOSX)
+    ((defined(OS_BSD) || defined(OS_LINUX)) && !defined(OS_CHROMEOS)) || defined(OS_MACOSX)
     net::SetGlobalCertNetFetcher(
         net::CreateCertNetFetcher(result.url_request_context.get()));
 #endif

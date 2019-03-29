# $FreeBSD$

PORTNAME=	electron
DISTVERSIONPREFIX=	v
DISTVERSION=	4.1.2
CATEGORIES=	devel
MASTER_SITES=	https://github.com/tagattie/FreeBSD-Electron/releases/download/v4.1.0/:chromium \
		https://commondatastorage.googleapis.com/chromium-nodejs/:chromium_node
		# https://commondatastorage.googleapis.com/chromium-fonts/:chromium_testfonts
DISTFILES=	chromium-${CHROMIUM_VER}${EXTRACT_SUFX}:chromium \
		${CHROMIUM_NODE_MODULES_HASH}:chromium_node
		# ${CHROMIUM_TEST_FONTS_HASH}:chromium_testfonts

MAINTAINER=	maintainer@example.com
COMMENT=	Build cross-platform desktop apps with JavaScript, HTML, and CSS

LICENSE=	MIT
LICENSE_FILE=	${WRKSRC}/LICENSE

FETCH_DEPENDS=	npm:www/npm-node10
PATCH_DEPENDS=	git:devel/git
BUILD_DEPENDS=	gn:devel/chromium-gn \
		yasm:devel/yasm \
		node:www/node10 \
		npm:www/npm-node10
LIB_DEPENDS=	libatk-bridge-2.0.so:accessibility/at-spi2-atk \
		libsnappy.so:archivers/snappy \
		libFLAC.so:audio/flac \
		libopus.so:audio/opus \
		libnotify.so:devel/libnotify \
		libpci.so:devel/libpci \
		libdrm.so:graphics/libdrm \
		libwebp.so:graphics/webp \
		libavcodec.so:multimedia/ffmpeg \
		libopenh264.so:multimedia/openh264 \
		libfreetype.so:print/freetype2 \
		libharfbuzz.so:print/harfbuzz \
		libnss3.so:security/nss \
		libfontconfig.so:x11-fonts/fontconfig
RUN_DEPENDS=	xdg-open:devel/xdg-utils

USES=		dos2unix gettext-tools gnome jpeg localbase:ldflags ninja \
		pkgconfig python:2.7,build tar:xz

USE_GITHUB=	yes
GH_TUPLE=	electron:node:8bc5d171a0873c0ba49f9433798bc8b67399788c:node
		# boto:boto:f7574aa6cc2c819430c1f05e9a1a1a666ef8169b:boto \
		# yaml:pyyaml:3.12:pyyaml \
		# kennethreitz:requests:e4d59bedfd3c7f4f254f4f5d036587bcd8152458:requests

CHROMIUM_VER=	69.0.3497.128
CHROMIUM_NODE_MODULES_HASH=	050c85d20f7cedd7f5c39533c1ba89dcdfa56a08
# CHROMIUM_TEST_FONTS_HASH=	a22de844e32a3f720d219e3911c3da3478039f89

NO_WRKSUBDIR=	yes
WRKSRC_SUBDIR=	src

DOS2UNIX_FILES=	third_party/skia/third_party/vulkanmemoryallocator/include/vk_mem_alloc.h
BINARY_ALIAS=	python=${PYTHON_CMD}

USE_GNOME=	atk pango gtk30 libxml2 libxslt

GN_ARGS+=	clang_use_chrome_plugins=false \
		enable_hangout_services_extension=true \
		enable_nacl=false \
		enable_remoting=false \
		fieldtrial_testing_like_official_build=true \
		is_clang=true \
		jumbo_file_merge_limit=8 \
		toolkit_views=true \
		treat_warnings_as_errors=false \
		use_allocator="none" \
		use_allocator_shim=false \
		use_aura=true \
		use_bundled_fontconfig=false \
		use_custom_libcxx=false \
		use_gnome_keyring=false \
		use_jumbo_build=true \
		use_lld=true \
		use_sysroot=false \
		use_system_freetype=true \
		use_system_harfbuzz=true \
		use_system_libjpeg=true \
		extra_cxxflags="${CXXFLAGS}" \
		extra_ldflags="${LDFLAGS}"

ALL_TARGET=	electron
MAKE_ARGS=	-C out/${BUILDTYPE}
MAKE_ENV+=	C_INCLUDE_PATH=${LOCALBASE}/include \
		CPLUS_INCLUDE_PATH=${LOCALBASE}/include

OPTIONS_DEFINE=	CUPS DEBUG DIST DRIVER KERBEROS
DIST_DESC=	Build distribution zip files
DRIVER_DESC=	Install chromedriver
OPTIONS_GROUP=	AUDIO
OPTIONS_GROUP_AUDIO=	ALSA PULSEAUDIO
OPTIONS_DEFAULT=	ALSA CUPS DRIVER KERBEROS
OPTIONS_SUB=	yes

ALSA_LIB_DEPENDS=	libasound.so:audio/alsa-lib
ALSA_RUN_DEPENDS=	${LOCALBASE}/lib/alsa-lib/libasound_module_pcm_oss.so:audio/alsa-plugins
ALSA_VARS=	GN_ARGS+=use_alsa=true
ALSA_VARS_OFF=	GN_ARGS+=use_alsa=false

CUPS_LIB_DEPENDS=	libcups.so:print/cups
CUPS_VARS=	GN_ARGS+=use_cups=true
CUPS_VARS_OFF=	GN_ARGS+=use_cups=false

DEBUG_VARS=	BUILDTYPE=Debug \
		GN_ARGS+=is_component_build=false
DEBUG_VARS_OFF=	BUILDTYPE=Release

DIST_ALL_TARGET=	dist.zip chromedriver.zip mksnapshot.zip

DRIVER_ALL_TARGET=	chromedriver

KERBEROS_VARS=	GN_ARGS+=use_kerberos=true
KERBEROS_VARS_OFF=	GN_ARGS+=use_kerberos=false

PULSEAUDIO_LIB_DEPENDS=	libpulse.so:audio/pulseaudio
PULSEAUDIO_VARS=	GN_ARGS+=use_pulseaudio=true
PULSEAUDIO_VARS_OFF=	GN_ARGS+=use_pulseaudio=false

post-fetch:
	${RM} -r ${TMPDIR}/npm-cache
	${MKDIR} ${TMPDIR}/npm-cache
	${CP} ${FILESDIR}/package.json ${FILESDIR}/package-lock.json ${TMPDIR}/npm-cache
	cd ${TMPDIR}/npm-cache && npm install --verbose

post-extract:
	${MV} ${WRKDIR}/${PKGNAME}/chromium-${CHROMIUM_VER} ${WRKSRC}
	${MV} ${WRKDIR}/${PKGNAME}/${PKGNAME} ${WRKSRC}/electron
	${MV} ${WRKDIR}/${PKGNAME}/${GH_PROJECT_node}-${GH_TAGNAME_node} \
		${WRKSRC}/third_party/${GH_ACCOUNT_node}_${GH_PROJECT_node}
	# ${RMDIR} ${WRKSRC}/electron/vendor/${GH_PROJECT_boto}
	# ${MV} ${WRKDIR}/${PKGNAME}/${GH_PROJECT_boto}-${GH_TAGNAME_boto} \
	# 	${WRKSRC}/electron/vendor/${GH_PROJECT_boto}
	# ${MV} ${WRKDIR}/${PKGNAME}/${GH_PROJECT_pyyaml}-${GH_TAGNAME_pyyaml} \
	# 	${WRKSRC}/electron/vendor/${GH_PROJECT_pyyaml}
	# ${RMDIR} ${WRKSRC}/electron/vendor/${GH_PROJECT_requests}
	# ${MV} ${WRKDIR}/${PKGNAME}/${GH_PROJECT_requests}-${GH_TAGNAME_requests} \
	# 	${WRKSRC}/electron/vendor/${GH_PROJECT_requests}
	${MV} ${WRKDIR}/${PKGNAME}/node_modules ${WRKSRC}/third_party/node
	# ${MV} ${WRKDIR}/${PKGNAME}/test_fonts ${WRKSRC}/third_party/test_fonts
	${MV} ${TMPDIR}/npm-cache/node_modules ${WRKSRC}/electron

pre-patch:
	${SH} ${FILESDIR}/apply-electron-patches.sh ${WRKSRC}
	# ${FIND} ${WRKSRC} -type f -name '*.orig' -print -delete
	# ${FIND} ${WRKSRC} -type f -name '*~' -print -delete

pre-configure:
	# cd ${WRKSRC}/electron/vendor/${GH_PROJECT_boto} && \
	# 	${PYTHON_CMD} setup.py build
	# cd ${WRKSRC}/electron/vendor/${GH_PROJECT_requests} && \
	# 	${PYTHON_CMD} setup.py build
	# We used to remove bundled libraries to be sure that chromium uses
	# system libraries and not shipped ones.
	# cd ${WRKSRC} && ${PYTHON_CMD} \
	#./build/linux/unbundle/remove_bundled_libraries.py [list of preserved]
	cd ${WRKSRC} && ${SETENV} ${CONFIGURE_ENV} ${PYTHON_CMD} \
		./build/linux/unbundle/replace_gn_files.py --system-libraries \
		ffmpeg flac freetype harfbuzz-ng libdrm libusb libwebp libxml \
		libxslt openh264 opus snappy yasm || ${FALSE}

do-configure:
	cd ${WRKSRC} && ${SETENV} ${CONFIGURE_ENV} gn gen out/${BUILDTYPE} \
		--args='import("//electron/build/args/${BUILDTYPE:tl}.gn") ${GN_ARGS}'
	# Setup nodejs dependency
	${MKDIR} ${WRKSRC}/third_party/node/freebsd/node-freebsd-x64/bin
	${LN} -sf ${LOCALBASE}/bin/node ${WRKSRC}/third_party/node/freebsd/node-freebsd-x64/bin/node

# do-build:
# 	cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} ninja -C out/${BUILDTYPE} ${ALL_TARGET}

do-install:
	${MKDIR} ${STAGEDIR}${DATADIR}
	${INSTALL_DATA} ${WRKSRC}/out/${BUILDTYPE}/*.pak ${STAGEDIR}${DATADIR}
.for f in icudtl.dat mksnapshot natives_blob.bin snapshot_blob.bin v8_context_snapshot.bin v8_context_snapshot_generator
	${INSTALL_DATA} ${WRKSRC}/out/${BUILDTYPE}/${f} ${STAGEDIR}${DATADIR}
.endfor
	${MKDIR} ${STAGEDIR}${DATADIR}/locales
	${INSTALL_DATA} ${WRKSRC}/out/${BUILDTYPE}/locales/*.pak ${STAGEDIR}${DATADIR}/locales
	${MKDIR} ${STAGEDIR}${DATADIR}/resources
.for f in default_app.asar electron.asar
	${INSTALL_DATA} ${WRKSRC}/out/${BUILDTYPE}/resources/${f} ${STAGEDIR}${DATADIR}/resources
.endfor
	${INSTALL_PROGRAM} ${WRKSRC}/out/${BUILDTYPE}/electron ${STAGEDIR}${DATADIR}
.for f in libEGL.so libGLESv2.so libVkICD_mock_icd.so
	${INSTALL_LIB} ${WRKSRC}/out/${BUILDTYPE}/${f} ${STAGEDIR}${DATADIR}
.endfor
	${MKDIR} ${STAGEDIR}${DATADIR}/swiftshader
.for f in libEGL.so libGLESv2.so
	${INSTALL_LIB} ${WRKSRC}/out/${BUILDTYPE}/swiftshader/${f} ${STAGEDIR}${DATADIR}/swiftshader
.endfor
	${RLN} ${STAGEDIR}${DATADIR}/electron ${STAGEDIR}${PREFIX}/bin

post-install-DRIVER-on:
	${INSTALL_PROGRAM} ${WRKSRC}/out/${BUILDTYPE}/chromedriver ${STAGEDIR}${DATADIR}

.include <bsd.port.mk>
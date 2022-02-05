
# libcutils
local libcutils_nonwindows_sources_cpp="
	android_get_control_file.cpp
	sockets_unix.cpp
"
local libcutils_sources_cpp="
	$libcutils_nonwindows_sources_cpp
	fs_config.cpp
	sched_policy.cpp
	sockets.cpp
"
local libcutils_nonwindows_sources_c="
	fs.c
	multiuser.c
	socket_inaddr_any_server_unix.c
	socket_local_client_unix.c
	socket_local_server_unix.c
	socket_network_client_unix.c
	str_parms.c
"
libcutils_nonwindows_sources_c+="
	ashmem-host.c
	trace-host.c
"
local libcutils_sources_c="
	$libcutils_nonwindows_sources_c
	config_utils.c
	canned_fs_config.c
	hashmap.c
	iosched_policy.c
	load_file.c
	native_handle.c
	open_memstream.c
	record_stream.c
	strdup16to8.c
	strdup8to16.c
	strlcpy.c
	threads.c
"

# libutils
#CallStack.cpp
local libutils_sources="
	FileMap.cpp
	JenkinsHash.cpp
	NativeHandle.cpp
	Printer.cpp
	PropertyMap.cpp
	RefBase.cpp
	SharedBuffer.cpp
	Static.cpp
	StopWatch.cpp
	String8.cpp
	String16.cpp
	StrongPointer.cpp
	SystemClock.cpp
	Threads.cpp
	Timers.cpp
	Tokenizer.cpp
	Unicode.cpp
	VectorImpl.cpp
	misc.cpp
"

# libbase
local libbase_linux_sources="
	errors_unix.cpp
	chrono_utils.cpp
"
local libbase_sources="
	$libbase_linux_sources
	file.cpp
	logging.cpp
	parsenetaddress.cpp
	quick_exit.cpp
	stringprintf.cpp
	strings.cpp
	test_utils.cpp
"

# libziparchive
local libziparchive_sources="
	zip_archive.cc
	zip_archive_stream_entry.cc
	zip_writer.cc
"

# androidfw
local androidfw_sources="
	ApkAssets.cpp
	Asset.cpp
	AssetDir.cpp
	AssetManager.cpp
	AssetManager2.cpp
	AttributeResolution.cpp
	ChunkIterator.cpp
	LoadedArsc.cpp
	LocaleData.cpp
	misc.cpp
	ObbFile.cpp
	ResourceTypes.cpp
	ResourceUtils.cpp
	StreamingZipInflater.cpp
	TypeWrappers.cpp
	Util.cpp
	ZipFileRO.cpp
	ZipUtils.cpp
"

# aapt2
local libaapt2_sources_proto="
	Resources.proto
	ResourcesInternal.proto
"
local libaapt2_sources_cpp="
	${libaapt2_sources_proto//.proto/.pb.cc}
	compile/IdAssigner.cpp
	compile/InlineXmlFormatParser.cpp
	compile/NinePatch.cpp
	compile/Png.cpp
	compile/PngChunkFilter.cpp
	compile/PngCrunch.cpp
	compile/PseudolocaleGenerator.cpp
	compile/Pseudolocalizer.cpp
	compile/XmlIdCollector.cpp
	configuration/ConfigurationParser.cpp
	filter/AbiFilter.cpp
	filter/ConfigFilter.cpp
	flatten/Archive.cpp
	flatten/TableFlattener.cpp
	flatten/XmlFlattener.cpp
	io/BigBufferStreams.cpp
	io/File.cpp
	io/FileInputStream.cpp
	io/FileSystem.cpp
	io/StringInputStream.cpp
	io/Util.cpp
	io/ZipArchive.cpp
	link/AutoVersioner.cpp
	link/ManifestFixer.cpp
	link/ProductFilter.cpp
	link/PrivateAttributeMover.cpp
	link/ReferenceLinker.cpp
	link/TableMerger.cpp
	link/XmlCompatVersioner.cpp
	link/XmlNamespaceRemover.cpp
	link/XmlReferenceLinker.cpp
	optimize/ResourceDeduper.cpp
	optimize/VersionCollapser.cpp
	process/SymbolTable.cpp
	proto/ProtoHelpers.cpp
	proto/TableProtoDeserializer.cpp
	proto/TableProtoSerializer.cpp
	split/TableSplitter.cpp
	text/Unicode.cpp
	text/Utf8Iterator.cpp
	unflatten/BinaryResourceParser.cpp
	unflatten/ResChunkPullParser.cpp
	util/BigBuffer.cpp
	util/Files.cpp
	util/Util.cpp
	ConfigDescription.cpp
	Debug.cpp
	DominatorTree.cpp
	Flags.cpp
	java/AnnotationProcessor.cpp
	java/ClassDefinition.cpp
	java/JavaClassGenerator.cpp
	java/ManifestClassGenerator.cpp
	java/ProguardRules.cpp
	LoadedApk.cpp
	Locale.cpp
	Resource.cpp
	ResourceParser.cpp
	ResourceTable.cpp
	ResourceUtils.cpp
	ResourceValues.cpp
	SdkConstants.cpp
	StringPool.cpp
	xml/XmlActionExecutor.cpp
	xml/XmlDom.cpp
	xml/XmlPullParser.cpp
	xml/XmlUtil.cpp
"
local aapt2_sources_cpp="
	$libaapt2_sources_cpp
	cmd/Compile.cpp
	cmd/Diff.cpp
	cmd/Dump.cpp
	cmd/Link.cpp
	cmd/Optimize.cpp
	cmd/Util.cpp
	Main.cpp
"

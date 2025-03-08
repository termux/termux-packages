
# libcutils
local libcutils_sockets_nonwindows_sources="
	socket_inaddr_any_server_unix.cpp
	socket_local_client_unix.cpp
	socket_local_server_unix.cpp
	socket_network_client_unix.cpp
	sockets_unix.cpp
"
local libcutils_sockets_sources="
	$libcutils_sockets_nonwindows_sources
	sockets.cpp
"
local libcutils_nonwindows_sources="
	fs.cpp
	hashmap.cpp
	multiuser.cpp
	str_parms.cpp
"
libcutils_nonwindows_sources+="
	ashmem-host.cpp
	canned_fs_config.cpp
	fs_config.cpp
	trace-host.cpp
"
local libcutils_sources="
	$libcutils_sockets_sources
	$libcutils_nonwindows_sources
	config_utils.cpp
	iosched_policy.cpp
	load_file.cpp
	native_handle.cpp
	properties.cpp
	record_stream.cpp
	strlcpy.c
"

# libutils
local libutils_sources="
	FileMap.cpp
	JenkinsHash.cpp
	LightRefBase.cpp
	NativeHandle.cpp
	Printer.cpp
	StopWatch.cpp
	SystemClock.cpp
	Threads.cpp
	Timers.cpp
	Tokenizer.cpp
	misc.cpp
"
libutils_sources+="
	binder/Errors.cpp
	binder/RefBase.cpp
	binder/SharedBuffer.cpp
	binder/String8.cpp
	binder/String16.cpp
	binder/StrongPointer.cpp
	binder/Unicode.cpp
	binder/VectorImpl.cpp
"

# libbase
local libbase_linux_sources="
	errors_unix.cpp
"
local libbase_sources="
	$libbase_linux_sources
	abi_compatibility.cpp
	chrono_utils.cpp
	cmsg.cpp
	file.cpp
	hex.cpp
	logging.cpp
	mapped_file.cpp
	parsebool.cpp
	parsenetaddress.cpp
	posix_strerror_r.cpp
	process.cpp
	properties.cpp
	result.cpp
	stringprintf.cpp
	strings.cpp
	threads.cpp
	test_utils.cpp
"

# libziparchive
local libziparchive_sources="
	zip_archive.cc
	zip_archive_stream_entry.cc
	zip_cd_entry_map.cc
	zip_error.cpp
	zip_writer.cc
"
libziparchive_sources+="
	incfs_support/signal_handling.cpp
"

# androidfw
local androidfw_sources="
	ApkAssets.cpp
	ApkParsing.cpp
	Asset.cpp
	AssetDir.cpp
	AssetManager.cpp
	AssetManager2.cpp
	AssetsProvider.cpp
	AttributeResolution.cpp
	BigBuffer.cpp
	BigBufferStream.cpp
	ChunkIterator.cpp
	ConfigDescription.cpp
	FileStream.cpp
	Idmap.cpp
	LoadedArsc.cpp
	Locale.cpp
	LocaleData.cpp
	misc.cpp
	NinePatch.cpp
	ObbFile.cpp
	PathUtils.cpp
	PosixUtils.cpp
	Png.cpp
	PngChunkFilter.cpp
	PngCrunch.cpp
	ResourceTimer.cpp
	ResourceTypes.cpp
	ResourceUtils.cpp
	StreamingZipInflater.cpp
	StringPool.cpp
	TypeWrappers.cpp
	Util.cpp
	ZipFileRO.cpp
	ZipUtils.cpp
"

# aapt2
local libaapt2_proto="
	ApkInfo.proto
	Configuration.proto
	Resources.proto
	ResourceMetadata.proto
	ResourcesInternal.proto
"
local libaapt2_sources="
	${libaapt2_proto//.proto/.pb.cc}
	compile/IdAssigner.cpp
	compile/InlineXmlFormatParser.cpp
	compile/PseudolocaleGenerator.cpp
	compile/Pseudolocalizer.cpp
	compile/XmlIdCollector.cpp
	configuration/ConfigurationParser.cpp
	dump/DumpManifest.cpp
	filter/AbiFilter.cpp
	filter/ConfigFilter.cpp
	format/Archive.cpp
	format/Container.cpp
	format/binary/BinaryResourceParser.cpp
	format/binary/ResChunkPullParser.cpp
	format/binary/ResEntryWriter.cpp
	format/binary/TableFlattener.cpp
	format/binary/XmlFlattener.cpp
	format/proto/ProtoDeserialize.cpp
	format/proto/ProtoSerialize.cpp
	io/File.cpp
	io/FileSystem.cpp
	io/StringStream.cpp
	io/Util.cpp
	io/ZipArchive.cpp
	link/AutoVersioner.cpp
	link/FeatureFlagsFilter.cpp
	link/FlagDisabledResourceRemover.cpp
	link/ManifestFixer.cpp
	link/NoDefaultResourceRemover.cpp
	link/PrivateAttributeMover.cpp
	link/ReferenceLinker.cpp
	link/ResourceExcluder.cpp
	link/TableMerger.cpp
	link/XmlCompatVersioner.cpp
	link/XmlNamespaceRemover.cpp
	link/XmlReferenceLinker.cpp
	optimize/MultiApkGenerator.cpp
	optimize/ResourceDeduper.cpp
	optimize/ResourceFilter.cpp
	optimize/Obfuscator.cpp
	optimize/VersionCollapser.cpp
	process/ProductFilter.cpp
	process/SymbolTable.cpp
	split/TableSplitter.cpp
	text/Printer.cpp
	text/Unicode.cpp
	text/Utf8Iterator.cpp
	util/Files.cpp
	util/Util.cpp
	Debug.cpp
	DominatorTree.cpp
	java/AnnotationProcessor.cpp
	java/ClassDefinition.cpp
	java/JavaClassGenerator.cpp
	java/ManifestClassGenerator.cpp
	java/ProguardRules.cpp
	LoadedApk.cpp
	Resource.cpp
	ResourceParser.cpp
	ResourceTable.cpp
	ResourceUtils.cpp
	ResourceValues.cpp
	SdkConstants.cpp
	trace/TraceBuffer.cpp
	xml/XmlActionExecutor.cpp
	xml/XmlDom.cpp
	xml/XmlPullParser.cpp
	xml/XmlUtil.cpp
	ValueTransformer.cpp
"
local aapt2_tool_sources="
	cmd/ApkInfo.cpp
	cmd/Command.cpp
	cmd/Compile.cpp
	cmd/Convert.cpp
	cmd/Diff.cpp
	cmd/Dump.cpp
	cmd/Link.cpp
	cmd/Optimize.cpp
	cmd/Util.cpp
"
local aapt2_sources="
	$libaapt2_sources
	$aapt2_tool_sources
	Main.cpp
"

# aidl
local libaidl_sources="
	aidl_checkapi.cpp
	aidl_const_expressions.cpp
	aidl_dumpapi.cpp
	aidl_language.cpp
	aidl_to_common.cpp
	aidl_to_cpp_common.cpp
	aidl_to_cpp.cpp
	aidl_to_java.cpp
	aidl_to_ndk.cpp
	aidl_to_rust.cpp
	aidl_typenames.cpp
	aidl.cpp
	ast_java.cpp
	check_valid.cpp
	code_writer.cpp
	comments.cpp
	diagnostics.cpp
	generate_aidl_mappings.cpp
	generate_cpp.cpp
	generate_cpp_analyzer.cpp
	generate_java_binder.cpp
	generate_java.cpp
	generate_ndk.cpp
	generate_rust.cpp
	import_resolver.cpp
	io_delegate.cpp
	location.cpp
	logging.cpp
	options.cpp
	parser.cpp
	permission.cpp
	preprocess.cpp
"
libaidl_sources+="
	lex.yy.c
	aidl_language_y.tab.cc
"
local aidl_sources="
	$libaidl_sources
	main.cpp
"

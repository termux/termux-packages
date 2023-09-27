
# libpropertyinfoparser
local libpropertyinfoparser_sources="
	property_info_parser.cpp
"

# libpropertyinfoserializer
local libpropertyinfoserializer_sources="
	property_info_file.cpp
	property_info_serializer.cpp
	trie_builder.cpp
	trie_serializer.cpp
"

# sysprop
local sysprop_proto="
	sysprop.proto
"
local sysprop_sources="
	${sysprop_proto//.proto/.pb.cc}
	Common.cpp
	CodeWriter.cpp
"
local sysprop_cpp_sources="
	CppGen.cpp
	CppMain.cpp
"
local sysprop_java_sources="
	JavaGen.cpp
	JavaMain.cpp
"

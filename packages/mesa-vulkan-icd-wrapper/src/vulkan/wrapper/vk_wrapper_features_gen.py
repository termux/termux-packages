COPYRIGHT=u"""
/* Copyright © 2021 Intel Corporation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice (including the next
 * paragraph) shall be included in all copies or substantial portions of the
 * Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */
"""

import argparse
from collections import OrderedDict
from dataclasses import dataclass
import os
import sys
import typing
import xml.etree.ElementTree as et

import mako
from mako.template import Template
from vk_extensions import Requirements, get_all_required, filter_api

def str_removeprefix(s, prefix):
    if s.startswith(prefix):
        return s[len(prefix):]
    return s

RENAMED_FEATURES = {
    # See https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/17272#note_1446477 for details
    ('BufferDeviceAddressFeaturesEXT', 'bufferDeviceAddressCaptureReplay'): 'bufferDeviceAddressCaptureReplayEXT',

    ('MeshShaderFeaturesNV', 'taskShader'): 'taskShaderNV',
    ('MeshShaderFeaturesNV', 'meshShader'): 'meshShaderNV',

    ('CooperativeMatrixFeaturesNV', 'cooperativeMatrix'): 'cooperativeMatrixNV',
    ('CooperativeMatrixFeaturesNV', 'cooperativeMatrixRobustBufferAccess'): 'cooperativeMatrixRobustBufferAccessNV',

    ('DeviceGeneratedCommandsFeaturesNV', 'deviceGeneratedCommands'): 'deviceGeneratedCommandsNV',
}

KNOWN_ALIASES = [
    (['Vulkan11Features', '16BitStorageFeatures'], ['storageBuffer16BitAccess', 'uniformAndStorageBuffer16BitAccess', 'storagePushConstant16', 'storageInputOutput16']),
    (['Vulkan11Features', 'MultiviewFeatures'], ['multiview', 'multiviewGeometryShader', 'multiviewTessellationShader']),
    (['Vulkan11Features', 'VariablePointersFeatures'], ['variablePointersStorageBuffer', 'variablePointers']),
    (['Vulkan11Features', 'ProtectedMemoryFeatures'], ['protectedMemory']),
    (['Vulkan11Features', 'SamplerYcbcrConversionFeatures'], ['samplerYcbcrConversion']),
    (['Vulkan11Features', 'ShaderDrawParametersFeatures'], ['shaderDrawParameters']),

    (['Vulkan12Features', '8BitStorageFeatures'], ['storageBuffer8BitAccess', 'uniformAndStorageBuffer8BitAccess', 'storagePushConstant8']),
    (['Vulkan12Features', 'ShaderAtomicInt64Features'], ['shaderBufferInt64Atomics', 'shaderSharedInt64Atomics']),
    (['Vulkan12Features', 'ShaderFloat16Int8Features'], ['shaderFloat16', 'shaderInt8']),
    (
        ['Vulkan12Features', 'DescriptorIndexingFeatures'],
        [
            'shaderInputAttachmentArrayDynamicIndexing',
            'shaderUniformTexelBufferArrayDynamicIndexing',
            'shaderStorageTexelBufferArrayDynamicIndexing',
            'shaderUniformBufferArrayNonUniformIndexing',
            'shaderSampledImageArrayNonUniformIndexing',
            'shaderStorageBufferArrayNonUniformIndexing',
            'shaderStorageImageArrayNonUniformIndexing',
            'shaderInputAttachmentArrayNonUniformIndexing',
            'shaderUniformTexelBufferArrayNonUniformIndexing',
            'shaderStorageTexelBufferArrayNonUniformIndexing',
            'descriptorBindingUniformBufferUpdateAfterBind',
            'descriptorBindingSampledImageUpdateAfterBind',
            'descriptorBindingStorageImageUpdateAfterBind',
            'descriptorBindingStorageBufferUpdateAfterBind',
            'descriptorBindingUniformTexelBufferUpdateAfterBind',
            'descriptorBindingStorageTexelBufferUpdateAfterBind',
            'descriptorBindingUpdateUnusedWhilePending',
            'descriptorBindingPartiallyBound',
            'descriptorBindingVariableDescriptorCount',
            'runtimeDescriptorArray',
        ],
    ),
    (['Vulkan12Features', 'ScalarBlockLayoutFeatures'], ['scalarBlockLayout']),
    (['Vulkan12Features', 'ImagelessFramebufferFeatures'], ['imagelessFramebuffer']),
    (['Vulkan12Features', 'UniformBufferStandardLayoutFeatures'], ['uniformBufferStandardLayout']),
    (['Vulkan12Features', 'ShaderSubgroupExtendedTypesFeatures'], ['shaderSubgroupExtendedTypes']),
    (['Vulkan12Features', 'SeparateDepthStencilLayoutsFeatures'], ['separateDepthStencilLayouts']),
    (['Vulkan12Features', 'HostQueryResetFeatures'], ['hostQueryReset']),
    (['Vulkan12Features', 'TimelineSemaphoreFeatures'], ['timelineSemaphore']),
    (['Vulkan12Features', 'BufferDeviceAddressFeatures', 'BufferDeviceAddressFeaturesEXT'], ['bufferDeviceAddress', 'bufferDeviceAddressMultiDevice']),
    (['Vulkan12Features', 'BufferDeviceAddressFeatures'], ['bufferDeviceAddressCaptureReplay']),
    (['Vulkan12Features', 'VulkanMemoryModelFeatures'], ['vulkanMemoryModel', 'vulkanMemoryModelDeviceScope', 'vulkanMemoryModelAvailabilityVisibilityChains']),

    (['Vulkan13Features', 'ImageRobustnessFeatures'], ['robustImageAccess']),
    (['Vulkan13Features', 'InlineUniformBlockFeatures'], ['inlineUniformBlock', 'descriptorBindingInlineUniformBlockUpdateAfterBind']),
    (['Vulkan13Features', 'PipelineCreationCacheControlFeatures'], ['pipelineCreationCacheControl']),
    (['Vulkan13Features', 'PrivateDataFeatures'], ['privateData']),
    (['Vulkan13Features', 'ShaderDemoteToHelperInvocationFeatures'], ['shaderDemoteToHelperInvocation']),
    (['Vulkan13Features', 'ShaderTerminateInvocationFeatures'], ['shaderTerminateInvocation']),
    (['Vulkan13Features', 'SubgroupSizeControlFeatures'], ['subgroupSizeControl', 'computeFullSubgroups']),
    (['Vulkan13Features', 'Synchronization2Features'], ['synchronization2']),
    (['Vulkan13Features', 'TextureCompressionASTCHDRFeatures'], ['textureCompressionASTC_HDR']),
    (['Vulkan13Features', 'ZeroInitializeWorkgroupMemoryFeatures'], ['shaderZeroInitializeWorkgroupMemory']),
    (['Vulkan13Features', 'DynamicRenderingFeatures'], ['dynamicRendering']),
    (['Vulkan13Features', 'ShaderIntegerDotProductFeatures'], ['shaderIntegerDotProduct']),
    (['Vulkan13Features', 'Maintenance4Features'], ['maintenance4']),
]

for (feature_structs, features) in KNOWN_ALIASES:
    for flag in features:
        for f in feature_structs:
            rename = (f, flag)
            assert rename not in RENAMED_FEATURES, f"{rename} already exists in RENAMED_FEATURES"
            RENAMED_FEATURES[rename] = flag

def get_renamed_feature(c_type, feature):
    return RENAMED_FEATURES.get((str_removeprefix(c_type, 'VkPhysicalDevice'), feature), feature)

@dataclass
class FeatureStruct:
    reqs: Requirements
    c_type: str
    s_type: str
    features: typing.List[str]

TEMPLATE_C = Template(COPYRIGHT + """
/* This file generated from ${filename}, don't edit directly. */

#include "wrapper_private.h"
#include "vk_physical_device_features.h"
#include "vk_util.h"

void
wrapper_setup_device_features(struct wrapper_physical_device *physical_device)
{
   VkPhysicalDevice vk_physical_device = physical_device->dispatch_handle;

   /* Query the device what kind of features are supported. */
   VkPhysicalDeviceFeatures2 supported_features2 = {
      .sType = VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2,
   };

% for f in feature_structs:
   ${f.c_type} supported_${f.c_type} = {
      .sType = ${f.s_type},
      .pNext = NULL,
   };
   __vk_append_struct(&supported_features2, &supported_${f.c_type});
% endfor

   physical_device->dispatch_table.GetPhysicalDeviceFeatures2(
      vk_physical_device, &supported_features2);

   vk_set_physical_device_features(&physical_device->vk.supported_features,
                                   &supported_features2);
}
""")

def get_pdev_features(doc):
    _type = doc.find(".types/type[@name='VkPhysicalDeviceFeatures']")
    if _type is not None:
        flags = []
        for p in _type.findall('./member'):
            assert p.find('./type').text == 'VkBool32'
            flags.append(p.find('./name').text)
        return flags
    return None

def filter_api(elem, api):
    if 'api' not in elem.attrib:
        return True

    return api in elem.attrib['api'].split(',')

def get_feature_structs(doc, api, beta):
    feature_structs = OrderedDict()

    required = get_all_required(doc, 'type', api, beta)

    # parse all struct types where structextends VkPhysicalDeviceFeatures2
    for _type in doc.findall('./types/type[@category="struct"]'):
        if _type.attrib.get('structextends') != 'VkPhysicalDeviceFeatures2,VkDeviceCreateInfo':
            continue
        if _type.attrib['name'] not in required:
            continue

        reqs = required[_type.attrib['name']]
        # Skip extensions with a define for now
        guard = reqs.guard
        if guard is not None and (guard != "VK_ENABLE_BETA_EXTENSIONS" or beta != "true"):
            continue

        # find Vulkan structure type
        for elem in _type:
            if "STRUCTURE_TYPE" in str(elem.attrib):
                s_type = elem.attrib.get('values')

        # collect a list of feature flags
        flags = []

        for p in _type.findall('./member'):
            if not filter_api(p, api):
                continue

            m_name = p.find('./name').text
            if m_name == 'pNext':
                pass
            elif m_name == 'sType':
                s_type = p.attrib.get('values')
            else:
                assert p.find('./type').text == 'VkBool32'
                flags.append(m_name)

        feature_struct = FeatureStruct(reqs=reqs, c_type=_type.attrib.get('name'), s_type=s_type, features=flags)
        feature_structs[feature_struct.c_type] = feature_struct

    return feature_structs.values()

def get_feature_structs_from_xml(xml_files, beta, api='vulkan'):
    diagnostics = []

    pdev_features = None
    feature_structs = []

    for filename in xml_files:
        doc = et.parse(filename)
        feature_structs += get_feature_structs(doc, api, beta)
        if not pdev_features:
            pdev_features = get_pdev_features(doc)

    unused_renames = {**RENAMED_FEATURES}

    features = OrderedDict()

    for flag in pdev_features:
        features[flag] = 'VkPhysicalDeviceFeatures'

    for f in feature_structs:
        for flag in f.features:
            renamed_flag = get_renamed_feature(f.c_type, flag)
            if renamed_flag not in features:
                features[renamed_flag] = f.c_type
            else:
                a = str_removeprefix(features[renamed_flag], 'VkPhysicalDevice')
                b = str_removeprefix(f.c_type, 'VkPhysicalDevice')
                if (a, flag) not in RENAMED_FEATURES or (b, flag) not in RENAMED_FEATURES:
                    diagnostics.append(f'{a} and {b} both define {flag}')

            unused_renames.pop((str_removeprefix(f.c_type, 'VkPhysicalDevice'), flag), None)

    for rename in unused_renames:
        diagnostics.append(f'unused rename {rename}')

    assert len(diagnostics) == 0, '\n'.join(diagnostics)

    return pdev_features, feature_structs, features


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--out-c', required=True, help='Output C file.')
    parser.add_argument('--beta', required=True, help='Enable beta extensions.')
    parser.add_argument('--xml',
                        help='Vulkan API XML file.',
                        required=True, action='append', dest='xml_files')
    args = parser.parse_args()

    pdev_features, feature_structs, all_flags = get_feature_structs_from_xml(args.xml_files, args.beta)

    environment = {
        'filename': os.path.basename(__file__),
        'pdev_features': pdev_features,
        'feature_structs': feature_structs,
        'all_flags': all_flags,
        'get_renamed_feature': get_renamed_feature,
    }

    try:
        with open(args.out_c, 'w', encoding='utf-8') as f:
            f.write(TEMPLATE_C.render(**environment))
    except Exception:
        # In the event there's an error, this uses some helpers from mako
        # to print a useful stack trace and prints it, then exits with
        # status 1, if python is run with debug; otherwise it just raises
        # the exception
        print(mako.exceptions.text_error_template().render(), file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()

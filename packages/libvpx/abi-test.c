#include <stdio.h>
#include "vpx/vpx_encoder.h"
#include "vpx/vpx_decoder.h"

int main() {
    printf("%d %d %d\n", VPX_CODEC_ABI_VERSION, VPX_ENCODER_ABI_VERSION, VPX_DECODER_ABI_VERSION);
}

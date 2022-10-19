#!/bin/sh

PRE_GENERATED_DUMP_DIR="$TERMUX_PKG_GIR_PRE_GENERATED_DUMP_DIR"
G_IR_COMPILER="${TERMUX_G_IR_COMPILER:-g-ir-compiler}"

ERROR_HEADER="gi-cross-launcher: ERROR:"

#logfile="$(readlink -f "$(dirname "$0")")/../gi-cross-launcher.log"
#echo "$@" >> "$logfile"

cmd="$1"
case "$cmd" in
    */g-ir-compiler | g-ir-compiler )
        shift
        for a in "$@"; do
            case "$a" in
                --shared-library=* | --shared-library )
                    echo "$ERROR_HEADER This script does not support --shared-library option for g-ir-compiler." >&2
                    echo "$ERROR_HEADER Command: $cmd $@" >&2
                    exit 1
                    ;;
            esac
        done
        exec "$G_IR_COMPILER" "$@"
        ;;
esac

arg="$2"
case "$arg" in
    --introspect-dump=*,* ) ;;
    * ) echo "$ERROR_HEADER Unsupported command: $@" >&2 ;;
esac

cmd_base="$(basename "$cmd")"
pre_gen="$PRE_GENERATED_DUMP_DIR/${cmd_base}.xml"
if [ ! -e "$pre_gen" ]; then
    echo "$ERROR_HEADER Pre-generated dump for $cmd_base not found." >&2
    echo "$ERROR_HEADER Expected file: $pre_gen" >&2
    exit 1
fi
dest_xml="${arg##*,}"
cp "$pre_gen" "$dest_xml" || exit 1

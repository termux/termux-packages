# Android 5 requires position-independent executables, so we use the
#   %{!S:X}     Substitutes X, if the -S switch is not given to GCC"
# construct (see https://gcc.gnu.org/onlinedocs/gcc/Spec-Files.html for full reference)
# to add -fPIE and -pie flags as appropriate.

*cc1_options:
+ %{!fpie: %{!fPIE: %{!fpic: %{!fPIC: %{!fno-pic:-fPIE}}}}}

*link:
+ %{!nopie: %{!static: %{!shared: %{!nostdlib: %{!nostartfiles: %{!fno-PIE: %{!fno-pie: -pie}}}}}}}

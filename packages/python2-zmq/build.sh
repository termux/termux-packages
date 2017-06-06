TERMUX_PKG_HOMEPAGE=https://pyzmq.readthedocs.io/en/latest/
TERMUX_PKG_DESCRIPTION="Python bindings for 0MQ library."
TERMUX_PKG_VERSION=15.2.0
TERMUX_PKG_BUILD_REVISION=1
TERMUX_PKG_SRCURL=https://pypi.python.org/packages/69/d8/5366d3ecb3907ea079483c38a7aa6c8902a44ca322ba2eece0d587707e2e/pyzmq-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="python2, libzmq"
TERMUX_PKG_BUILD_IN_SRC=yes


SITE_PACKAGES_DIR=${TERMUX_PREFIX}/lib/python2.7/site-packages/

termux_step_make () {
	# This compiles the C (Cython) extensions manually
	# It depends on having Python 2.7 already compiled and installed on $TERMUX_PREFIX
	for SRC in ${TERMUX_PKG_BUILDDIR}/zmq/{backend/cython/{socket,constants,_device,context,_version,error,message,_poll,utils},devices/monitoredqueue}.c
	do
		DEST=${SRC%.c}.so
		${CC} -shared -pthread -fPIC -fwrapv -Wall -fno-strict-aliasing ${CFLAGS} ${LDFLAGS} \
		      -I${TERMUX_PREFIX}/include -I${TERMUX_PREFIX}/include/python2.7 \
		      -I${TERMUX_PKG_BUILDDIR}/zmq/utils -lzmq -lpython2.7 -o ${DEST} ${SRC}
	done
}

termux_step_make_install () {
	# We don't want the tests nor the "Python 3 only" stuff
	rm -rf ${TERMUX_PKG_BUILDDIR}/zmq/{tests,asyncio.py,auth/asyncio.py}
	
	# Remove the Cython extensions source files
	find ${TERMUX_PKG_BUILDDIR}/zmq/backend/cython ${TERMUX_PKG_BUILDDIR}/zmq/devices \( -name \*.c -or -name \*.pyx -or -name \*.pxi \) -exec rm '{}' \;

	# Manually copy the rest of the files into the right places
	mv ${TERMUX_PKG_BUILDDIR}/PKG-INFO ${SITE_PACKAGES_DIR}/pyzmq-${TERMUX_PKG_VERSION}-py2.7.egg-info
	cp -R ${TERMUX_PKG_BUILDDIR}/zmq ${SITE_PACKAGES_DIR}

	# Create the precompiled files (*.pyc)
	python2.7 -m compileall ${SITE_PACKAGES_DIR}/zmq

	# Create 'compiler.json' file for cffi backend (not sure if is really needed...)
	cat << EOF > ${SITE_PACKAGES_DIR}/zmq/utils/compiler.json
{
  "extra_link_args": ["${LDFLAGS}"],
  "include_dirs": ["${TERMUX_PREFIX}/include", "${SITE_PACKAGES_DIR}/zmq/utils"],
  "runtime_library_dirs": ["${TERMUX_PREFIX}/lib"],
  "define_macros": [ ["HAVE_SYS_UN_H", 1] ],
  "libraries": ["zmq"],
  "library_dirs": ["${TERMUX_PREFIX}/lib"]
}
EOF
}
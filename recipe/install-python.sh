#!/bin/bash
set -eux

_builddir="_build${PY_VER}"
rm -rf ${_builddir}
mkdir -pv ${_builddir}
pushd ${_builddir}

# configure
cmake $SRC_DIR \
	-D_VERBOSE:BOOL=TRUE \
	-DBUILD_SHARED_LIBS:BOOL=TRUE \
	-DBUILD_TESTING:BOOL=FALSE \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
	-DCMAKE_INSTALL_LIBDIR:PATH="lib" \
	-DCMAKE_INSTALL_PREFIX:PATH="${PREFIX}" \
	-DENABLE_JAVA_TESTS:BOOL=FALSE \
	-DHAVE_BOINC:BOOL=FALSE \
	-DHAVE_EXT_GLOBUS:BOOL=FALSE \
	-DPROPER:BOOL=TRUE \
	-DPYTHON_EXECUTABLE:PATH=FALSE \
	-DPYTHON3_EXECUTABLE:PATH="${PYTHON}" \
	-DPYTHON3_BOOST_LIB:STRING=boost_python${PY_VER/./} \
	-DUW_BUILD:BOOL=FALSE \
	-DWANT_FULL_DEPLOYMENT:BOOL=FALSE \
	-DWANT_MAN_PAGES:BOOL=FALSE \
	-DWITH_BLAHP:BOOL=FALSE \
	-DWITH_BOINC:BOOL=FALSE \
	-DWITH_CREAM:BOOL=FALSE \
	-DWITH_GANGLIA:BOOL=FALSE \
	-DWITH_GLOBUS:BOOL=FALSE \
	-DWITH_KRB5:BOOL=FALSE \
	-DWITH_MUNGE:BOOL=FALSE \
	-DWITH_PYTHON_BINDINGS:BOOL=TRUE \
	-DWITH_SCITOKENS:BOOL=FALSE \
	-DWITH_VOMS:BOOL=FALSE

# build
cmake --build src/python-bindings --parallel ${CPU_COUNT}
cmake --build bindings/python --parallel ${CPU_COUNT}

# install
cmake --build src/python-bindings --parallel ${CPU_COUNT} --target install
cmake --build bindings/python --parallel ${CPU_COUNT} --target install

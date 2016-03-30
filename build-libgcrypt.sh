#!/bin/bash
# build-libgcrypt.sh
# *****************************************************************************
# Author:   Charles Munson <jetwhiz@jetwhiz.com>
# 
# ****************************************************************************
# Copyright (c) 2016, Charles Munson
# 
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published by the
# Free Software Foundation, either version 3 of the License, or (at your
# option) any later version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License
# for more details.
# 
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


# We need to find out where we are (pwd of script)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Define some important paths 
LIBGCRYPT_INSTALL_DIR=$DIR/deps/libgcrypt/install-dir
LIBGPGERROR_INSTALL_DIR=$DIR/deps/libgpg-error/install-dir

# Move into script's directory, then descend into libgcrypt folder 
cd "$DIR/deps/libgcrypt"

# Get rid of requirement to build documentation (msys missing reqd sw) 
patch Makefile.am ../libgcrypt.patch

# Configure libgcrypt
./autogen.sh
./configure --enable-maintainer-mode --prefix=$LIBGCRYPT_INSTALL_DIR --with-gpg-error-prefix=$LIBGPGERROR_INSTALL_DIR

# Make libgcrypt
make install


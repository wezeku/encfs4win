#!/bin/bash
# build-libgpgerror.sh
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
INSTALL_DIR=$DIR/deps/libgpg-error/install-dir

# Move into script's directory, then descend into libgpg-error folder 
cd "$DIR/deps/libgpg-error"

# Configure libgpg-error
./autogen.sh
./configure --enable-maintainer-mode --prefix=$INSTALL_DIR

# Add mingw shim (msys doesn't define EWOULDBLOCK) 
echo "#define EWOULDBLOCK WSAEWOULDBLOCK" >> config.h

# Make libgpg-error
make install


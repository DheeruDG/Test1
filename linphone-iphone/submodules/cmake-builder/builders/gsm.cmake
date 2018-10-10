############################################################################
# gsm.cmake
# Copyright (C) 2014  Belledonne Communications, Grenoble France
#
############################################################################
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
############################################################################

set(EP_gsm_GIT_REPOSITORY "git://git.linphone.org/gsm.git" CACHE STRING "gsm repository URL")
set(EP_gsm_GIT_TAG_LATEST "linphone" CACHE STRING "gsm tag to use when compiling latest version")
set(EP_gsm_GIT_TAG "0f8822b5326c76bb9dc4c6b552631f51792c3982" CACHE STRING "gsm tag to use")
set(EP_gsm_EXTERNAL_SOURCE_PATHS "gsm" "externals/gsm")
set(EP_gsm_MAY_BE_FOUND_ON_SYSTEM TRUE)
set(EP_gsm_IGNORE_WARNINGS TRUE)

set(EP_gsm_LINKING_TYPE ${DEFAULT_VALUE_CMAKE_LINKING_TYPE})

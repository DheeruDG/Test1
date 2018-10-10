############################################################################
# belr.cmake
# Copyright (C) 2015  Belledonne Communications, Grenoble France
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

set(EP_belr_GIT_REPOSITORY "git://git.linphone.org/belr.git" CACHE STRING "belr repository URL")
set(EP_belr_GIT_TAG_LATEST "master" CACHE STRING "belr tag to use when compiling latest version")
set(EP_belr_EXTERNAL_SOURCE_PATHS "belr")
set(EP_belr_GROUPABLE YES)

if(EP_belr_FORCE_AUTOTOOLS)
	set(EP_belr_LINKING_TYPE "--enable-static")
	set(EP_belr_USE_AUTOGEN True)
else()
	set(EP_belr_LINKING_TYPE ${DEFAULT_VALUE_CMAKE_LINKING_TYPE})
endif()
set(EP_belr_DEPENDENCIES EP_bctoolbox)

# TODO: Activate strict compilation options on IOS
if(IOS)
	list(APPEND EP_belr_CMAKE_OPTIONS "-DENABLE_STRICT=NO")
endif()

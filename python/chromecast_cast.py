 ##########################################################################
 ##                                                                      ##
 ## Copyright (C) 2011-2025 Lukas Spies                                  ##
 ## Contact: https://photoqt.org                                         ##
 ##                                                                      ##
 ## This file is part of PhotoQt.                                        ##
 ##                                                                      ##
 ## PhotoQt is free software: you can redistribute it and/or modify      ##
 ## it under the terms of the GNU General Public License as published by ##
 ## the Free Software Foundation, either version 2 of the License, or    ##
 ## (at your option) any later version.                                  ##
 ##                                                                      ##
 ## PhotoQt is distributed in the hope that it will be useful,           ##
 ## but WITHOUT ANY WARRANTY; without even the implied warranty of       ##
 ## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        ##
 ## GNU General Public License for more details.                         ##
 ##                                                                      ##
 ## You should have received a copy of the GNU General Public License    ##
 ## along with PhotoQt. If not, see <http://www.gnu.org/licenses/>.      ##
 ##                                                                      ##
 ##########################################################################

import pychromecast
import sys
import time

name = sys.argv[1]
ip = sys.argv[2]
port = sys.argv[3]

chromecasts, browser = pychromecast.get_listed_chromecasts(friendly_names=[name])
cast = chromecasts[0]
cast.wait()

mc = cast.media_controller
mc.play_media(f"http://{ip}:{port}/{time.time()}", "image/jpg")
mc.block_until_active()

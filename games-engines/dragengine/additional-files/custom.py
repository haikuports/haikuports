# configuration for haiku package building
############################################

# general configuration
#########################
with_tests = 'no'
with_warnerrors = 'no'
with_debug = 'no'
with_verbose = 'no'

# external library configuration
##################################
# use as many system libraries as possible
with_system_zlib = 'yes'
with_system_libpng = 'yes'
with_system_libjpeg = 'yes'
with_system_openal = 'yes'
with_system_libogg = 'yes'
with_system_libvorbis = 'yes'
with_system_libtheora = 'yes'
with_system_soundtouch = 'yes'
with_opengl = 'yes'
with_dl = 'no'
with_pthread = 'yes'
with_x = 'no'

# these are not used since python and npapisdk are disabled. set to in-tree
# to not upset the build system although they will never be build at all
with_python = 'no'
with_npapisdk = 'no'

# libapng requires a patched libpng not present on most systems
with_system_libapng ='no'  # patched version

# these packages cause troubles on haiku and are build in-tree
with_system_libhidapi = 'no'  # requires libhidapi-usb which is missing

# these packages do not exist on haiku so we need to build them in-tree
with_system_fox ='no'
with_system_libopenhmd = 'no'
with_system_libevdev = 'no'
with_system_dragonscript = 'no'

# libusb is required by libhidapi
with_system_libusb = 'yes'

# these are only required for the smalltalk module which is currently not build.
# to not upset the build system with not finding packages they are set to in-tree
# building although they will never be build at all
with_system_libffi = 'no'
with_system_libltdl = 'no'
with_system_libsigsegv = 'no'
with_system_smalltalk = 'no'

# this package is not used right now but might be later on by the openal module.
# as with the smalltalk case above this package is set to in-tree building
# although it will never be build at all
with_system_fftw = 'no'

# module configurations
#########################
build_audio_openal = 'yes'
build_cr_basic = 'no'  # requires fox
build_graphics_opengl = 'yes'
build_image_png = 'yes'
build_image_png3d = 'yes'
build_image_jpeg = 'yes'
build_input_beos = 'yes'
build_physics_bullet = 'yes'
build_script_ds = 'yes'
build_sound_ogg = 'yes'
build_video_theora = 'yes'
build_video_apng = 'yes'
build_igde = 'no'
build_guilauncher = 'no'
build_archive_delga = 'yes'

build_input_w32 = 'no'
build_input_x = 'no'
build_input_macos = 'no'
build_input_android = 'no'
build_script_python = 'no'
build_script_smalltalk = 'no'
build_plugin_npapi = 'no'
build_launcher_android = 'no'

# archiving
#############
# for testing purpose only 
archive_format = 'tarbz2'
archive_name_engine = 'dragengine-haiku'
archive_name_engine_dev = 'dragengine-dev-haiku'
archive_name_igde = 'igde-haiku'
archive_name_igde_dev = 'igde-dev-haiku'
archive_name_special = 'despecial-haiku'
installer_name_engine = 'install-dragengine-haiku'
installer_name_engine_dev = 'install-dragengine-dev-haiku'
installer_name_igde = 'install-deigde-haiku'
installer_name_igde_dev = 'install-deigde-dev-haiku'

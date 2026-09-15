# Hand-written replacement for the cmake manifest
# cmake generated when the recipe was built with cmake.
include(CMakeFindDependencyMacro)
find_dependency(Threads)

include("${CMAKE_CURRENT_LIST_DIR}/zstdTargets.cmake")

foreach(_zstd_comp ${zstd_FIND_COMPONENTS})
	if(zstd_FIND_REQUIRED_${_zstd_comp})
		set(zstd_FOUND FALSE)
	endif()
endforeach()

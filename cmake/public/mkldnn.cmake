set(MKLDNN_USE_NATIVE_ARCH ${USE_NATIVE_ARCH})

if(CPU_AARCH64)
  include(${CMAKE_CURRENT_LIST_DIR}/ComputeLibrary.cmake)
endif()

find_package(MKLDNN QUIET)

if(NOT TARGET caffe2::mkldnn)
  add_library(caffe2::mkldnn INTERFACE IMPORTED)
endif()

set_property(
  TARGET caffe2::mkldnn PROPERTY INTERFACE_INCLUDE_DIRECTORIES
  ${MKLDNN_INCLUDE_DIR})
set_property(
  TARGET caffe2::mkldnn PROPERTY INTERFACE_LINK_LIBRARIES
  ${MKLDNN_LIBRARIES})
if(BUILD_ONEDNN_GRAPH)
  if(NOT TARGET caffe2::dnnl_graph)
    add_library(caffe2::dnnl_graph INTERFACE IMPORTED)
  endif()

  set_property(
    TARGET caffe2::dnnl_graph PROPERTY INTERFACE_INCLUDE_DIRECTORIES
    ${MKLDNN_INCLUDE_DIR})
  set_property(
    TARGET caffe2::dnnl_graph PROPERTY INTERFACE_LINK_LIBRARIES
    ${MKLDNN_LIBRARIES})
  if(DNNL_GRAPH_BUILD_COMPILER_BACKEND)
    if(NOT TARGET caffe2::graphcompiler)
      add_library(caffe2::graphcompiler INTERFACE IMPORTED)
    endif()
    get_target_property(DNNL_GRAPHCOMPILER_LLVM_LIB dnnl_graphcompiler_llvm_lib INTERFACE_LINK_LIBRARIES)
    list(APPEND MKLDNN_LIBRARIES ${DNNL_GRAPHCOMPILER_LLVM_LIB})
    set_property(
      TARGET caffe2::graphcompiler PROPERTY INTERFACE_INCLUDE_DIRECTORIES
      ${MKLDNN_INCLUDE_DIR})
    set_property(
      TARGET caffe2::graphcompiler PROPERTY INTERFACE_LINK_LIBRARIES
      ${MKLDNN_LIBRARIES})
  endif()
endif()

#============================================================
#
# Name    = PythonSetup.cmake
# Purpose = Determine locations of Python library for use by SWIG
# Usage   = add "include( PythonSetup.cmake )" to the appropriate CMakeLists.txt
#
# Scheme  = Top-Level CMakeLists.txt includes this present file
#           First step herein is to look for a CustomPythonSetup.cmake
#           If that fails, this file then tries the "normal" method to find PythonLibs
#           If CMake cannot figure out which Python library to use by that method
#           then modify the template CustomPythonSetup.cmake file to explicitly
#           define the paths to the python library and headers you wish SWIG to use.
#
# Reason  = On systems where the user may have many installations
#           of python, e.g. RedHat or OSX where the system version of Python
#           is an old version not really intended for daily user use, so the user often
#           installs an additional python environment from source or with some package manager.
#           CMake find_package( PythonLibs ) will often stumble on pieces of multiple Python installs
#           in an order that results in mismatching version numbers for the python library
#           and the python include files, and thus cannot build the
#           typemaps for wrapping the C++ code.
#
#============================================================


#------------------------------------------------------------
# If the user provides a custom Python configuration, use it
#------------------------------------------------------------

include( CustomPythonSetup.cmake
         OPTIONAL
         RESULT_VARIABLE PYTHON_CUSTOM_CONFIG )

#------------------------------------------------------------
# If a user-specified python configuration is not found, let CMake try to find the system python
#------------------------------------------------------------
if( ${PYTHON_CUSTOM_CONFIG} MATCHES "NOTFOUND" )


find_package (Python3 3.6 REQUIRED COMPONENTS Interpreter Development)

message(STATUS "Found ${Python3_EXECUTABLE}")
set(CMAKE_INCLUDE_PATH ${Python3_INCLUDE_DIRS})
set(PYTHON_INCLUDE_DIR ${Python3_INCLUDE_DIRS})
include_directories(${Python3_INCLUDE_DIRS})

message(STATUS "Python libs: ${Python3_LIBRARIES}")
message(STATUS "Python include: ${Python3_INCLUDE_DIRS}")
message(STATUS "Installing python module to: ${Python3_SITELIB}")
set(PYTHON_INSTALL_PREFIX ${Python3_SITELIB})

endif()


#------------------------------------------------------------
# Debug messaging
#------------------------------------------------------------
if( DEBUG_SWITCH OR NOT PYTHONLIBS_FOUND)
  message( STATUS "PYTHONINTERP_FOUND        = ${Python3_Interpreter_FOUND}" )
  message( STATUS "PYTHON_EXECUTABLE         = ${Python3_EXECUTABLE}" )
  message( STATUS "PYTHON_VERSION_STRING     = ${Python3_VERSION}" )
  message( STATUS "PYTHONLIBS_FOUND          = ${Python3_LIBRARIES}" )
  message( STATUS "PYTHON_LIBRARIES          = ${Python3_LIBRARIES}" )
  message( STATUS "PYTHON_INCLUDE_DIR        = ${Python3_INCLUDE_DIRS}" )
  message( STATUS "PYTHON_INCLUDE_DIRS       = ${Python3_INCLUDE_DIRS}" )
  #message( STATUS "PYTHONLIBS_VERSION_STRING = ${Python3LIBS_VERSION_STRING}" )
  message( STATUS "PYTHON_INSTALL_LOCATION     = ${Python3_SITELIB}" )
endif()

#------------------------------------------------------------
# Consistent python library and headers could not be found
#------------------------------------------------------------
if( NOT Python3_FOUND)
  message( STATUS "Cannot find requested version of Python components on your system." )
  message( STATUS "Cannot build swig bindings without the right python libraries." )
  message( STATUS "PYTHON_LIBRARY and PYTHON_INCLUDE_DIR versions must match PYTHON_EXECUTABLE." )
  message( FATAL_ERROR "Cannot find PYTHONLIBS. Cannot proceed. Exiting now!" )
  return()
endif()

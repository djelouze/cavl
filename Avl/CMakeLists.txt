CMAKE_MINIMUM_REQUIRED( VERSION 2.8 )

PROJECT( Avl )
ENABLE_LANGUAGE( Fortran )

# make sure that the default is a RELEASE
IF (NOT CMAKE_BUILD_TYPE)
  SET (CMAKE_BUILD_TYPE RELEASE CACHE STRING
      "Choose the type of build, options are: None Debug Release."
      FORCE)
ENDIF (NOT CMAKE_BUILD_TYPE)

# default installation
GET_FILENAME_COMPONENT (default_prefix ".." ABSOLUTE)
SET (CMAKE_INSTALL_PREFIX ${default_prefix} CACHE STRING
      "Choose the installation directory; by default it installs in the NORMA directory."
      FORCE)

# FFLAGS depend on the compiler
GET_FILENAME_COMPONENT (Fortran_COMPILER_NAME ${CMAKE_Fortran_COMPILER} NAME)

IF (Fortran_COMPILER_NAME MATCHES "gfortran.*")
  # gfortran
  SET (CMAKE_Fortran_FLAGS_RELEASE "-funroll-all-loops -fno-f2c -O3")
  SET (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g")
ELSEIF (Fortran_COMPILER_NAME MATCHES "ifort.*")
  # ifort (untested)
  SET (CMAKE_Fortran_FLAGS_RELEASE "-f77rtl -O3")
  SET (CMAKE_Fortran_FLAGS_DEBUG   "-f77rtl -O0 -g")
ELSEIF (Fortran_COMPILER_NAME MATCHES "g77")
  # g77
  SET (CMAKE_Fortran_FLAGS_RELEASE "-funroll-all-loops -fno-f2c -O3 -m32")
  SET (CMAKE_Fortran_FLAGS_DEBUG   "-fno-f2c -O0 -g -m32")
ELSE (Fortran_COMPILER_NAME MATCHES "gfortran.*")
  MESSAGE ("CMAKE_Fortran_COMPILER full path: " ${CMAKE_Fortran_COMPILER})
  MESSAGE ("Fortran compiler: " ${Fortran_COMPILER_NAME})
  MESSAGE ("No optimized Fortran compiler flags are known, we just try -O2...")
  SET (CMAKE_Fortran_FLAGS_RELEASE "-O2")
  SET (CMAKE_Fortran_FLAGS_DEBUG   "-O0 -g")
ENDIF (Fortran_COMPILER_NAME MATCHES "gfortran.*")

ADD_SUBDIRECTORY( eispack )
ADD_SUBDIRECTORY( plotlib )

INCLUDE_DIRECTORIES( src )

SET( SRCS 
./src/aoper.f 
./src/amode.f 
./src/amass.f 
./src/asetup.f
./src/amake.f 
./src/ainput.f 
./src/aoutput.f 
./src/aero.f 
./src/atrim.f 
./src/atpforc.f
./src/aic.f 
./src/cdcl.f 
./src/airutil.f 
./src/autil.f
./src/aplotvl.f 
./src/aplottp.f 
./src/aplotmd.f 
./src/limits.f
./src/pltops.f 
./src/hidden.f
./src/plsubs.f 
./src/userio.f 
./src/plutil.f 
./src/arrow3d.f 
./src/getvm.f 
./src/matrix.f 
./src/spline.f 
./src/sgutil.f 
./src/second_g77.f
)

ADD_LIBRARY (avlCore ${SRCS} ./src/avl2.f)
TARGET_LINK_LIBRARIES( avlCore plotlib X11 eispack gfortran)

ADD_EXECUTABLE (avl ${SRCS} ./src/avl.f )
TARGET_LINK_LIBRARIES( avl plotlib X11 eispack )


CMAKE_MINIMUM_REQUIRED( VERSION 2.8 )
PROJECT( Cavl )

ADD_EXECUTABLE( cavl cavl.cxx )

SET( Avl_PATH STRING CACHE PATH "Path to Fortran Avl binaries" )
MESSAGE(${Avl_PATH}/libavlCore2.a)
TARGET_LINK_LIBRARIES( cavl 
${Avl_PATH}/libavlCore.a 
${Avl_PATH}/eispack/libeispack.a 
${Avl_PATH}/plotlib/libplotlib.a 
gfortran 
X11)  


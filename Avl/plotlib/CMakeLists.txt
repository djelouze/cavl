INCLUDE_DIRECTORIES( ${CMAKE_CURRENT_DIR} )

SET( FC_SRCS 
plt_base.f
plt_color.f
plt_font.f
plt_util.f
plt_3D.f
plt_old.f
set_subs.f
gw_subs.f
ps_subs.f
util-ops.f
)

SET( C_SRCS
Xwin.c
)

SET( CMAKE_C_FLAGS -DUNDERSCORE )

ADD_LIBRARY( plotlib STATIC ${FC_SRCS} ${C_SRCS})
TARGET_LINK_LIBRARIES( plotlib X11 gfortran)


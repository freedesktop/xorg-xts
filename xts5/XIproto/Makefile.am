include ../common.mk
AUTOMAKE_OPTIONS = subdir-objects

AM_CFLAGS = -I$(top_srcdir)/include \
	-I$(top_srcdir)/src/tet3/inc \
	-I$(top_srcdir)/xts5/include \
	$(XTS_CFLAGS)
LDADD = $(top_builddir)/src/tet3/tcm/libtcmmain.la \
	$(top_builddir)/xts5/src/libxts5proto.la \
	$(top_builddir)/xts5/src/libxts5.la \
	$(top_builddir)/src/tet3/apilib/libapi.la \
	$(top_builddir)/src/tet3/apilib/libapi_s.la \
	$(XTS_LIBS)

testprogdir = $(libexecdir)/$(subdir)
nobase_testprog_PROGRAMS = $(tprogs)
BUILT_SOURCES = $(tprogs:=.c)
EXTRA_DIST = $(addsuffix .m,$(filter-out %_m,$(tprogs)))
DISTCLEANFILES = $(BUILT_SOURCES)

tprogs = \
	AllowDeviceEvents \
	ChangeDeviceControl \
	ChangeDeviceDontPropagateList \
	ChangeFeedbackControl \
	ChangeKeyboardDevice \
	ChangePointerDevice \
	ChangeDeviceKeyMapping \
	CloseDevice \
	DeviceBell \
	GetDeviceModifierMapping \
	GetFeedbackControl \
	GetExtensionVersion \
	GrabDevice \
	GrabDeviceButton \
	GrabDeviceKey \
	GetDeviceButtonMapping \
	GetDeviceControl \
	GetDeviceFocus \
	GetDeviceMotionEvents \
	GetDeviceDontPropagateList \
	GetDeviceKeyMapping \
	GetSelectedExtensionEvents \
	ListInputDevices \
	Miscellaneous \
	OpenDevice \
	QueryDeviceState \
	SetDeviceValuators \
	SetDeviceButtonMapping \
	SetDeviceFocus \
	SetDeviceModifierMapping \
	SetDeviceMode \
	SelectExtensionEvent \
	SendExtensionEvent \
	UngrabDevice \
	UngrabDeviceButton \
	UngrabDeviceKey

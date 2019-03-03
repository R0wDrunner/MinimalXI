include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MinimalXI
MinimalXI_FILES = Tweak.xm

ARCHS = arm64

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += minimalxi
include $(THEOS_MAKE_PATH)/aggregate.mk

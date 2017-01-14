ARCHS = armv7 arm64
TARGET = iphone:9.2
CFLAGS = -fobjc-arc -O2

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Protean

Protean_FILES = $(wildcard *.xm) $(wildcard *.mm) $(wildcard *.m)


Protean_FRAMEWORKS = UIKit CoreGraphics QuartzCore
Protean_LIBRARIES = flipswitch IOKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += proteansettings
include $(THEOS_MAKE_PATH)/aggregate.mk

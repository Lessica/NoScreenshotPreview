TARGET := iphone:clang:latest:14.0
ARCHS := arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard ScreenshotServicesService

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoScreenshotPreview
NoScreenshotPreview_FILES = Tweak.xm
NoScreenshotPreview_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
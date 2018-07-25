include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = MinimalXI
MinimalXI_FILES = MXIRootListController.m IOSConceptStyle.m Safari.m SystemWide.m
MinimalXI_INSTALL_PATH = /Library/PreferenceBundles
MinimalXI_FRAMEWORKS = UIKit
MinimalXI_PRIVATE_FRAMEWORKS = Preferences
MinimalXI_EXTRA_FRAMEWORKS = Cephei CepheiPrefs


include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/MinimalXI.plist$(ECHO_END)

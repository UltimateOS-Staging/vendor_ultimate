# Allow vendor/extra to override any property by setting it first
$(call inherit-product-if-exists, vendor/extra/product.mk)

PRODUCT_BRAND ?= UltimateOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/ultimate/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/ultimate/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/ultimate/prebuilt/common/bin/50-ultimate.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-ultimate.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/addon.d/50-ultimate.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/ultimate/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/ultimate/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/ultimate/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/backuptool_ab.sh \
    system/bin/backuptool_ab.functions \
    system/bin/backuptool_postinstall.sh

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Ultimate-specific init rc file
PRODUCT_COPY_FILES += \
    vendor/ultimate/prebuilt/common/etc/init/init.ultimate-system_ext.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.ultimate-system_ext.rc

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_PRODUCT)/usr/keylayout/Vendor_045e_Product_0719.kl

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

# TextClassifier
PRODUCT_PACKAGES += \
    libtextclassifier_annotator_en_model \
    libtextclassifier_annotator_universal_model \
    libtextclassifier_actions_suggestions_universal_model \
    libtextclassifier_lang_id_model

# Google Photos Pixel Exclusive XML
PRODUCT_COPY_FILES += \
    vendor/ultimate/prebuilt/common/etc/sysconfig/pixel_2016_exclusive.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/sysconfig/pixel_2016_exclusive.xml

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
WITH_DEXPREOPT_DEBUG_INFO := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Enable whole-program R8 Java optimizations for SystemUI and system_server,
# but also allow explicit overriding for testing and development.
SYSTEM_OPTIMIZE_JAVA ?= true
SYSTEMUI_OPTIMIZE_JAVA ?= true

# Speed profile services and wifi-service to reduce RAM and storage
PRODUCT_SYSTEM_SERVER_COMPILER_FILTER := speed-profile

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# BatteryStatsViewer
PRODUCT_PACKAGES += \
    BatteryStatsViewer

# BtHelper
PRODUCT_PACKAGES += \
    BtHelper

ifeq ($(USE_PIXEL_CHARGER),true)
# Charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images \
    product_charger_res_images_vendor
endif

ifeq ($(ULTIMATE_OFFICIAL), true)
# Ultimate packages
PRODUCT_PACKAGES += \
    Updater

PRODUCT_COPY_FILES += \
    vendor/ultimate/prebuilt/common/etc/init/init.ultimate-updater.rc:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/init/init.ultimate-updater.rc
endif

# Disable RescueParty due to high risk of data loss
PRODUCT_PRODUCT_PROPERTIES += \
    persist.sys.disable_rescue=true

# Extra tools in Ultimate
PRODUCT_PACKAGES += \
    bash \
    curl \
    getcap \
    htop \
    nano \
    setcap \
    vim

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/curl \
    system/bin/getcap \
    system/bin/setcap

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mkfs.ntfs \
    mount.ntfs

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/fsck.ntfs \
    system/bin/mkfs.ntfs \
    system/bin/mount.ntfs \
    system/%/libfuse-lite.so \
    system/%/libntfs-3g.so

# GameSpace
PRODUCT_PACKAGES += \
    GameSpace

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

PRODUCT_COPY_FILES += \
    vendor/ultimate/prebuilt/common/etc/init/init.openssh.rc:$(TARGET_COPY_OUT_PRODUCT)/etc/init/init.openssh.rc

# Overlay
PRODUCT_PRODUCT_PROPERTIES += \
    ro.boot.vendor.overlay.theme=com.android.internal.systemui.navbar.gestural;com.google.android.systemui.gxoverlay

PRODUCT_PACKAGE_OVERLAYS += \
    vendor/ultimate/overlay/common

PRODUCT_PACKAGES += \
    AndroidBlackThemeOverlay \
    DocumentsUIOverlay \
    NavigationBarNoHintOverlay \
    NetworkStackOverlay

# OmniJaws service
PRODUCT_PACKAGES += \
    OmniJaws

# Permissions
PRODUCT_COPY_FILES += \
    vendor/ultimate/config/permissions/privapp-permissions-settings.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-settings.xml

# Launcher3
PRODUCT_PACKAGES += \
    Launcher3QuickStep

ifeq ($(TARGET_SUPPORTS_64_BIT_APPS),true)
PRODUCT_PACKAGES += \
    FaceUnlock

PRODUCT_SYSTEM_EXT_PROPERTIES += \
    ro.face.sense_service=true

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# rsync
PRODUCT_PACKAGES += \
    rsync

# Skip boot JAR checks.
SKIP_BOOT_JARS_CHECK := true

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Workaround AOSP AM crash
PRODUCT_PROPERTY_OVERRIDES += \
    sys.fflag.override.settings_enable_monitor_phantom_procs=false

# TouchGestures
PRODUCT_PACKAGES += \
    TouchGestures

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/bin/procmem
endif

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su

PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/xbin/su
endif
endif

# SystemUI
PRODUCT_DEXPREOPT_SPEED_APPS += \
    Launcher3QuickStep \
    Settings \
    CarSystemUI \
    SystemUI

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.systemuicompilerfilter=speed

# ThemePicker
PRODUCT_PACKAGES += \
    ThemePicker
    
# Translations
CUSTOM_LOCALES += \
    ast_ES \
    gd_GB \
    cy_GB \
    fur_IT

# Bootanimation
$(call inherit-product, vendor/ultimate/config/bootanimation.mk)

# Inherit GMS Services
$(call inherit-product, vendor/gms/products/gms.mk)

# Fonts
include vendor/ultimate/config/fonts.mk

include vendor/ultimate/config/version.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk

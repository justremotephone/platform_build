# Target-specific configuration

# Populate the qcom hardware variants in the project pathmap.
define ril-set-path-variant
$(call project-set-path-variant,ril,TARGET_RIL_VARIANT,hardware/$(1))
endef
define wlan-set-path-variant
$(call project-set-path-variant,wlan,TARGET_WLAN_VARIANT,hardware/qcom/$(1))
endef
define bt-vendor-set-path-variant
$(call project-set-path-variant,bt-vendor,TARGET_BT_VENDOR_VARIANT,hardware/qcom/$(1))
endef

# Set device-specific HALs into project pathmap
define set-device-specific-path
$(call project-set-path,qcom-$(2),$(strip $(if $(USE_DEVICE_SPECIFIC_$(1)), \
    $(TARGET_DEVICE_DIR)/$(2), $(3))))
endef

# Enable DirectTrack on QCOM legacy boards
ifeq ($(BOARD_USES_QCOM_HARDWARE),true)

    qcom_flags := -DQCOM_HARDWARE
    qcom_flags += -DQCOM_BSP
    qcom_flags += -DQTI_BSP

    TARGET_USES_QCOM_BSP := true
    TARGET_ENABLE_QC_AV_ENHANCEMENTS := true

    # Tell HALs that we're compiling an AOSP build with an in-line kernel
    TARGET_COMPILE_WITH_MSM_KERNEL := true

    ifneq ($(filter msm7x30 msm8660 msm8960,$(TARGET_BOARD_PLATFORM)),)
        # Enable legacy graphics functions
        qcom_flags += -DQCOM_BSP_LEGACY
    endif

    TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)
    CLANG_TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    CLANG_TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)

    # Multiarch needs these too..
    2ND_TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    2ND_TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)
    2ND_CLANG_TARGET_GLOBAL_CFLAGS += $(qcom_flags)
    2ND_CLANG_TARGET_GLOBAL_CPPFLAGS += $(qcom_flags)

$(call project-set-path,qcom-audio,hardware/qcom/audio-caf/$(TARGET_BOARD_PLATFORM))
$(call project-set-path,qcom-display,hardware/qcom/display-caf/$(TARGET_BOARD_PLATFORM))
$(call project-set-path,qcom-media,hardware/qcom/media-caf/$(TARGET_BOARD_PLATFORM))

$(call set-device-specific-path,CAMERA,camera,hardware/qcom/camera)
$(call set-device-specific-path,GPS,gps,hardware/qcom/gps)
$(call set-device-specific-path,SENSORS,sensors,hardware/qcom/sensors)
$(call set-device-specific-path,LOC_API,loc-api,vendor/qcom/opensource/location)

$(call ril-set-path-variant,ril)
$(call wlan-set-path-variant,wlan-caf)
$(call bt-vendor-set-path-variant,bt-caf)

else

$(call project-set-path,qcom-audio,hardware/qcom/audio/default)
$(call project-set-path,qcom-display,hardware/qcom/display/$(TARGET_BOARD_PLATFORM))
$(call project-set-path,qcom-media,hardware/qcom/media/default)

$(call project-set-path,CAMERA,hardware/qcom/camera)
$(call project-set-path,GPS,hardware/qcom/gps)
$(call project-set-path,SENSORS,hardware/qcom/sensors)
$(call project-set-path,LOC_API,vendor/qcom/opensource/location)

$(call ril-set-path-variant,ril)
$(call wlan-set-path-variant,wlan)
$(call bt-vendor-set-path-variant,bt)

endif

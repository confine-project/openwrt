BOARDNAME:=Linux Container (LXC) Host System Target
FEATURES:=squashfs jffs2 ext4 pci usb gpio

DEFAULT_PACKAGES += \
	kmod-3c59x kmod-e100 kmod-e1000 kmod-natsemi kmod-ne2k-pci \
	kmod-pcnet32 kmod-8139too kmod-r8169 kmod-sis900 kmod-tg3 \
	kmod-via-rhine kmod-via-velocity \
	\
	kmod-cfg80211 kmod-mac80211 \
	kmod-ath5k kmod-ath9k \
	kmod-crypto-hw-geode kmod-crypto-ocf kmod-crypto-aes kmod-crypto-cbc \
	kmod-usb-core kmod-usb2 kmod-usb-ohci \
	kmod-gpio-cs5535-new kmod-gpio-nsc \
	kmod-wdt-geode kmod-cs5535-clockevt kmod-cs5535-mfgpt \
	kmod-cs5536 \
	kmod-hwmon-core kmod-hwmon-lm90 \
	kmod-i2c-core kmod-i2c-gpio \
	kmod-i2c-algo-bit kmod-i2c-algo-pca kmod-i2c-algo-pcf \
	kmod-i2c-scx200-acb \
	kmod-mppe kmod-pppoe kmod-pppo2ltp \
	kmod-leds-gpio kmod-input-gpio-keys-polled \
	kmod-button-hotplug \
	kmod-ledtrig-heartbeat kmod-ledtrig-gpio \
	kmod-ledtrig-netdev \
	kmod-cpu-msr hwclock wpad \


define Target/Description
	Build firmware images suitable to host Linux container (LXC) guests
endef

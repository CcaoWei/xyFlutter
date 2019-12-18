FLUTTER_SRC_FILES := $(shell find . -name \*.dart \
	! -regex .*lib/mqtt/.* \
	! -regex .*lib/http/.* \
	! -regex .*lib/protocol/.* \
)

# force add some local files that are excluded from find result
FLUTTER_SRC_FILES += \
	./lib/mqtt/client.dart \
	./lib/mqtt/mqtt_proxy.dart \
	./lib/http/http_proxy.dart \
	./lib/http/http_service.dart \


.PHONY: android ios

ios:
	flutter build ios --release

android:
	flutter build apk --release

lint:
	dartanalyzer -v ${FLUTTER_SRC_FILES}

checkformat:
	flutter format -n --set-exit-if-changed ${FLUTTER_SRC_FILES}

format:
	flutter format ${FLUTTER_SRC_FILES}

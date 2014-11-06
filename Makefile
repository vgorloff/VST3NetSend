# Common settings
AWL_BUILD_OUTPUT_PATH=$(CURDIR)/build

.PHONY: build

default:
	@echo "Available targets:"
	@echo "   Common: clean"
	@echo "   Release: build-release install-release"

clean:
	xcodebuild clean
	rm -rf "$(AWL_BUILD_OUTPUT_PATH)"

# Release
build-release: clean
	xcodebuild -target VST3NetSend -configuration Release DEPLOYMENT_LOCATION=NO build
install-release: clean
	xcodebuild -target VST3NetSend -configuration Release install

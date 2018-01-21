
XCodeProjectFilePath = ${PWD}/VST3NetSend.xcodeproj
XCodeProjectSchema = VST3NetSend

default:
	@echo "Available actions:"
	@echo " - build:  Make build."
	@echo " - clean:  Clean project."
	@echo " - ci:     Make CI build."
	@echo " - verify: Verify sources."

build:
	@ruby -r "`pwd`/Vendor/WL/Scripts/WL.rb" -e "XcodeBuilder.new(\"$(XCodeProjectFilePath)\").build(\"$(XCodeProjectSchema)\")"
	
clean:
	@ruby -r "`pwd`/Vendor/WL/Scripts/WL.rb" -e "XcodeBuilder.new(\"$(XCodeProjectFilePath)\").clean(\"$(XCodeProjectSchema)\")"

ci: clean build

verify:
	@echo "OK"

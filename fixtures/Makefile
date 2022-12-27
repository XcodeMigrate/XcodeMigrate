prepare:
	curl -Ls https://install.tuist.io | bash

generate:
	cd basic && tuist generate
	make workaround-plist-app

workaround-plist-app:
	# use plistbuddy to set the CFBundlePackageType to FMWK in basic/Derived/InfoPlists/BasicFixtureProject-Info.plist
	# Otherwise the app will not be able to be built:
	# ERROR: While processing target "@//:BasicFixtureProject"; found key "CFBundlePackageType" in two plists with different values: "APPL" != "FMWK"
	/usr/libexec/PlistBuddy -c "Set :CFBundlePackageType FMWK" basic/Derived/InfoPlists/BasicFixtureProject-Info.plist

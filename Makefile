# Conditionally include .env file if not running in CI/CD environment
ifndef GITHUB_ACTIONS
  -include .env
endif

# default env values
APTOS_NETWORK ?= custom
ARTIFACTS_LEVEL ?= all
DEFAULT_FUND_AMOUNT ?= 100000000
DEFAULT_FUNDER_PRIVATE_KEY ?= 0x0
DEV_ACCOUNT ?= 380cc51342dc20d61af1a05abbd3a4ba718e555ef8c01f1337698180d5ecff31
LARGE_PACKAGE_ADDRESS ?= 0xa461a44d7a5007a47aa4671f8d897eceac5f98fe67949ca54bc5c556afe04dd7

# ============================= CLEAN ============================= #
clean:
	rm -rf build

# ===================== PACKAGE PROFILE ===================== #

compile:
	movement move compile \
	--included-artifacts $(ARTIFACTS_LEVEL) \
	--save-metadata \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)"

test:
	movement move test \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)"
	--coverage

publish:
	movement move create-object-and-publish-package \
	--included-artifacts $(ARTIFACTS_LEVEL) \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)" \
	--address-name razor_large_package_deployer

upgrade:
	movement move upgrade-object-package \
	--included-artifacts $(ARTIFACTS_LEVEL) \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)" \
	--object-address $(LARGE_PACKAGE_ADDRESS)

docs:
	movement move document \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)"

# ===================== PACKAGE SMART ROUTER ===================== #
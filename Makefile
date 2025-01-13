# Conditionally include .env file if not running in CI/CD environment
ifndef GITHUB_ACTIONS
  -include .env
endif

# default env values
APTOS_NETWORK ?= custom
ARTIFACTS_LEVEL ?= all
DEFAULT_FUND_AMOUNT ?= 100000000
DEFAULT_FUNDER_PRIVATE_KEY ?= 0x0
DEV_ACCOUNT ?= 0x703c20063317af987ab7fc191103d7cd27369ee1322a90d23b174ee393ca9839
STABLE_SWAP_ADDRESS ?= 0x8ea2ce721a4979fe30217fa974ac8ac9e37bb7f9a3dd79f6198a806cd8e620f0

# ============================= CLEAN ============================= #
clean:
	rm -rf build

# ===================== PACKAGE PROFILE ===================== #

compile:
	aptos move compile \
	--skip-fetch-latest-git-deps \
	--included-artifacts $(ARTIFACTS_LEVEL) \
	--save-metadata \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)"

test:
	aptos move test \
	--skip-fetch-latest-git-deps \
	--ignore-compile-warnings \
	--skip-attribute-checks \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)"
	--coverage

publish:
	aptos move deploy-object \
	--skip-fetch-latest-git-deps \
	--included-artifacts $(ARTIFACTS_LEVEL) \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)" \
	--address-name razor_large_package_deployer

upgrade:
	aptos move upgrade-object \
	--skip-fetch-latest-git-deps \
	--address-name razor_large_package_deployer \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)" \
	--object-address $(STABLE_SWAP_ADDRESS)

docs:
	aptos move document \
	--skip-fetch-latest-git-deps \
	--skip-attribute-checks \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)"

# ===================== PACKAGE SMART ROUTER ===================== #
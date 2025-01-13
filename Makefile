# Conditionally include .env file if not running in CI/CD environment
ifndef GITHUB_ACTIONS
  -include .env
endif

# default env values
APTOS_NETWORK ?= custom
ARTIFACTS_LEVEL ?= all
DEFAULT_FUND_AMOUNT ?= 100000000
DEFAULT_FUNDER_PRIVATE_KEY ?= 0x0
DEV_ACCOUNT ?= 0x2b9e64c5fad8a9a881a6657b53af04ed1ad6159734a06842e29ef98b1a5f2181
LARGE_PACKAGE_ADDRESS ?= 0xa461a44d7a5007a47aa4671f8d897eceac5f98fe67949ca54bc5c556afe04dd7

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
	--object-address $(LARGE_PACKAGE_ADDRESS)

docs:
	aptos move document \
	--skip-fetch-latest-git-deps \
	--skip-attribute-checks \
	--named-addresses "razor_large_package_deployer=$(DEV_ACCOUNT)"

# ===================== PACKAGE SMART ROUTER ===================== #
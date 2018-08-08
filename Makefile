MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
ROOT_DIR := $(patsubst %/,%,$(dir $(MAKEFILE_PATH)))

# Folders
BIN_DIR = $(ROOT_DIR)/bin
DEVOPS_DIR = $(ROOT_DIR)/devops
DEVOPS_BIN_DIR = $(DEVOPS_DIR)/bin
VAR_DIR = $(ROOT_DIR)/var
VENDOR_DIR = $(ROOT_DIR)/vendor
PUB_DIR = $(ROOT_DIR)/pub
STATIC_DIR = $(PUB_DIR)/static
MEDIA_DIR = $(PUB_DIR)/media
APP_DIR = $(ROOT_DIR)/app
ETC_DIR = $(APP_DIR)/etc
NODE_MODULES_DIR = $(ROOT_DIR)/node_modules
NODE_BIN_DIR = $(NODE_MODULES_DIR)/.bin

# Executable
PHP = /usr/bin/env php
COMPOSER = $(ROOT_DIR)/composer.phar
MAGENTO_BIN = $(BIN_DIR)/magento
PHP_MAGENTO = $(PHP) $(MAGENTO_BIN)
YARN = /usr/bin/env yarn
GULP = $(NODE_BIN_DIR)/gulp
SET_FACL = /usr/bin/env setfacl
RM = /usr/bin/env rm

HTTPDUSER = `ps axo user,comm | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data|[n]ginx' | grep -v root | head -1 | cut -d\  -f1`
ME = `whoami`

default: install

install: install-composer install-deps yarn-install show-install-command

install-composer:
	@if [ ! -f $(COMPOSER) ]; then echo "..downloading Composer"; curl -sS https://getcomposer.org/installer | $(PHP); fi

install-deps:
	@echo "..installing dependencies with Composer"
	@$(PHP) $(COMPOSER) install --no-progress

set-permission: check
	@echo "..setting permission for $(VAR_DIR), $(VENDOR_DIR), $(STATIC_DIR), $(MEDIA_DIR), $(ETC_DIR)"
	@sudo $(SET_FACL) -R -m u:$(HTTPDUSER):rwX -m u:$(ME):rwX $(VAR_DIR) $(VENDOR_DIR) $(STATIC_DIR) $(MEDIA_DIR) $(ETC_DIR)
	@sudo $(SET_FACL) -dR -m u:$(HTTPDUSER):rwX -m u:$(ME):rwX $(VAR_DIR) $(VENDOR_DIR) $(STATIC_DIR) $(MEDIA_DIR) $(ETC_DIR)

check: SET_FACL-exists

SET_FACL-exists: ; @which setfacl > /dev/null

yarn-install:
	@echo "..installing dependencies with Yarn"
	@$(yarn)

show-install-command:
	@echo "..run the following command to install Magento in local machine (create the correct database first)"
	@echo "$(PHP_MAGENTO) setup:install \
	--backend-frontname='admin' \
	--db-name='courts_sales' \
	--db-password='Admin!23' \
	--base-url='http://www.courts.local/' \
	--language='en_US' \
	--timezone='Asia/Singapore' \
	--currency='SGD' \
	--use-rewrites=1 \
	--use-secure=1 \
	--base-url-secure='https://www.courts.local/' \
	--use-secure-admin=1 \
	--admin-use-security-key=0 \
	--admin-user='admin' \
	--admin-password='Admin!23' \
	--admin-email='tung@courts.com.sg' \
	--admin-firstname='Tung' \
	--admin-lastname='Ha'"

deploy: maintenance-on install
	@$(RM) -rf $(VAR_DIR)/generation/*  $(VAR_DIR)/di/* $(VAR_DIR)/session/* $(VAR_DIR)/cache/* $(VAR_DIR)/page_cache/*
	@$(RM) -rf $(PUB_DIR)/static/* $(VAR_DIR)/view_preprocessed/*
	@$(PHP_MAGENTO) cache:flush
	@$(PHP_MAGENTO) setup:static-content:deploy en_US | stdbuf -o0 tr -d .
	@$(PHP_MAGENTO) setup:upgrade
	@$(PHP_MAGENTO) setup:di:compile
	@$(PHP_MAGENTO) cache:flush
	@$(PHP_MAGENTO) maintenance:disable

maintenance-on:
	@$(PHP_MAGENTO) maintenance:enable

maintenance-off:
	@$(PHP_MAGENTO) maintenance:disable

.PHONY: default install install-composer install-deps set-permission check SET_FACL-exists yarn-install show-install-command deploy maintenance-on maintenance-off

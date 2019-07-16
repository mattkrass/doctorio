FACTORIO_URL?=https://www.factorio.com/get-download/latest/headless/linux64
DEFAULT_PORT?=34197
OS := $(shell uname)
ifeq ($(OS),Darwin)
	DEFAULT_SAVE?=$(HOME)/Library/Application\ Support/factorio/saves
	DEFAULT_CFG?=$(HOME)/Library/Application\ Support/factorio/cfg
else
	DEFAULT_SAVE?=$(HOME)/.factorio/saves
	DEFAULT_CFG?=$(HOME)/.factorio/cfg
endif

all: build scripts
build: download
	docker build . -t doctorio:$$(cat factorio.version)
download: factorio.xz
factorio.xz:
	@FILENAME=$$(curl -J -L -O $(FACTORIO_URL) | grep -o '[a-z_0-9.]\+tar.xz'); \
	echo Downloaded $$FILENAME; \
	VERSION=$$(echo $$FILENAME | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+'); \
	echo Version is $$VERSION; \
	echo $$VERSION > factorio.version; \
	mv $$FILENAME factorio.xz
scripts: factorio.xz start_server.sh stop_server.sh
start_server.sh:
	@echo Creating start script.
	@cp start_server.template start_server.sh
	@sed -i.dummy "s|__VERSION__|$$(cat factorio.version)|" start_server.sh
	@sed -i.dummy "s|__SAVE_PATH__|$(DEFAULT_SAVE)|" start_server.sh
	@sed -i.dummy "s|__CFG_PATH__|$(DEFAULT_CFG)|" start_server.sh
	@sed -i.dummy "s|__PORT__|$(DEFAULT_PORT)|" start_server.sh
	@rm start_server.sh.dummy
	@chmod +x start_server.sh
stop_server.sh:
	@echo Creating stop script.
	@sed "s/__VERSION__/$$(cat factorio.version)/" stop_server.template > stop_server.sh
	@chmod +x stop_server.sh
clean:
	-@rm factorio_headless_x64_*.xz 2> /dev/null ; exit 0
	-@rm factorio.xz 2> /dev/null ; exit 0
	-@rm factorio.version 2> /dev/null ; exit 0
	-@rm start_server.sh 2> /dev/null ; exit 0
	-@rm stop_server.sh 2> /dev/null ; exit 0

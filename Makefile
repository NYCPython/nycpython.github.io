SHELL = /bin/zsh

CURMAKEFILE := $(lastword $(MAKEFILE_LIST))
CURPATH := $(shell realpath $(CURMAKEFILE))
CURDIR  := $(dir $(CURPATH))
CURUSER := $(shell whoami)

COMPOSE_USER ?= $(CURUSER)
COMPOSE_PROJECT ?= palo-duro
COMPOSE_IP ?= $(shell IFS=' ' read -r a b c d <<( bc <<< "obase=256; $$(id -u $(CURUSER)) + 127*256^3 + 1" ); echo "$$((a)).$$((b)).$$((c)).$$((d))")

EXEC_USER ?= root

TARGETS := clean build build@web

PREFIX ?= $(COMPOSE_PROJECT)
DOCKER ?= docker
ifdef DEBUG
DOCKER := echo $(DOCKER)
.SILENT: $(TARGETS)
endif

build: build@web

build@web:
	$(DOCKER) build $(DOCKER_BUILD_OPTS) -t $(PREFIX)/web .

%@start:
	$(DOCKER) run -u $(EXEC_USER) $(FLAGS) --rm --name=$(CURUSER).$(PREFIX).$* $(PREFIX)/$* $(CMD)

%@stop:
	$(DOCKER) stop $(CURUSER).$(PREFIX).$*

%@shell:
	$(DOCKER) exec -it -u $(EXEC_USER) $(CURUSER).$(PREFIX).$* /bin/bash

clean:
	docker container prune -f
	docker images -f dangling=true -q | xargs -r docker image rm

compose@up compose@down:
compose@%: @phony@
	env \
		COMPOSE_IP=$(COMPOSE_IP) \
		COMPOSE_USER=$(COMPOSE_USER) \
		COMPOSE_PROJECT=$(COMPOSE_PROJECT) \
		DOCKER_UID=$$(id -u) \
		NODE_MODULES="$$(readlink -f node_modules)" \
	docker-compose -p $(CURUSER) $(@:compose@%=%)

.PHONY: $(TARGETS)
.PHONY: @phony@
@phony@:


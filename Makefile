.PHONY: all
all: lint

.PHONY: lint
lint: lint_scripts

.PHONY: lint_scripts
lint_scripts:
	{ \
		set -e ;\
		docker run \
			--rm \
			-v $$(pwd):/data \
			--entrypoint /bin/sh \
			--workdir /data \
			koalaman/shellcheck-alpine:latest \
			-c "shellcheck *.sh" ;\
	}

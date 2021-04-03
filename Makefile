.DEFAULT_GOAL := help

.PHONY: clean
clean: ## remove files created during build
	$(call print-target)
	rm -rf dist
	rm -f coverage.*

.PHONY: build
build: ## go build
	$(call print-target)
	go build -o /dev/null ./...

.PHONY: lint
lint: ## golangci-lint
	$(call print-target)
	golint -set_exit_status ./...
	go vet ./...
	golangci-lint run

.PHONY: test
test: ## go test with race detector and code covarage
	$(call print-target)
	go test -race -covermode=atomic -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

.PHONY: mod-tidy
mod-tidy: ## go mod tidy
	$(call print-target)
	go mod tidy
	cd tools && go mod tidy

 .PHONY: diff
diff: ## git diff
	$(call print-target)
	@git diff --exit-code
	RES=$$(git status --porcelain) ; if [ -n "$$RES" ]; then echo $$RES && exit 1 ; fi 

.PHONY: dev-build
elm-dev-build: ## build elm [dev]
	$(call print-target)
	elm make elm/Main.elm --output=public/application.js --debug

.PHONY: prod-build
elm-prod-build: ## build elm [prod]
	$(call print-target)
	elm make elm/Main.elm --output=public/application.js

.PHONY: release
release: ## goreleaser --rm-dist
release: elm-prod-build
	$(call print-target)
	goreleaser --rm-dist

.PHONY: build-snapshot
build-snapshot: ## goreleaser --snapshot --skip-publish --rm-dist
build-snapshot: elm-dev-build
	$(call print-target)
	goreleaser build --snapshot --rm-dist

.PHONY: go-clean
go-clean: ## go clean build, test and modules caches
	$(call print-target)
	go clean -cache -testcache -modcache

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

define print-target
	@printf "Executing target: \033[36m$@\033[0m\n"
endef
SOURCES    := $(shell find . -type f -name '*.go')
LINT       := $(shell go env GOPATH)/bin/golint
GODOCDOWN  := $(shell go env GOPATH)/bin/godocdown
STATICCHECK:= $(shell go env GOPATH)/bin/staticcheck
PKGS       := $(shell go list ./...)
PKG        := $(shell go list)
COVER_OUT  := coverage.out
COVER_HTML := coverage.html
COVER_JSON := coverage.json
TMP_COVER  := tmp_cover.out

.PHONY: default
default: test

.PHONY: clean
clean:
	echo "Removing temp files..."
	rm -fv *.cover *.out *.html
	go clean -modcache

.PHONY: test
test:
	go mod tidy
	for pkg in $(PKGS); do go test -v -race $$pkg || exit 1; done

.PHONY: cover
cover:
	echo "mode: set" > $(COVER_OUT)
	for pkg in $(PKGS); do \
		go test -v -coverprofile="$(TMP_COVER)" $$pkg || exit 1; \
		grep -v "^mode: set" $(TMP_COVER) >> $(COVER_OUT); \
	done
	go tool cover -html "$(COVER_OUT)" -o "$(COVER_HTML)"
	(which gnome-open && gnome-open $(COVER_HTML)) || (which -s open && open $(COVER_HTML)) || (exit 0)

$(LINT):
	go install golang.org/x/lint/golint@latest

$(STATICCHECK):
	go install honnef.co/go/tools/cmd/staticcheck@latest



.PHONY: lint
lint: $(LINT)
	for src in $(SOURCES); do $(LINT) $$src || exit 1; done

.PHONY: vet
vet:
	for src in $(SOURCES); do go vet $$src; done

.PHONY: staticcheck
staticcheck: $(STATICCHECK)
	$(STATICCHECK) ./...

$(GODOCDOWN):
	go install github.com/robertkrimen/godocdown/godocdown@latest

.PHONY: doc
doc: $(GODOCDOWN)
	$(GODOCDOWN) $(PKG) > GODOC.md

.PHONY: fmt
fmt:
	gofmt -s -w .

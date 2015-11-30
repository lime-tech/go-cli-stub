LDFLAGS = \
	-X $(NAME)/cli.version=$(VERSION) \
	-B 0x$(shell head -c20 /dev/urandom|od -An -tx1|tr -d ' \n')

all: $(NAME)
$(NAME): *.go src/cli/*.go src/config/*.go src/helpers/*.go
	go build -a -ldflags "$(LDFLAGS)" -v

release:
	mkdir -p $(NAME)-"$(VERSION)"/src/$(NAME)

	rsync -avzr --delete \
		--filter='- $(NAME)-*' \
		--filter='- /$(NAME)' \
		--filter='+ /.git/' \
		--filter='- .*' \
		--filter='- *~' \
		--filter='- *.org' \
		. $(NAME)-"$(VERSION)"/src/$(NAME)

	tar czf $(NAME)-"$(VERSION)".tgz $(NAME)-"$(VERSION)"

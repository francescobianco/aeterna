
push:
	@git config credential.helper 'cache --timeout=3600'
	@git add .
	@git commit -am "fix" || true
	@git push

build:
	@chmod +x entrypoint.sh

start: build
	@docker compose up -d --build

test: start
	@bash tests/simple-test.sh

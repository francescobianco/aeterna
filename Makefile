
push:
	@git config credential.helper 'cache --timeout=3600'
	@git add .
	@git commit -am "fix" || true
	@git push

build:
	@chmod +x entrypoint.sh

stop:
	@docker compose stop

start: build
	@docker compose up -d --build --force-recreate && sleep 2

test: stop start
	@#docker compose up --force-recreate node1
	@bash tests/simple-test.sh

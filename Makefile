
push:
	@git config credential.helper 'cache --timeout=3600'
	@git add .
	@git commit -am "fix" || true
	@git push

clean:
	@sudo rm -fr tests/nodes/node1/data tests/nodes/node2/data tests/nodes/node3/data tests/nodes/pub_key_1

build:
	@chmod +x bin/entrypoint.sh

stop:
	@docker compose stop

start: build
	@docker compose up -d --build --force-recreate && sleep 2

test: clean start
	@#docker compose up --force-recreate node1
	@bash tests/simple-test.sh

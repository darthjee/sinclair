.PHONY: dev

PROJECT?=sinclair

dev:
	docker-compose run $(PROJECT) /bin/bash

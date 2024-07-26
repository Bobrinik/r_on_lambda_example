include .env
export

COMMIT_HASH := $(shell git rev-parse --short HEAD)

.PHONY: docker
docker: ## Build docker image
	COMMIT_HASH=$(COMMIT_HASH) docker compose build
	docker tag $(IMAGE):$(COMMIT_HASH) $(IMAGE):latest


.PHONY: push
push: # pushing docker images
	docker push $(IMAGE):$(COMMIT_HASH)
	docker push $(IMAGE):latest

.PHONY: start
start:
	docker run -d -p 9000:8080 --entrypoint /usr/local/bin/aws-lambda-rie $(IMAGE):$(COMMIT_HASH)

.PHOONY: invoke
invoke:
	curl -X POST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"test":""}'

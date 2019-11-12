DOCKER_IMAGE := issue-creator
VERSION      := $(shell git rev-parse HEAD)
PORT         := 3000

# Removes all iggy related docker images from your machine
# You need to ensure none are currently in use
.PHONY: docker_clean
docker_clean:
	@docker rmi -f $(shell docker images --filter "reference=$(DOCKER_IMAGE)" -q | uniq)

.PHONY: docker_build
docker_build:
	@echo "Rebuilding...."
	-docker rmi $(DOCKER_IMAGE)
	docker build -t $(DOCKER_IMAGE) . && docker run -it -p 3000:3000 $(DOCKER_IMAGE)
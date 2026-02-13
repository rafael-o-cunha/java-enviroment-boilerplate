# ===== CONFIG =====
IMAGE_NAME=ambiente-java-image
CONTAINER_NAME=ambiente-java
PROJECT_DIR=$(PWD)
M2_DIR=$(HOME)/.m2

USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)

# ===== BUILD =====
build:
	docker build \
		--build-arg USER_ID=$(USER_ID) \
		--build-arg GROUP_ID=$(GROUP_ID) \
		-t $(IMAGE_NAME) .

# ===== RUN =====
run:
	docker run -it \
		--name $(CONTAINER_NAME) \
		--user $(USER_ID):$(GROUP_ID) \
		-v $(PROJECT_DIR):/project \
		-v $(M2_DIR):/home/devuser/.m2 \
		-w /project \
		$(IMAGE_NAME)

run-rm:
	docker run -it --rm \
		--user $(USER_ID):$(GROUP_ID) \
		-v $(PROJECT_DIR):/project \
		-v $(M2_DIR):/home/devuser/.m2 \
		-w /project \
		$(IMAGE_NAME)

run-bg:
	docker run -d \
		--name $(CONTAINER_NAME) \
		--user $(USER_ID):$(GROUP_ID) \
		-v $(PROJECT_DIR):/project \
		-v $(M2_DIR):/home/devuser/.m2 \
		-w /project \
		$(IMAGE_NAME) tail -f /dev/null

run-cmd:
	docker run --rm \
		--user $(USER_ID):$(GROUP_ID) \
		-v $(PROJECT_DIR):/project \
		-v $(M2_DIR):/home/devuser/.m2 \
		-w /project \
		$(IMAGE_NAME) $(CMD)

exec:
	docker exec -it $(CONTAINER_NAME) bash

stop:
	docker stop $(CONTAINER_NAME) || true

clean-container:
	docker rm -f $(CONTAINER_NAME) || true

clean-image:
	docker rmi -f $(IMAGE_NAME) || true

clean-all: clean-container clean-image
	docker system prune -f

status:
	docker ps -a

IMG=actionloop-python-v2.7:latest
INVOKE=invoke
PREFIX=docker.io/openwhisk

build:
	docker build -t $(IMG) -f Dockerfile .

clean:
	docker rmi -f $(IMG)

debug: build
	docker run -p 8080:8080 \
	-ti --entrypoint=/bin/bash -v $(PWD):/mnt \
	-e OW_COMPILER=/mnt/bin/compile \
	$(IMG)

.PHONY: build clean  debug


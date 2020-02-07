IMG=whisk/actionloop-python-v3.6-ai:latest

build:
	docker build -t $(IMG) -f Dockerfile .

clean:
	docker rmi -f $(IMG)

debug:
	docker run -p 8080:8080 \
	-ti --entrypoint=/bin/bash -v $(PWD):/mnt \
	-e OW_COMPILER=/mnt/bin/compile \
	$(IMG)

.PHONY: build clean  debug


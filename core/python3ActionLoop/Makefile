IMG=whisk/actionloop-python-v3.7:latest

build:
	docker build -t $(IMG) .

clean:
	docker rmi -f $(IMG)

debug: build
	docker run -p 8080:8080 \
	-ti --entrypoint=/bin/bash -v $(PWD):/mnt \
	-e OW_COMPILER=/mnt/bin/compile \
	$(IMG)

.PHONY: build clean  debug

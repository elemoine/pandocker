NAME=dalibo/pandocker
TAG=latest
PANDOC_VERSION=2.1

all: build

build: Dockerfile
	docker build \
	    --build-arg APT_CACHER=$${APT_CACHER-} \
	    --build-arg PANDOC_VERSION=$(PANDOC_VERSION) \
	    --tag $(NAME):$(TAG) .

test:
	.circleci/test.sh

authors:
	git shortlog -s -n

clean:
	docker rmi $(NAME):$(TAG)

warm-cache:
	./fetch-pandoc.sh $(PANDOC_VERSION) cache/pandoc.deb
	pip download --dest cache/ --requirement requirements.txt

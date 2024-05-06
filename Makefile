APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=dmazek
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
#TARGETARCH=arm64 #amd64

format:
	gofmt -s -w ./

lint: 
	golint

all:
	foo = $(arch)
	ifdef foo
	TARGETARCH = arm64
	else
	TARGETARCH = "$(arch)"
	endif

test:
	echo =${TARGETARCH};
get:
	go get

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/dmazepa/kbot/cmd.appVersion=${VERSION}

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
	
clean:
	rm -rf kbot
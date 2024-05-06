APP=$(shell basename $(shell git remote get-url origin))
REGISTRY=dmazek
VERSION=$(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux #linux darwin windows
TARGETARCH=arm64 #amd64

format:
	gofmt -s -w ./

lint: 
	golint

test:
	go test -v

get:
	go get

build: format
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X="github.com/dmazepa/kbot/cmd.appVersion=${VERSION}-${TARGETARCH}

buildamd64:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o kbot -ldflags "-X="github.com/dmazepa/kbot/cmd.appVersion=${VERSION}-amd64

buildarm64:
	CGO_ENABLED=0 GOOS=darwin GOARCH=arm64 go build -v -o kbot -ldflags "-X="github.com/dmazepa/kbot/cmd.appVersion=${VERSION}-arm64

imageamd64:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-amd64

imagearm64:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-arm64

image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

pushamd64:
	docker push ${REGISTRY}/${APP}:${VERSION}-amd64

pusharm64:
	docker push ${REGISTRY}/${APP}:${VERSION}-arm64

clean:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}

cleanamd64:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-amd64
	
cleanarm64:
	docker rmi ${REGISTRY}/${APP}:${VERSION}-arm64
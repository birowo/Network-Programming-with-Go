SHELL := /bin/bash

.PHONY: all install prepare build watch publish pdf epub mobi clean

all: install build

install: # install gitbook-cli
	npm install 

prepare:
	npm run gitbook:prepare

build:
	npm run gitbook:build

watch:
	npm run gitbook:watch

pdf:
	npm run gitbook:pdf

epub:
	npm run gitbook:epub

mobi:
	npm run gitbook:mobi

publish: build pdf epub mobi
	cd _book && \
	git config --global user.name "publisher" && \
	git config --global user.email "publisher@git.hub" && \
	git init && \
	git commit --allow-empty -m 'update gh-pages' && \
	git checkout -b gh-pages && \
	git add . && \
	git commit -am 'update gh-pages' && \
	git push https://github.com/tumregels/Network-Programming-with-Go gh-pages --force

clean:
	rm -rf _book
	rm -rf node_modules
	rm -rf tmp*

# build docker image
dockbuild:
	docker build -t gitbook .

# use x11 for publishing pdf, epub and mobi ebooks, tested on ubuntu 16.04. \
Running `make dockrun` will create a container, build the gitbook and attach a terminal, \
to run other commands such as `make watch`, `make publish`.
dockrun:
	docker run -ti --rm -e DISPLAY=${DISPLAY} \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v ${HOME}/.Xauthority:/root/.Xauthority \
	-v ${PWD}:/app/gitbook \
	--net=host gitbook /bin/bash -c "make build && bash"

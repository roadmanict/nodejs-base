PATH  := ${PWD}/node_modules/.bin:$(PATH)
SHELL := /bin/bash

.PHONY: all

all: clean audit tslint ts test

clean:
	rm -rf dist .nyc_output coverage

audit:
	npm audit

tslint:
	tslint --config node_modules/@roadmanict/nodejs-code-style/tslint.json 'spec/**/*.ts' 'src/**/*.ts'

ts:
	tsc --build node_modules/@roadmanict/nodejs-code-style/tsconfig.json

ts-incremental:
	tsc --incremental

test:
	nyc --nycrc-path node_modules/@roadmanict/nodejs-code-style/.nycrc.json jasmine

build: clean audit tslint ts test

watch: clean
	nodemon --config node_modules/@roadmanict/nodejs-code-style/nodemon.json --watch src --watch spec --exec "make tslint && make ts-incremental && make test"

prepare: clean
	tsc --declaration || exit 0

path:
	echo ${PATH}
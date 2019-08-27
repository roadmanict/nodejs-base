PATH  := ${PWD}/node_modules/.bin:$(PATH)
SHELL := /bin/bash

TSLINT_CONFIG_PATH  := node_modules/@roadmanict/nodejs-code-style/tslint.json
JASMINE_CONFIG_PATH := node_modules/@roadmanict/nodejs-code-style/jasmine.json
NYC_CONFIG_PATH     := node_modules/@roadmanict/nodejs-code-style/.nycrc.json
NODEMON_CONFIG_PATH := node_modules/@roadmanict/nodejs-code-style/nodemon.json

.PHONY: all

all: audit tslint ts test

clean:
	rm -rf dist .nyc_output coverage

audit:
	npm audit

tslint:
	tslint --config ${TSLINT_CONFIG_PATH} 'spec/**/*.ts' 'src/**/*.ts'

ts: clean
	tsc

ts-incremental:
	tsc --incremental

test:
	jasmine --config=${JASMINE_CONFIG_PATH}

coverage:
	nyc --nycrc-path ${NYC_CONFIG_PATH} make test

build: audit tslint ts coverage

watch: clean
	nodemon --config ${NODEMON_CONFIG_PATH} --watch src --watch spec --exec "make tslint && make ts-incremental && make coverage"

prepare: clean
	tsc --declaration || exit 0

path:
	echo ${PATH}
PATH  := ${PWD}/node_modules/.bin:$(PATH)
SHELL := /bin/bash

TSLINT_CONFIG_PATH  := node_modules/@roadmanict/nodejs-base/tslint.json
JASMINE_CONFIG_PATH := node_modules/@roadmanict/nodejs-base/jasmine.json
NYC_CONFIG_PATH     := node_modules/@roadmanict/nodejs-base/.nycrc.json
NODEMON_CONFIG_PATH := node_modules/@roadmanict/nodejs-base/nodemon.json

.PHONY: all clean audit tslint ts ts-incremental test coverage build watch prepare

all: build

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

jasmine:
	node -r source-map-support/register ./node_modules/.bin/jasmine --config=${JASMINE_CONFIG_PATH}

test:
	nyc --nycrc-path ${NYC_CONFIG_PATH} make jasmine

coverage:
	nyc --nycrc-path ${NYC_CONFIG_PATH} report --reporter=text-lcov | coveralls

build: audit tslint ts test

watch: clean
	nodemon --config ${NODEMON_CONFIG_PATH} --watch src --watch spec --exec "make tslint && make ts-incremental && make test"

prepare: clean
	tsc --declaration || exit 0
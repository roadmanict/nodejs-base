PATH  := ${PWD}/node_modules/.bin:$(PATH)
SHELL := /bin/bash

.PHONY: clean tslint

clean:
	rm -rf dist .nyc_output coverage

tslint:
	tslint --config node_modules/@roadmanict/nodejs-code-style/tslint.json 'spec/**/*.ts' 'src/**/*.ts'

path:
	echo ${PATH}
PATH  := node_modules/.bin:$(PATH)

.PHONY: clean tslint

clean:
	rm -rf dist .nyc_output coverage

tslint:
	tslint --config node_modules/@roadmanict/nodejs-code-style/tslint.json

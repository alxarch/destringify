describe "destringify", ->
	destringify = require "."
	assert = require "assert"
	input =
		foo: "bar"
		bar: "true"
		baz:
			bar: "foo"
			foo: "4"
			baz: "null"
	it "Converts object values to builtins", ->
		output =
			foo: "bar"
			bar: yes
			baz:
				bar: "foo"
				foo: 4
				baz: null
		assert.deepEqual destringify(input), output, "Converts all builtins"

	it "filters keys to process using array match", ->
		output =
			foo: "bar"
			bar: yes
			baz:
				bar: "foo"
				foo: "4"
				baz: null
		assert.deepEqual destringify(input, ["bar", "baz"]), output, "Converts all builtins"
	
	it "filters keys to process using string match", ->
		output =
			foo: "bar"
			bar: "true"
			baz:
				bar: "foo"
				foo: "4"
				baz: null
		assert.deepEqual destringify(input, "baz"), output, "Converts all builtins"

	it "filters keys to process using regex match", ->
		output =
			foo: "bar"
			bar: yes
			baz:
				bar: "foo"
				foo: "4"
				baz: null
		assert.deepEqual destringify(input, /^ba/), output, "Converts targeted values"

		
	it "filters keys to process using function match", ->
		output =
			foo: "bar"
			bar: "true"
			baz:
				bar: "foo"
				foo: "4"
				baz: null
		filter = (key, value, obj) ->
			assert key in ["foo", "bar", "baz"]
			switch obj
				when input
					assert value is input[key]
				when input.baz
					assert obj is input.baz
				else
					assert no
			key is "baz"

		assert.deepEqual destringify(input, filter), output, "Converts targeted values"

	it "Converts loose values correctly", ->
		assert.ok (destringify "true") is true, "true"
		assert.ok (destringify "false") is false, "false"
		assert.ok (destringify "null") is null, "null"
		assert.ok (destringify "undefined") is undefined, "undefined"
		assert.ok (destringify "4") is 4, "number"
		assert.ok (destringify "4.2") is 4.2, "number (float)"


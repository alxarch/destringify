describe "jsonify", ->
	jsonify = require "."
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
		assert.deepEqual jsonify(input), output, "Converts all builtins"

	it "filters keys to process using array match", ->
		output =
			foo: "bar"
			bar: yes
			baz:
				bar: "foo"
				foo: "4"
				baz: null
		assert.deepEqual jsonify(input, ["bar", "baz"]), output, "Converts all builtins"
	
	it "filters keys to process using string match", ->
		output =
			foo: "bar"
			bar: "true"
			baz:
				bar: "foo"
				foo: "4"
				baz: null
		assert.deepEqual jsonify(input, "baz"), output, "Converts all builtins"

	it "filters keys to process using regex match", ->
		output =
			foo: "bar"
			bar: yes
			baz:
				bar: "foo"
				foo: "4"
				baz: null
		assert.deepEqual jsonify(input, /^ba/), output, "Converts targeted values"

		
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

		assert.deepEqual jsonify(input, filter), output, "Converts targeted values"

	it "Converts loose values correctly", ->
		assert.ok (jsonify "true") is true, "true"
		assert.ok (jsonify "false") is false, "false"
		assert.ok (jsonify "null") is null, "null"
		assert.ok (jsonify "undefined") is undefined, "undefined"
		assert.ok (jsonify "4") is 4, "number"
		assert.ok (jsonify "4.2") is 4.2, "number (float)"


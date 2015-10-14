var _ = require("lodash");
var VALUES = {
	"undefined": undefined,
	"false": false,
	"true": true,
	"null": null,
	"0": 0,
	"1": 1
};

function jsonify (value, filter) {
	if (value in VALUES) {
		return VALUES[value];
	}
	if (filter != null) {
		switch (typeof filter) {
			case "function":
				break;
			case "string":
			case "number":
				filter = _.zipObject([filter]);
				break;
			case "object":
				if (_.isArray(filter)) {
					filter = _.zipObject(filter);
				}
				else if (_.isRegExp(filter)) {
					filter = filter.test.bind(filter);
				}
				break;
			default:
				filter = null;
				break;
		}
		if (typeof filter === "object") {
			filter = filter.hasOwnProperty.bind(filter);
		}
	}

	if (_.isArray(value)) {
		return _.map(value, function (v) { return jsonify(v, filter) });
	}
	else if (_.isObject(value)) {
		return _.transform(value, function (result, val, key) {
			if (filter == null || filter(key, val, value)) {
				result[key] = jsonify(val, filter);
			}
			else {
				result[key] = val;
			}
		});
	}
	else {
		try {
			var json = JSON.parse(value);
		}
		catch (e) {
			if (e instanceof SyntaxError) {
				return value;
			}
			throw e;
		}
		return  _.isObject(json) ? value : json;
	}

}
module.exports = jsonify;

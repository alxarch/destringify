# destringify

Convert string values to builtins

### Usage

```js

var destringify = require("destringify");
var foo = {
	foo: "bar",
	bar: "true",
	baz: {
		foo: "false",
		bar: "null",
		baz: ["1", "2", "3"]
	}

}
destringify(foo);

// {
// 	foo: "bar",
// 	bar: true,
// 	baz: {
// 		foo: false,
// 		bar: null,
// 		baz: [1, 2, 3]
// 	}
// 
// }
```

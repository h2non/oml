# htgen
[![Build Status](https://travis-ci.org/h2non/htgen.png)](https://travis-ci.org/h2non/htgen)
[![Dependency Status](https://gemnasium.com/h2non/htgen.png)](https://gemnasium.com/h2non/htgen)

## About

**htgen** is a tiny but featured hypertext markup code generator for JavaScript environments. 
It was designed to be extremly easy to use and easy to embed in templating engines

## Features

- Tiny: 400 SLOC, 1KB gzipped
- Simple and elegant API with method chaining and DSL
- Minified or pretty well indented code generation
- Runs over node and the browser
- No third party dependencies
- No DOM required
- Well tested

## Installation

#### Node.js

```
$ npm install htgen
```

#### Browser

Via Bower package manager
```
$ bower install htgen
```
Or loading the script remotely (just for testing or development)
```html
<script src="//rawgithub.com/h2non/htgen/master/htgen.js"></script>
```

## Environments

- Node.js
- Chrome
- Firefox
- Safari
- Opera >= 11.6
- IE >= 9

## API

### Example

```js
var ht = require('htgen')

// nested functions calls
ht('.container#main', { attr: 'value' },
  ht('ul', { styles: { 'z-index': 10 } },
    ht('li', 'one'),
    ht('li', 'another')))
  .render()

// method chaining
ht('p')
  .child('span', 'text')
  .child('span', 'hi')
  .attr('class', 'normal')
  .render()

// using methods shortcuts
ht('ul')
  .c('li',
    // you can interpolate it as well in concat string expressions
    // it overrides the prototype inherited toString() method
    ht('p.link', 'click ' + ht('a', { href: 'http://i.am' }, 'here')))
  .c('li', 
    ht('p', 'some text'))
  .a('class', 'list')
  // make it pretty!
  .r({ pretty: true, indent: 4 })

// self-closed tags
ht('img!')

// doctypes definition
ht('doctype') // default to '<!DOCTYPE html>'
ht('doctype xml')

// dynamic
var fruits = { a: 'Apple', b: 'Banana', c: 'Coco' }
ht('table.pretty',
  ht('tr', ht('th'), ht('th', 'fruit')),
  Object.keys(fruits).map(function (n) {
    return ht('tr', 
      ht('th', n),
      ht('td', fruits[n])
    )
  })
).render(true)
```

### Doctypes alias

```
html => <!DOCTYPE html>
xml => <?xml version="1.0" encoding="utf-8" ?>
transitional => <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
strict => <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
frameset => <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
1.1 => <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
basic => <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">
mobile => <!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">
```

### htgen(name, [ attrs, child ])

Creates a new node and return an instance of Node

Name argument can be expressed like `name.class1.class2#id`, 
that is a short cut for setting the class and id attributes

### htgen.Node(name, [ attrs, child ])

#### attributes
Type: `object`

Store the node attributes, if are defined

#### tag
Type: `string`

Store the node tag name

#### childNodes
Type: `array`

Store the node child nodes instances

#### parent 
Type: `object`

If the current node is a child node, this points to the parent node instance

#### selfClosed 
Type: `boolean`

If the current node tag is self-closed, this attribute will be `true

#### child(name, [ attrs, child ])
Alias: `c`
Chainable: `yes`

Creates a new child node

#### cchild(name, [ attrs, child ])
Alias: `cc`
Chainable: `yes`

Creates and push new child node, but changes the chain call to the instance of the created child node

#### render([ options ])
Alias: `r`
Return: `string`

Render and return a string of the current node and all of its child nodes

See the supported [render options](#options) bellow. 
You can aditionally simply pass `true` to render prettified code with default options

#### attr(name, value)
Alias: `a`
Chainable: `yes`

Add new attribute to the current node. `name` argument can be an object with key-value maps

#### push(node)
Chainable: `yes`

Add a new child node

#### hasParent()
Return: `boolean`

Returns `true` if the current node has parent node, otherwise `false`

#### hasChild()
Return: `boolean`

Returns `true` if the current node has child nodes, otherwise `false`

#### latest()
Alias: `l`
Return: `Node`

Return the latest pushed child node

### htgen.Generator(node, [ options ])

#### options 

Generator supported options:

- **pretty**: Generate a well-indented code. Default to `false`
- **size**: Initial indent size. Default to `0`
- **indent**: Indent spaces. Default to `2`
- **tabs**: Use tabs instead of spaces to indent. Default to `false`

#### render()
Return: `string`

#### renderAttrs()
Return: `string`

#### renderChild()
Return: `string`

Render the current node child nodes, if they exist

#### indent()
Return: `string`

Return the string equivalent to the applied indentation characters

## Contributing

htgen is completely written in LiveScript.
Take a look to the language [documentation][livescript] if you are new with it.
Please, follow the LiveScript language conventions defined in the [coding style guide][livescript-style]

You must add new test cases for any feature or refactor you do,
also keep in mind to follow the same design/code patterns that already exist

### Development

Only node.js is required for development

Clone/fork this repository
```
$ git clone git@github.com:h2non/htgen.git && cd htgen
```

Install package dependencies
```
$ npm install
```

Run tests
```
$ npm test
```

Coding zen mode
```
$ grunt dev [--force]
```

Distribution release
```
$ grunt release
```

## To Do

- JSON map
- HTML entities convert

## License

Copyright (c) Tomas Aparicio

Released under the MIT license

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/h2non/htgen/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

[livescript]: http://livescript.net
[livescript-style]: https://github.com/gkz/LiveScript-style-guide

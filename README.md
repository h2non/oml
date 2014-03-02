# oml
[![Build Status](https://travis-ci.org/h2non/oml.png)](https://travis-ci.org/h2non/oml)
[![Dependency Status](https://gemnasium.com/h2non/oml.png)](https://gemnasium.com/h2non/oml)
[![NPM version](https://badge.fury.io/js/omljs.png)](http://badge.fury.io/js/omljs)

> **Work in progress!** This is still an experimental just for fun project

## About

**oml** (oli markup language) is a tiny and minimalist template engine 
built on top of the [Oli][oli] language for node and the browser

It's powered by [oli.js][oli-js] and [htgen][htgen]

## Features

- Elegant and minimalist syntax
- Tag definition shortcuts and attributes autocompletion
- Built-in support for data references
- Generates pretty well-indended code
- Support mixins and includes
- Run over node and browsers
- No third party dependencies
- Based in the awesome Oli language

## Installation

#### Node.js

```
$ npm install omljs
```
For CLI usage only, it's recommented you install it as global package
```
$ npm install -g omljs
```

#### Browser 

```
$ bower install oml --save
```

Or load the script remotely (just for testing or development)
```html
<script src="//rawgithub.com/h2non/oml/master/oml.js"></script>
```
Then you can create script tags with `text/oli` MIME type
```html
<script type="text/oli" src="path/to/template.oli"></script>
```
It will automatically fetch and parse the oli sources and make it available from `oli.scripts`.
To disable the automatic parsing, just add `data-ignore` attribute in the script tag

## Environments

- Node.js >= 0.8.0
- Chrome
- Firefox
- Safari 5
- Opera >= 11.6
- IE >= 9

### API

#### Example

```js
var oml = require('omljs')
var code = 'h1.title: Hello oml!'
try {
  oml.render(code, { pretty: true })
} catch (e) {
  console.error('Cannot render:', e.message)
}
```

#### render(code, options)

Parse, compile and render the given. 
It can **throw an exception** if a parsing or compilation error success

#### options

Rendering supported options:

- **locals**: Pass an local context to the compiler. Default to `null`
- **pretty**: Generate a well-indented code. Default to `false`
- **size**: Initial indent size. Default to `0`
- **indent**: Indent spaces. Default to `2`
- **tabs**: Use tabs instead of spaces to indent. Default to `false`

### Featured example

```ruby
url = 'https://github.com/h2non/oml#syntax-reference'

doctype
html:
  head:
    include: includes/head
    &title: This is oml!
    script:>
      if (foo) {
        bar(2 ^ 2)
      }
    end
  end
  body:
    # use a reference that points to 'title'
    h1.head: *title 
    # use the shortcuts for class and id attributes definition
    .container@main (title: 'Main container'):
      p.text:
        | A template engine built on top of the Oli language
      a (href: *url): Oml reference
      textarea:-
        Lorem ipsum ad his scripta blandit partiendo, 
        eum fastidii accumsan euripidis in, eum liber 
        hendrerit an. Qui ut wisi vocibus suscipiantur
      end
    end
  end
end
```

## Syntax Reference

This reference only points to the specific syntax use cases related to oml

Please, take into account that oml syntax is completely based on the [oli language][oli],
so you can use any feature that is natively supported by oli, like data references or block inheritance

For more information about the oli syntax, you could read the [specification][oli-docs]

### Doctype

The document can use any of the following doctypes alias:

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

Example
```ruby
doctype html # => <!DOCTYPE html>
```

### Tags

```
p: this is a text # => <p>this is a text</p>
```

```ruby
ul:
  li: Apple
  li: Banana
  li: Coco
end
```

Self-closed tags
```ruby
img! # => <img/>
```
```ruby
img(src: 'image.png') # => <img src="image.png"/>
```

#### Literal shortcuts

##### Class
```jade
a.button # => <a class="button"></a>
```
```jade
.content # => <div class="content"></div>
```

##### ID
```jade
a@link # => <a id="link"></a>
```
```jade
@content # => <div id="content"></div>
```

### Attributes

```ruby
a (href:'google.com'): Google 
# => <a href="http://google.com"></a>
a (class: 'link', href: 'oli-lang.org'): Oli 
# => <a class="link" href="http://oli-lang.org">Oli</a>
```

### Blocks

```ruby
div:- 
  p: This is a plain text
end
```

You also can interpolate html tags
```ruby
div:
  p:- This is a plain <strong>text</strong>
end
```

Using pipe expression
```ruby
div:
  | p: This is a plain <strong>text</strong>
```

#### Plain text

```ruby
script(type: text/javascript):>
  if (foo) {
     bar(1 + 5)
  }
end
```

### Mixins

```ruby
mixin title(name):
  h1: @name
  p: This is a paragraph
end
+title('name')!
```

### Includes

```ruby
include: path/to/file.oli
```

### Comments

**Line comments**
```ruby
# this is
# a comment
```

**Block comments**
```ruby
##
  This is a block comment
##
```

## Contributing

Wanna help? Cool! It will be really apreciated :)

You must add new test cases for any new feature or refactor you do,
always following the same design/code patterns that already exist

**oml** is completely written in LiveScript language.
Take a look to the language [documentation][3] if you are new with it.
You should follow the LiveScript language conventions defined in the [coding style guide][4]

### Development

Only [node.js](http://nodejs.org) and [Grunt](http://gruntjs.com) are required for development

Clone/fork this repository
```
$ git clone https://github.com/h2non/oml.git && cd oml
```

Install package dependencies
```
$ npm install
```

Run tests
```
$ npm test
```

Run benchmarks
```
grunt bench
```

Coding zen mode
```
$ grunt dev [--force]
```

Browser sources bundle
```
$ grunt build
```

Release a new version
```
$ grunt release
```

## License

Copyright (c) Tomas Aparicio

Released under the MIT license

[oli]:      https://oli-lang.org
[oli-docs]: http://docs.oli-lang.org
[oli-js]:   https://github.com/oli-lang/oli-js
[htgen]:    https://github.com/h2non/htgen

# oml
[![Build Status](https://travis-ci.org/h2non/oml.png)](https://travis-ci.org/h2non/oml)
[![Dependency Status](https://gemnasium.com/h2non/oml.png)](https://gemnasium.com/h2non/oml)
[![NPM version](https://badge.fury.io/js/omljs.png)](http://badge.fury.io/js/omljs)

> **Disclaimer**: this is still a beta just for fun project

## About

**oml** (oli markup language) is a tiny and minimalist template engine 
built on top of the [Oli][oli] language which runs in node and the browser

It's powered by [oli.js][oli-js] and [htgen][htgen]

You can try it online [here](http://jsfiddle.net/7LvYd/3)

### Overview Example

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

## Features

- Elegant and minimalist syntax
- Support for mixins and file includes
- Tag definition shortcuts and attributes autocompletion
- Built-in support for data references
- Generates pretty well-indended code
- Runs over node and browsers
- Self-contained, no third party dependencies (in browser environments)
- Based in the Oli language and you could use all of the language features :)

### Upcoming features

- Include/require support in the browser
- HTML entities decoding
- Layout blocks (Jade-like)

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

## CLI

```
  Usage: oml [options] <path/to/file.oli>

  Options:

    -h, --help           output usage information
    -V, --version        output the version number
    -o, --output <file>  write output into a file instead of stdout
    -i, --in-line        parse in-line argument as string
    -p, --pretty         generate well-indented pretty output
    -d, --indent <size>  JSON output indent size. Default to 2
    -t, --tabs           use tabs instead of spaces to indent
    -s, --stdin          read source from stdin

  Usage examples:

    $ oml file.oli > file.html
    $ oml file.oli -o file.html
    $ oml -i "div: p: Hello"
    $ oml -s < file.oli
    $ oml --indent 4 file.oli
    $ oml --tabs file.oli

```

## API

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
It will **throw an exception** if a parsing, compilation or rendering error happens

#### Engine(data, options)

Expose the template engine constructor

#### oli

Expose the [oli.js][oli-js-api] API

#### htgen

Expose the [htgen][htgen-api] API

#### options

Render supported options:

- **locals**: Local context to pass to the compiler. Default to `null`
- **basePath**: Base path to use for includes. Default to the current working directory
- **pretty**: Generate a well-indented code. Default to `false`
- **size**: Initial indent size. Default to `0`
- **indent**: Indent spaces. Default to `2`
- **tabs**: Use tabs instead of spaces to indent. Default to `false`

## Syntax Reference

This reference only points to the specific syntax use cases related to oml

Please, take into account that oml syntax is completely based on the Oli language,
so you can use any feature that is natively supported by Oli, like data references or block inheritance

For more information about the oli syntax, you could visit the [language site][oli] or read the [specification][oli-docs]

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

Folded
```ruby
div:
  p:-
    This will be parsed 
    as a raw text
  end
end
```
Unfolded
```ruby
div:
  p:=
    This will be parsed 
    as a raw text
  end
end
```

You also can use interpolated HTML tags
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

Plain text
```ruby
script (type: text/javascript):>
  if (foo) {
     bar(1 + 5)
  }
end
```

### Includes

Load and include content from a file in the document
```ruby
include: path/to/file.oli
```

### Requires

Load and include source in the current document. 
The only significant difference between `require` and `include` is that the 
file is loaded in an isolated sandbox context (it cannot share variables, mixins between documents)

```ruby
require: path/to/file.oli
```

### Mixins

Mixin declaration
```ruby
mixin title:
  h1: Hello Oml
end
+title
```

Passing arguments:
```ruby
mixin sample(title, text):
  h1: Hello $name
  p: $text
end
+sample ('oml', 'This is a paragraph')
```

Default arguments:
```ruby
mixin sample(title, text: 'default value'):
  h1: Hello $name
  p: $text
end
+sample ('oml')
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
Take a look to the language [documentation][ls-docs] if you are new with it.
You should follow the LiveScript language conventions defined in the [coding style guide][ls-style]

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

Coding zen mode
```
$ grunt zen [--force]
```

Bundle browser sources 
```
$ grunt build
```

Release a new patch version
```
$ grunt release
```

## License

Copyright (c) Tomas Aparicio

Released under the MIT license

[oli]:        https://oli-lang.org
[oli-docs]:   http://docs.oli-lang.org
[oli-js]:     https://github.com/oli-lang/oli-js
[htgen]:      https://github.com/h2non/htgen
[oli-js-api]: https://github.com/oli-lang/oli-js#programmatic-api
[htgen-api]:  https://github.com/oli-lang/oli-js#programmatic-api
[ls-docs]:    http://livescript.net/
[ls-style]:   https://github.com/gkz/LiveScript-style-guide

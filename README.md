# oml

> Markup template engine build on top of the [Oli][oli] language for node and the browser

> **SPOILER! Work in progress**

## About

OML is the acronim of Oli Markup Language. 
It uses the [JavaScript][oli-js] parser and compiler of the Oli language 

## Installation

#### Node.js

```
$ npm install omljs --save
```
For CLI usage only, it's recommented you install it as global package
```
$ npm install -g omljs
```

#### Browser (via Bower)

```
$ bower install oli --save
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
- Safari
- Opera
- IE >= 9 


[oli-js]: https://github.com/oli-lang/oli-js
[oli]: https://oli-lang.org

require! {
  fs
  oli
  './walk'
  ht: 'htgen'
}
{ is-object, is-array, is-string, is-undef, is-array-strings, cwd, has } = require './helpers'

oml = exports = module.exports = {}

defaults = 
  base-path: cwd!
  locals: null
  pretty: no
  indent: 2

oml.render = (code, options) ->
  ((String code) |> oli.parse _, options) |> render _, options

render = (obj, options = defaults) ->
  buf = []
  if obj |> is-object
    buf = (obj |> visitor) |> buf.concat
    buf = buf
      .filter -> (it |> is-object) or (it |> is-string)
      .map ->
        if it |> is-object 
          options |> it.render
        else
          it
    buf = buf.join (if options.pretty is yes then '\n' else '')
  else
    buf = obj
    if obj |> is-string
      buf = (obj |> ht).render options if obj |> is-doctype
  buf

visitor = (node) ->
  buf = []
  for own name, child of node when child isnt undefined then
    name = name |> normalize
    if name is 'include' and (child |> is-string)
      child |> read-file |> oml.render |> buf.push
    else if child |> is-array
      temp = []
      if child |> has _, '$$attributes'
        attrs = child.$$attributes
        child = child.$$body
      if child |> is-array-strings
        (ht.apply null, [ name, attrs, (child.join ' ') ]) |> buf.push
      else
        for item in child
          if item |> is-object
            item = item |> visitor
          (ht name, item) |> temp.push
        buf = buf.concat temp
    else
      child |> process name, _ |> buf.push
  #console.log('FINAL VISITOR', require('util').inspect(buf, {depth: null}))
  buf

process = (name, node) ->
  if node is null
    name = "!#{name}"
  else if node |> has _, '$$attributes'
    attrs = node.$$attributes
    node = node.$$body
  else if node |> is-object
    node = node |> visitor
  ht name, attrs, node

read-file = ->
  it = it |> file-ext
  it = "#{cwd!}/#{it}" if it.charAt(0) isnt '/'
  (it |> fs.read-file-sync).to-string!

file-ext = ->
  if not (/\.([a-z\-\_0-9]){0,10}$/i.test it)
    it += '.oli'
  else
    it

normalize = -> it.replace '@', '#'

is-doctype = -> /^doctype/i.test it

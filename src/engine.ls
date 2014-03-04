require! {
  fs
  oli
  ht: 'htgen'
}
{ is-object, is-array, is-string, is-undef, is-array-strings, extend, clone, has, cwd } = require './helpers'

exports = module.exports = class Engine

  @render = (code, options) ->
    (String code
      |> oli.parse _, options
      |> new Engine _, options).compile!

  @options =
    base-path: cwd!
    pretty: no
    indent: 2

  (data, options) ->
    @data = data
    @mixins = {}
    @buf = []
    @result = null
    options |> @set-options
    
  set-options: ->
    @options = it |> extend (Engine.options |> clone), _

  compile: (data = @data) ->
    if data |> is-object
      data |> @compile-object
    else if data |> is-array
      data |> @compile-array
    else
      data |> @compile-raw

  compile-object: ->
    @buf = (it |> @visitor |> @process-mixins)
      .filter is-valid
      .map ~> it |> @process-node
    @separator! |> @buf.join

  compile-array: (data) ->
    buf = []
    do iterate = ~>
      for item, index in data when item then
        if item |> is-array
          (item |> buf.push) if item = item |> iterate
        else
          (item |> buf.push) if item = item |> @compile
    (buf |> @process-mixins).join @separator!

  compile-raw: ->
    if it |> is-string
      if it |> is-doctype
        (it |> ht).render @options
      else
        it
    else
      it

  process-node: ->
    if it |> is-object
      if it.mixin
        if it.body |> is-array
          @separator! |> it.body.join
        else
          it.body
      else
        @options |> it.render
    else
      it

  visitor: (node) ->
    buf = []
    for own name, child of node when child isnt undefined then
      name = name |> normalize
      if name is 'include' and (child |> is-string)
        child |> @read-file |> Engine.render _, @options |> buf.push
      else if name |> is-mixin-definition
        if not (child |> has _, '$$attributes')
          child = $$attributes: null, $$body: child
        child.$$body = child.$$body |> @visit-mixin 
        child |> @register-mixin name, _
      else if child |> is-array
        buf = child |> @process-array name, _ |> buf.concat
      else
        child |> @process name, _ |> buf.push
    buf

  visit-mixin: ->
    buf = []
    if it |> is-object
      for own name, node of it then node |> @process name, _ |> buf.push
    else if it |> is-array
      # to do
      for item in it then item |> @visitor |> buf.push
    else
      it |> buf.push
    @separator! |> buf.join 

  process-mixins: ->
    return it if not (it |> is-array)
    for child, index in it 
      when name = child |> is-mixin-node 
      then
        if not (mixin = @mixins[name])
          throw new Error "Missing required mixin: #{name}"

        body = mixin.body
        call-args = child.attributes |> Object.keys if child.attributes
        if mixin.args
          for arg, aindex in mixin.args then 
            body = body.replace "$#{arg}", (call-args[aindex] or '')
        it[index] = body
    it

  process: (name, node) ->
    if node is null
      name = "!#{name}"
    else if node |> has _, '$$attributes'
      attrs = node.$$attributes
      node = node.$$body
    else if node |> is-object
      node = node |> @visitor
    ht name, attrs, node

  register-mixin: (name, node) ->
    name = name |> get-mixin-name
    throw new SyntaxError 'Missing mixin name identifier' if not name
    @mixins <<< (name): {
      args: node |> get-mixin-args
      body: node.$$body
    }

  process-array: (name, node) ->
    buf = []
    if node |> is-array-strings
      (ht.apply null, [ name, (node.join ' ') ]) |> buf.push
    else
      for item in node
        if item |> is-object
          if item.$$name and item.$$attributes and (item.$$body |> is-undef)
            item |> @process item.$$name, _ |> buf.push
          else
            (item |> @visitor) |> ht name, _ |> buf.push
        else
          item |> ht name, _ |> buf.push
    buf

  separator: ->
    if @options.pretty then '\n' else ''

  read-file: ->
    it = it |> file-ext
    it = "#{@options.base-path}/#{it}" if it.charAt(0) isnt '/'
    (it |> fs.read-file-sync).to-string!


file-ext = ->
  if not (/\.([a-z\-\_0-9]){0,10}$/i.test it)
    it += '.oli'
  else
    it

mixin-name-regex = /^mixin ([a-z0-9\_\-\.]+)[\s+]?\(?/i
mixin-call-regex = /^\+[\s+]?([a-z0-9\_\-\.]+)[\s+]?\(?/i

get-mixin-name = ->
  name[1] if name = it.match mixin-name-regex

get-mixin-call = ->
  name[1] if name = it.match mixin-call-regex

get-mixin-args = ->
  args = null
  if it |> is-object
    if it.$$attributes |> is-object
      args = it.$$attributes |> Object.keys
    else if it.$$attributes |> is-array
      args = []
      it.$$attributes.for-each -> (it |> Object.keys ) |> args.push
  args

is-valid = -> (it |> is-object) or ((it |> is-string) and it.length)  

normalize = -> it.replace '@', '#'

is-doctype = -> /^doctype/i.test it

is-mixin-node = ->
  if (it |> is-object) and (it.tag |> is-mixin-call)
    it.tag |> get-mixin-call
  else if (it |> is-mixin-call)
    it |> get-mixin-call
  else
    no 

is-mixin-definition = -> /^mixin/i.test it

is-mixin-call = -> /^\+/i.test it
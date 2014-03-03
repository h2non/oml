has-own = Object::has-own-property
to-string = Object::to-string

exports.is-browser = is-browser = typeof window isnt 'undefined'

exports.cwd = -> if is-browser then '/' else process.cwd!

exports.extend = (target = {}, origin) -> 
  for own name, value of origin then target[name] = value
  target

exports.clone = clone = ->
  target = {}
  for own name, value of it then
    if value |> is-array
      value = value.slice!
    else if value |> is-object
      value = value |> clone
    target[name] = value
  target

exports.is-undef = is-undef = -> (it is null) or (it is undefined)

exports.is-string = is-string = -> typeof it is 'string'

exports.is-object = is-object = -> (it |> to-string.call) is '[object Object]'

exports.is-array = is-array = -> (it |> to-string.call) is '[object Array]'

exports.has = (obj, prop) ->
  if not (obj |> is-undef)
    obj |> has-own.call _, prop
  else
    false

exports.is-array-strings = ->
  for item in it
    if not (item |> is-string)
      return no
  yes

exports.echo = -> console.log.apply console, & if console

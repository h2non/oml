to-string = Object::to-string

exports.extend = (target = {}, origin) -> 
  for own name, value of origin then target[name] = value
  target

exports.clone = clone = ->
  target = {}
  for own name, value of it then
    if (value |> is-array) and name isnt 'childNodes'
      value = value.slice!
    else if value |> is-object
      value = value |> clone
    target[name] = value
  target

exports.is-string = is-string = -> typeof it is 'string'

exports.is-object = is-object = -> (it |> to-string.call) is '[object Object]'

exports.is-array = is-array = -> (it |> to-string.call) is '[object Array]'

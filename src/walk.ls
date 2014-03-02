{ is-array } = require './helpers'

exports = module.exports = (obj) -> (cb) -> walk obj, undefined, cb

walk = (node, parent, cb) ->
  keys = node |> Object.keys 
  i = 0

  while i < keys.length
    key = keys[i]

    continue  if key is 'parent'
    child = node[key]
    if child |> is-array
      j = 0

      while j < child.length
        c = child[j]
        if c and typeof c.type is 'string'
          c.parent = node
          walk c, node, cb
        j += 1
    else if child and typeof child.type is 'string'
      child.parent = node
      walk child, node, cb
    i += 1
  
  cb node

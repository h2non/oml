require! {
  oli
  htgen
  Compiler: './compiler'
}

oml = exports = module.exports = {}

oml <<< {
  Compiler
  htgen
  oli
}

oml.render = (code, options) ->
  (String code |> oli.parse _, options
    |> new Compiler _, options)
    .compile!

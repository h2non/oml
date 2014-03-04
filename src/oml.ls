require! {
  oli
  htgen
  Engine: './engine'
}

exports = module.exports <<< {
  oli
  htgen
  Engine
  Engine.render
}
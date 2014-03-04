require! {
  oml: '../'
  'chai'.expect
}

describe 'API', (_) ->

  it 'should expose an object', ->
    expect oml .to.be.an 'object'

  it 'should expose the render method', ->
    expect oml.render .to.be.a 'function'

  it 'should expose the Engine constructor', ->
    expect oml.Engine .to.be.a 'function'

  it 'should expose the oli object', ->
    expect oml.oli .to.be.an 'object'

  it 'should expose the htgen object', ->
    expect oml.htgen .to.be.a 'function'

require! {
  '../lib/oml'
  'chai'.expect
}

describe 'API', (_) ->

  it 'should expose an object', ->
    expect oml .to.be.an 'object'

  it 'should expose the render method', ->
    expect oml.render .to.be.a 'function'
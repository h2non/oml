require! {
  oml: '../'
  'chai'.expect
}

describe 'htgen', ->

  xdescribe 'API', (_) ->

    it 'should expose a function object', ->
      expect oml .to.be.a 'function'

       
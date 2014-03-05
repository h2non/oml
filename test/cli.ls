require! {
  oml: '../'
  'chai'.expect
  'child_process'.spawn
  '../package.json'.version
}

exec = (type, args, callback) ->
  command = spawn process.exec-path, [ "#{__dirname}/../bin/oml" ] ++ args
  if type is 'close'
    command.on type, callback
  else
    data = ''
    command.stdout.on type, -> data += it.to-string!
    command.on 'close', (code) -> data |> callback _, code

describe 'CLI', (_) ->

  describe '--version', (_) ->

    it 'should return the version with --version flag', (done) ->
      exec 'data', ['--version'], ->
        expect it .to.be.equal "#{version}\n"
        done!

    it 'should return the version with -V flag', (done) ->
      exec 'data', ['-V'], ->
        expect it .to.be.equal "#{version}\n"
        done!

  describe '--pretty', (_) ->

    it 'should render reading from file', (done) ->
      exec 'data', ['--pretty' "#{__dirname}/fixtures/nested.oli"], ->
        expect it .to.be.equal '<div>\n  <p>text</p>\n</div>\n'
        done!

  describe '--in-line', (_) ->

    it 'should render in-line block', (done) ->
      exec 'data', ['-i' 'p: hello world'], ->
        expect it .to.match /<p>hello world<\/p>/
        done!

  describe '--tabs', (_) ->

    it 'should render with tabs block', (done) ->
      exec 'data', ['--tabs' "#{__dirname}/fixtures/nested.oli"], ->
        expect it .to.be.equal '<div>\n\t<p>text</p>\n</div>\n'
        done!

  describe '--indent', (_) ->

    it 'should render with custom indent', (done) ->
      exec 'data', ['--pretty' '--indent' '4' "#{__dirname}/fixtures/nested.oli"], ->
        expect it .to.be.equal '<div>\n    <p>text</p>\n</div>\n'
        done!

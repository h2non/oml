require! {
  fs
  './oml'
  './helpers'.echo
  '../package.json'.version
  program: commander
}

options = indent: 2

exports.parse = -> 
  it |> program.parse
  init!

program
  .version version
  .usage '[options] <path/to/file.oli>'
  .option '-o, --output <file>', 'write output into a file instead of stdout'
  .option '-i, --in-line', 'parse in-line argument as string'
  .option '-p, --pretty', 'generate well-indented pretty output'
  .option '-d, --indent <size>', 'Output indent size. Default to 2 spaces'
  .option '-t, --tabs', 'use tabs instead of spaces to indent'
  .option '-s, --stdin', 'read source from stdin'

program.on '--help', ->
  echo '  Usage examples:'
  echo!
  echo '    $ oml file.oli > file.html'
  echo '    $ oml file.oli -o file.html'
  echo '    $ oml -i "div: p: Hello"'
  echo '    $ oml -s < file.oli'
  echo '    $ oml --indent --pretty 4 file.oli'
  echo!

program
  .on('in-line', -> options.in-line = true)
  .on('output', (file) -> options.output = file)
  .on('stdin', -> options.stdin = true)
  .on('tabs', -> options.pretty = options.tabs = true)
  .on('pretty', -> options.pretty = true)
  .on 'indent', (size) ->
    options.indent = if size is null then 2 else parseInt size, 10
    options.pretty = true

init = ->
  if options.stdin
    stdin!
  else
    getSource! |> parse |> output
  
parse = ->
  it |> oml.render _, options

stdin = ->
  buf = ''
  process.stdin.setEncoding 'utf8'
  process.stdin.on 'data', -> buf += it
  process.stdin.on('end', ->
    if buf
      process.stdout.write parse buf
      echo!
  ).resume()

getSource = ->
  if options.in-line
    source = program.args.join ' '
  else 
    if program.args
      source = program.args.map(->
        fs.readFileSync it
      ).join ' '
  source

output = ->
  if options.output
    it |> fs.writeFileSync options.output, _
  else
    it |> echo if it

outputError = ->
  echo "#{it.name}: #{it.message}"
  echo '\n' + it.errorLines.join('\n') if it.errorLines
  process.exit 1

require! {
  './helpers'.echo
  '../package.json'.version
  program: commander
}

exports.parse = -> it |> program.parse

program
  .version version
  .usage '[options] <path/to/file.oli>'
  .option '-p, --parse', 'parse and return the result as JSON'
  .option '-t, --tokens', 'parse and return a collection of the tokens as JSON'
  .option '-o, --output <file>', 'write output into a file instead of stdout'
  .option '-a, --ast', 'return the parsed AST serialized as JSON'
  .option '-i, --in-line', 'parse in-line argument as string'
  .option '-d, --indent <size>', 'JSON output indent size. Default to 2'
  .option '-s, --stdin', 'Read source from stdin'
  .option '-r, --repl', 'use the interactive read-eval-print loop interface'

program.on '--help', ->
  echo '''
    Usage examples:

      $ oml file.oli > file.html
      $ oml file.oli -o file.html

  '''


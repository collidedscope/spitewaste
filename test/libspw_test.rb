require_relative 'test_helper'
require_relative 'fixtures/whitespace'

class LibspwTest < Minitest::Test
  docs = File.expand_path '../lib/spitewaste/libspw/docs.json', __dir__
  db = JSON.load File.read docs

  mods = db.keys - %w[io random] # tested separately due to statefulness
  # Generate a Spitewaste program that imports all of the documented standard
  # library modules. We'll be hot-loading instructions into the dummy main.
  spw = mods.map { "import #{_1}\n" }.join + 'main: exit'

  tmp = Tempfile.new
  as = Spitewaste::Assembler.new spw,
    keep_dead_code: true, 'symbol_file' => tmp.path
  symbols = JSON.load File.read tmp.path

  # Assemble to Whitespace, parse, and interpret to set up jump targets.
  src = StringIO.new.tap { |sio| as.assemble! format: :whitespace, io: sio }
  ws = Whitespace.new src.tap(&:close).string
  ws.parse
  ws.interpret

  db.each do |mod, fns|
    fns.each do |fn, data|
      define_method "test_libspw_#{mod}/#{fn}" do
        data['cases'].each do |stack, expected|
          ws.stack = stack
          ws.run_live [[:call, symbols[fn]]]
          assert_equal expected, ws.stack
        end
      end
    end
  end
end

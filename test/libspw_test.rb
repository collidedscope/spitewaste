require_relative 'test_helper'
require_relative 'fixtures/whitespace'

class LibspwTest < Minitest::Test
  docs = File.expand_path '../lib/spitewaste/libspw/docs.json', __dir__
  db = JSON.load File.read docs

  # Generate a Spitewaste program that just imports the entire standard library.
  # We'll be hot-loading instructions into the dummy main.
  spw = db.keys.map { |lib| "import #{lib}\n" }.join + 'main: exit'

  tmp = Tempfile.new
  as = Spitewaste::Assembler.new spw,
    keep_dead_code: true, 'symbol_file' => tmp.path
  symbols = JSON.load File.read tmp.path

  # Assemble to Whitespace, parse, and interpret to set up jump targets.
  src = StringIO.new.tap { |sio| as.assemble! format: :whitespace, io: sio }
  ws = Whitespace.new src.tap(&:close).string
  ws.parse
  ws.interpret

  db.each do |lib, fns|
    fns.each do |fn, data|
      define_method "test_libspw_#{lib}/#{fn}" do
        data['cases'].each do |stack, expected|
          ws.stack = stack
          ws.run_live [[:call, symbols[fn]]]
          assert_equal expected, ws.stack
        end
      end
    end
  end
end

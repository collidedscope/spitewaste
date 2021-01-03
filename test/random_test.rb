require 'test_helper'
require_relative 'fixtures/whitespace'

class RandomTest < Minitest::Test
  def test_that_it_correctly_handles_randomness
    spw2ws = StringIO.new
    as = Spitewaste::Assembler.new get_fixture 'random.spw'
    as.assemble! format: :whitespace, io: spw2ws

    ws = Whitespace.new spw2ws.string
    ws.parse.interpret
    assert_empty ws.stack
  end
end

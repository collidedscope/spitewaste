require 'test_helper'

FIXTURES = File.expand_path 'fixtures', __dir__

def get_fixture file
  File.read File.join(FIXTURES, file)
end

def src_to_src input, format
  StringIO.new.tap { |sio|
    Spitewaste::Assembler.new(input).assemble! format: format, io: sio
    sio.close
  }.string
end

class SpitewasteTest < Minitest::Test
  extend Minitest::Spec::DSL

  let(:ws)  { get_fixture 'ws.ws' }
  let(:wsa) { get_fixture 'ws.wsa' }
  let(:asm) { get_fixture 'ws.asm' }
  let(:spw) { get_fixture 'ws.spw' }

  def test_that_it_guesses_whitespace_format
    as = Spitewaste::Assembler.new ws
    assert_equal as.parser, Spitewaste::WhitespaceParser
  end

  def test_that_it_guesses_spitewaste_format
    as = Spitewaste::Assembler.new spw
    assert_equal as.parser, Spitewaste::SpitewasteParser
  end

  def test_that_it_guesses_assembly_format
    as = Spitewaste::Assembler.new asm
    assert_equal as.parser, Spitewaste::AssemblyParser
  end

  def test_that_it_guesses_wsa_format_as_spitewaste
    as = Spitewaste::Assembler.new wsa
    assert_equal as.parser, Spitewaste::SpitewasteParser
  end

  def test_that_it_converts_spitewaste_to_whitespace
    assert_equal ws, src_to_src(spw, :whitespace)
  end

  def test_that_it_converts_spitewaste_to_assembly
    assert_equal asm, src_to_src(spw, :assembly)
  end

  def test_that_it_converts_spitewaste_to_whitespace_assembly
    assert_equal wsa, src_to_src(spw, :wsassembly)
  end

  def test_that_it_converts_whitespace_to_assembly
    assert_equal asm, src_to_src(ws, :assembly)
  end

  def test_that_it_converts_whitespace_to_whitespace
    assert_equal ws, src_to_src(ws, :whitespace)
  end

  def test_that_it_converts_assembly_to_whitespace
    assert_equal ws, src_to_src(asm, :whitespace)
  end

  def test_that_it_converts_assembly_to_assembly
    assert_equal asm, src_to_src(asm, :assembly)
  end
end

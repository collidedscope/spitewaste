require 'test_helper'
require_relative 'fixtures/whitespace'

FIXTURES = File.expand_path 'fixtures', __dir__

def get_fixture file
  File.read File.join(FIXTURES, file)
end

class SpitewasteTest < Minitest::Test
  include Spitewaste
  extend Minitest::Spec::DSL

  let(:ws)   { get_fixture 'ws.ws' }
  let(:wsa)  { get_fixture 'ws.wsa' }
  let(:asm)  { get_fixture 'ws.asm' }
  let(:spw)  { get_fixture 'ws.spw' }
  let(:fb)   { get_fixture 'fizzbuzz' }
  let(:fbws) { File.join FIXTURES, 'fizzbuzz.ws' }

  def test_that_it_guesses_whitespace_format
    as = Assembler.new ws
    assert_instance_of WhitespaceParser, as.parser
  end

  def test_that_it_guesses_spitewaste_format
    as = Assembler.new spw
    assert_instance_of SpitewasteParser, as.parser
  end

  def test_that_it_guesses_assembly_format
    as = Assembler.new asm
    assert_instance_of AssemblyParser, as.parser
  end

  def test_that_it_guesses_wsa_format_as_spitewaste
    as = Assembler.new wsa
    assert_instance_of SpitewasteParser, as.parser
  end

  def test_that_it_correctly_executes_spitewaste
    spw2ws = StringIO.new
    Assembler.new(spw).assemble! format: :whitespace, io: spw2ws
    ws = Whitespace.new(spw2ws.string).tap &:parse

    output = StringIO.new
    File.open(fbws) { |f| ws.interpret inio: f, outio: output }
    assert_equal fb, output.string
  end
end

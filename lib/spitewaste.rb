module Spitewaste
  OPERATORS_M2T = { # mnemonic to tokens
    push:  "  ",       copy: " \t ",   slide: " \t\n",   label: "\n  ",
    call:  "\n \t",    jump: "\n \n",  jz:    "\n\t ",   jn:    "\n\t\t",
    pop:   " \n\n",    dup:  " \n ",   swap:  " \n\t",   add:   "\t   ",
    sub:   "\t  \t",   mul:  "\t  \n", div:   "\t \t ",  mod:   "\t \t\t",
    store: "\t\t ",    load: "\t\t\t", ret:   "\n\t\n",  ichr:  "\t\n\t ",
    inum:  "\t\n\t\t", ochr: "\t\n  ", onum:  "\t\n \t", exit:  "\n\n\n",
    shell: "\t\n\n",   eval: "\n\n\t"
  }
  OPERATORS_T2M = OPERATORS_M2T.invert # tokens to mnemonic

  module_function

  def guess_format program
    white = program.count "\s\t\n"
    black = program.size - white

    return :whitespace if white > black
    program[/import|[^-\w\s]/] ? :spitewaste : :assembly
  end
end

require 'spitewaste/assembler'

require 'spitewaste/parsers/spitewaste'
require 'spitewaste/parsers/whitespace'
require 'spitewaste/parsers/assembly'

require 'spitewaste/emitter'
require 'spitewaste/emitters/whitespace'
require 'spitewaste/emitters/assembly'
require 'spitewaste/emitters/wsassembly'
require 'spitewaste/emitters/codegen'
require 'spitewaste/emitters/image'

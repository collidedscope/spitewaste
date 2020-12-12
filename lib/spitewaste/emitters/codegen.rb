module Spitewaste
  # Despite my best efforts to torture it into something vaguely resembling a
  # high-level language, Whitespace is quite simple at bottom; so much so that
  # mapping almost all of its instructions to equivalent C++ code is a
  # relatively straightforward endeavor, so long as we don't mind using goto.
  #
  # The only interesting aspect of this approach is how we go about calling
  # into and returning from subroutines. A call instruction generates a goto
  # to the label in its argument and a label immediately after that goto, whose
  # address gets pushed onto a stack of "call sites". Naturally, a return
  # instruction simply pops the address to jump to by way of a computed goto.
  class CodegenEmitter < Emitter
    def emit io:
      io.puts <<CPP
#include <algorithm>
#include <iostream>
#include <map>
#include <stack>
#include <vector>
#include <gmpxx.h>

using namespace std;
typedef mpz_class num;

vector<num> S;
map<num, num> H;
stack<void *> C;
void *cs;
num n;

num pop() { num c = S.back(); S.pop_back(); return c; }

int main(void) {
CPP
      cs = -1 # call site
      instructions.each do |op, arg|
        io.puts case op
          when :push  ; "S.push_back(#{arg});"
          when :pop   ; "pop();"
          when :dup   ; "S.push_back(S.back());"
          when :swap  ; "reverse(S.end() - 2, S.end());"
          when :copy  ; "S.push_back(S[S.size() - 1 - #{arg}]);"
          when :slide ; "S.erase(S.end() - #{arg} - 1, S.end() - 1);"

          when :add   ; "S[S.size() - 2] += S.back(); S.pop_back();"
          when :sub   ; "S[S.size() - 2] -= S.back(); S.pop_back();"
          when :mul   ; "S[S.size() - 2] *= S.back(); S.pop_back();"
          when :div   ; "{ auto d = pop(); auto n = S.back().get_mpz_t();" +
                        "mpz_fdiv_q(n, n, d.get_mpz_t()); }"
          when :mod   ; "{ auto d = pop(); auto n = S.back().get_mpz_t();" +
                        "mpz_fdiv_r(n, n, d.get_mpz_t()); }"

          when :label ; "L#{arg}:"
          when :jump  ; "goto L#{arg};"
          when :jz    ; "if (!pop()) goto L#{arg};"
          when :jn    ; "if (pop() < 0) goto L#{arg};"
          when :call  ; "C.push(&&C#{cs += 1}); goto L#{arg}; C#{cs}:"
          when :ret   ; "cs = C.top(); C.pop(); goto *cs;"
          when :exit  ; "goto done;"

          when :ichr  ; "H[pop()] = cin.get();"
          when :inum  ; "cin >> n; cin.ignore(); H[pop()] = n;"
          when :ochr  ; "cout << (char) pop().get_ui();"
          when :onum  ; "cout << pop();"
          when :store ; "n = pop(); H[pop()] = n;"
          when :load  ; "S.push_back(H[pop()]);"
        end
      end
      io.puts 'done: return S.size(); }' # punish dirty exit
    end
  end
end

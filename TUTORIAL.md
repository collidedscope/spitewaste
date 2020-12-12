For starters, note that Spitewaste is a strict superset of Whitespace (assembly) insofar as it doesn't add anything to the instruction set. That is, what we ultimately have to work with are a stack, a "heap" (hash, dictionary) of integer key-value pairs, and these 24 instructions:

<table>
  <tr>
    <td colspan="2" align="center"><b>stack manipulation</b></td>
  </tr>
  <tr>
    <td><code>push <em>n</em></code></td>
    <td>Push the value <em>n</em> onto the stack.</td>
  </tr>
  <tr>
    <td><code>pop</code></td>
    <td>Remove the value at the top of the stack.</td>
  </tr>
  <tr>
    <td><code>dup</code></td>
    <td>Duplicate the value at the top of the stack.</td>
  </tr>
  <tr>
    <td><code>swap</code></td>
    <td>Swap the top two values of the stack.</td>
  </tr>
  <tr>
    <td><code>copy <em>n</em></code></td>
    <td>Place a copy of the <em>n</em>th value at the top of the stack.<br><code>copy 0</code> is a funny way to write <code>dup</code></td>
  </tr>
  <tr>
    <td><code>slide <em>n</em></code></td>
    <td>Remove <em>n</em> values from the top of the stack, but preserve the top.</td>
  </tr>
  <tr>
    <td colspan="2" align="center"><b>control flow</b></td>
  </tr>
  <tr>
    <td><code>label <em>n</em></code></td>
    <td>Mark a position in the program and name it <em>n</em>.</td>
  </tr>
  <tr>
    <td><code>jump <em>n</em></code></td>
    <td>Unconditionally jump to label <em>n</em>.
  </tr>
  <tr>
    <td><code>jz <em>n</em></code></td>
    <td>Pop the stack and jump to label <em>n</em> if the popped value was zero.
  </tr>
  <tr>
    <td><code>jn <em>n</em></code></td>
    <td>Pop the stack and jump to label <em>n</em> if the popped value was negative.
  </tr>
  <tr>
    <td><code>call <em>n</em></code></td>
    <td>Jump to label <em>n</em>, expecting it to <code>ret</code> in order to return to this call site.
  </tr>
  <tr>
    <td><code>ret</code></td>
    <td>Return to the most recent call site.</td>
  </tr>
  <tr>
    <td><code>exit</code></td>
    <td>Halt execution immediately.</td>
  </tr>
  <tr>
    <td colspan="2" align="center"><b>arithmetic</b></td>
  </tr>
  <tr>
    <td><code>add</code></td>
    <td>Pop the top two values of the stack and push their sum.</td>
  </tr>
  <tr>
    <td><code>sub</code></td>
    <td>Pop the top two values of the stack and push their difference.<br>The top gets subtracted, so <code>push 3 push 5 sub</code> leaves -2 on the stack.</td>
  </tr>
  <tr>
    <td><code>mul</code></td>
    <td>Pop the top two values of the stack and push their product.</td>
  </tr>
  <tr>
    <td><code>div</code></td>
    <td>Pop the top two values of the stack and push their quotient.<br><b>Note:</b> floored, truncating division so -5 / 2 == -3</td>
  </tr>
  <tr>
    <td><code>mod</code></td>
    <td>Pop the top two values of the stack and push their modulus.<br><b>Note:</b>-1 % 4 == 3</td>
  </tr>
  <tr>
    <td colspan="2" align="center"><b>heap access</b></td>
  </tr>
  <tr>
    <td><code>store</code></td>
    <td>Pop the value then the key and store the pair in the heap.<br><code>push 4 push 2 store</code> => <code>{4: 2}</code></td>
  </tr>
  <tr>
    <td><code>load</code></td>
    <td>Pop the key and push the associated heap value.<br><b>Note:</b> Undefined heap slots have an implicit value of 0.</td>
  </tr>
  <tr>
    <td colspan="2" align="center"><b>input/output</b></td>
  </tr>
  <tr>
    <td><code>ichr</code></td>
    <td>Read a character (byte) from <code>stdin</code>, pop a key from the top of the stack, <br>and store the byte in the heap at that key.</td>
  </tr>
  <tr>
    <td><code>inum</code></td>
    <td>Read a number from <code>stdin</code>, pop a key from the top of the stack, <br>and store the byte in the heap at that key.</td>
  </tr>
  <tr>
    <td><code>ochr</code></td>
    <td>Pop the top of the stack and print it (as a character) to <code>stdout</code>.</td>
  </tr>
  <tr>
    <td><code>onum</code></td>
    <td>Pop the top of the stack and print it (as a number) to <code>stdout</code>.</td>
  </tr>
</table>

## What Spitewaste adds

A standard library! Writing a Whitespace program from scratch can be a daunting endeavor. TODO: more here.

### Strings

Pretty much every program needs strings, and Spitewaste has 'em! But how? Well, a string is ultimately just a sequence of bytes, and we can use the power of exponents to smush multiple numbers into a single value. If we had the numbers 3, 9, and 4, we could easily encode them as a single base-10 number: 3 × 10<sup>2</sup> + 9 × 10<sup>1</sup> + 4 × 10<sup>0</sup>. Strings in Spitewaste are similarly encoded, except backwards (as an implementation detail) and in base-128 rather than decimal.

When you say <code>push "ABC"</code>, the assembler transforms it into <code>push 1106241</code>, the value of: 67 ('C') × 128<sup>2</sup> + 66 × 128<sup>1</sup> + 65 × 128<sup>0</sup>. Whitespace interpreters SHOULD (and many do) support arbitrarily large integers, so we don't have to worry about these representations not fitting into 64 bits. Once we're able to pass strings around as individual values, a plethora of possibilities opens up, and the standard library contains many string functions to reflect this.

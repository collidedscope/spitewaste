module Spitewaste
  # select() and reject() do almost the exact same thing, differing only in
  # whether they drop or keep the match, so this is a bit of deduplication.
  def self.generate_filter_spw fn, a, b
    ops = ['push -10 dup call dec load swap store', 'pop']
    yes, no = ops[a], ops[b]
    <<SPW
push -10 dup store
#{fn}_loop_%1$s:
  push 1 sub dup jn #{fn}_restore_%1$s
  swap dup %2$s jz #{fn}_no_%1$s #{yes}
  jump #{fn}_loop_%1$s
#{fn}_no_%1$s: #{no} jump #{fn}_loop_%1$s
#{fn}_restore_%1$s: push 9 sub load
#{fn}_restore_loop_%1$s:
  dup push 10 add jz #{fn}_done_%1$s
  dup load swap push 1 add
  jump #{fn}_restore_loop_%1$s
#{fn}_done_%1$s: dup load sub
SPW
  end

  FUCKTIONAL = {
    'map' => <<SPW,
push -9 push -1 store swap
map_loop_%1$s:
  push -9 call inc swap dup dup
  push -9 load sub jz map_done_%1$s
  call roll %2$s jump map_loop_%1$s
map_done_%1$s: pop
SPW

    'reduce' => <<SPW,
dup dup push 2 sub jn reduce_done_%1$s pop
push -9 swap push 1 sub store
reduce_loop_%1$s: %2$s
  push -9 dup load push 1 sub dup jz reduce_done_%1$s
  store jump reduce_loop_%1$s
reduce_done_%1$s: pop pop
SPW

    'times' => <<SPW,
push -5 swap push -1 mul store
times_loop_%1$s: %2$s push -5 dup call inc load jn times_loop_%1$s
SPW

    'find' => <<SPW,
find_loop_%1$s:
  dup jz find_done_%1$s dup call roll
  dup %2$s jz find_no_%1$s
  swap push 1 sub call nslide push 1 add jump find_done_%1$s
find_no_%1$s: pop push 1 sub jump find_loop_%1$s
find_done_%1$s: push 1 sub
SPW

    'maxby' => <<SPW,
push -3 swap store
maxby_loop_%1$s:
  copy 1 %2$s copy 1 %2$s sub jn maxby_lesser_%1$s
maxby_resume_%1$s: pop push -3 dup call dec load push 1 call eq
  jz maxby_loop_%1$s
  jump maxby_done_%1$s
maxby_lesser_%1$s: swap jump maxby_resume_%1$s
maxby_done_%1$s:
SPW

    'minby' => 'maxby (%2$s push -1 mul)',
    'each' => 'dup times (dup call roll %2$s push 1 sub) pop',
    'count' => 'select (%2$s) dup call nslide',
    'select' => generate_filter_spw('select', 0, 1),
    'reject' => generate_filter_spw('reject', 1, 0),
  }
end

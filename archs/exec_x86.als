module exec_x86[E]
open exec_H[E]

sig Exec_X86 extends Exec_H {
  locked : set E // atomic events
  mfence : E->E // memory fence
}{
  // only RMWs can be locked
  locked in univ.atom + atom.univ

  // the atom relation only relates locked instructions
  atom in (locked -> locked)

  // memory fences
  is_fence_rel[mfence,sb]
}

fun locked[e:E, x:Exec_X86] : set E { x.locked - e }

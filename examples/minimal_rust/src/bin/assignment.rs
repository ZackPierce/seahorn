extern {
  fn __VERIFIER_error();
}

fn main() {
  let mut a: i32 = 1;
  let b: i32 = 2;
  // A trivially true assert
  verifier_assert(a + b > 1);
  a = -1;

  // Another trivially true assert
  verifier_assert(b == 3 || a == -1 || b == 2);

  // Finally, a definitely false assert.
  // Comment it out if you want the seahorn test to succeed
  verifier_assert(b == 3 && a == -1 && b == 2);
}

fn verifier_assert(condition: bool) {
  if !condition {
    unsafe {
      __VERIFIER_error();
    }
  }
}

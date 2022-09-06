module scheduler::vector_utils {
 use std::vector;
 use std::error;
 
 const EVECTOR_LENGTH_MISMATCH: u64 = 0;
 const EVECTOR_INVALID_RANGE : u64 = 1;
 const EVECTOR_INVALID_RANGE_STEP : u64 = 2;

 public fun lt(a: &vector<u8>, b: &vector<u8>): bool {
  let i = 0;
  let len = vector::length(a);
  assert!(len == vector::length(b), error::invalid_argument(EVECTOR_LENGTH_MISMATCH));

  loop {
      if (i >= len) break;
      let aa = *vector::borrow(a, i);
      let bb = *vector::borrow(b, i);
      if (aa < bb) return true;
      if (aa > bb) return false;
      i = i + 1;
  };

  false
 }

 public fun gt(a: &vector<u8>, b: &vector<u8>): bool {
  let i = 0;
  let len = vector::length(a);
  assert!(len == vector::length(b), error::invalid_argument(EVECTOR_LENGTH_MISMATCH));

  loop {
      if (i >= len) break;
      let aa = *vector::borrow(a, i);
      let bb = *vector::borrow(b, i);
      if (aa > bb) return true;
      if (aa < bb) return false;
      i = i + 1;
  };

  false
 }

 public fun lte(a: &vector<u8>, b: &vector<u8>): bool {
  let i = 0;
  let len = vector::length(a);
  assert!(len == vector::length(b), error::invalid_argument(EVECTOR_LENGTH_MISMATCH));

  loop {
      if (i >= len) break;
      let aa = *vector::borrow(a, i);
      let bb = *vector::borrow(b, i);
      if (aa < bb) return true;
      if (aa > bb) return false;
      i = i + 1;
  };

  true
 }

 public fun gte(a: &vector<u8>, b: &vector<u8>): bool {
  let i = 0;
  let len = vector::length(a);
  assert!(len == vector::length(b), error::invalid_argument(EVECTOR_LENGTH_MISMATCH));

  loop {
      if (i >= len) break;
      let aa = *vector::borrow(a, i);
      let bb = *vector::borrow(b, i);
      if (aa > bb) return true;
      if (aa < bb) return false;
      i = i + 1;
  };

  true
 }

 public fun remove<T : copy>(v: &vector<T>, element: &T) : vector<T> {
  let dummy_vector = vector::empty<T>();
  let vector_length = vector::length(v);
  let i : u64 = 0;
  while (i < vector_length){
   let el= vector::borrow(v, i);
   if (el != element){
      vector::push_back(&mut dummy_vector, *el);
   };
   i = i + 1;
  };
  dummy_vector
 }

 public fun populate_u64_vector(start: u64, end: u64, step: u64) : vector<u64> {
  let result = &mut vector::empty<u64>();
  assert!(end >= start, error::invalid_argument(EVECTOR_INVALID_RANGE));
  assert!(step - 1 <= end - start, error::invalid_argument(EVECTOR_INVALID_RANGE_STEP));
  let i = start;
  while (i <= end) {
   vector::push_back(result, i);
   i = i + step;
  };

  *result
 }
}
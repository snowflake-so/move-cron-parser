module cron::string_utils {
 use std::vector::Self;

 public fun ascii_number_vec_to_u64(num: vector<u8>) : u64{
  let i = 0;
  let value : u64 = 0;
  let num_length = vector::length(&num);
  while (i < num_length){
   let cur = *vector::borrow(&num, i);
   value = value + (((cur  as u64) + 10) - 57 - 1);
   if (i < num_length - 1){
     value = value * 10;
   };
   i = i + 1;
  };

  value
 }

 public fun split(str_bytes: &vector<u8>, separator: &vector<u8>) : vector<vector<u8>> {
  let sep_byte = vector::borrow(separator, 0);
  let result = &mut vector::empty<vector<u8>>();
  let l = vector::length(str_bytes);
  let i = 0;

  let temp = &mut vector::empty<u8>();
  while (i < l) {
   let cur_byte = vector::borrow(str_bytes, i);
   if (cur_byte == sep_byte){
    vector::push_back(result, *temp);
    temp = &mut vector::empty<u8>();
   } else {
    vector::push_back(temp, *cur_byte);
   };
   
   i = i + 1;
  };

  if (vector::length(temp) > 0){
   vector::push_back(result, *temp);
  };

  *result
 }

 #[test]
 fun test_split_string_correctly() {
  let str = &b"hello, world";
  let sep = &b",";
  let splitted_str = split(str, sep);
  assert!(*vector::borrow(
   &splitted_str, 0
   ) == b"hello", 
  0);

  assert!(*vector::borrow(
   &splitted_str, 1
   ) == b" world", 
  0);
 }
}
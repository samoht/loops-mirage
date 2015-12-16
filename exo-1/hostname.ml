(* Exercice 1: warm-up *)

(* encode is the function which translate a string into a list of
   integers which represents their ASCII code. *)
let encode (s:bytes): int list = failwith "TODO"

(* decode is the reverse operation of encode *)
let decode (p: int list): bytes = failwith "TODO"

let () =
  assert (encode "foo"
          = [102; 111; 111]);
  assert (encode "http://google.com"
          = [104; 116; 116; 112; 58; 47; 47; 103; 111; 111; 103; 108;
             101; 46; 99; 111; 109]);
  assert (decode [102; 111; 111] = "foo");
  assert (let s = Bytes.create 42 in decode (encode s) = s)

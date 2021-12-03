use std::env;

use std::clone::Clone;
use std::fs::File;
use std::io::BufRead;
use std::io::BufReader;

fn main() {
   let fname = match env::args().nth(1) {
        Some(fname) => fname,
        None => panic!("Need a file name"),
   };

   let f = match File::open(fname) {
       Ok(f) => f,
       Err(_) => panic!("Could not open file"),
   };

   let buf = BufReader::new(f);

   let arr : Vec<u32> = buf.lines().map(|e| e.unwrap().parse::<u32>().unwrap()).collect();

   let iter = arr.iter();

   let skipiter = iter.clone().skip(1);
   let skipskipiter = iter.clone().skip(2);

   let stream = iter.zip(skipiter).zip(skipskipiter).map(|e| e.0.0 + e.0.1 + e.1);

   let mut count = 0;
   let mut last : u32 = 0;

   for cur in stream {
       println!("{}", cur);
       if last != 0 {
            if last < cur {
                count += 1;
            }
       }
       last = cur;
   }

   println!("{}", count);
}

use std::io::prelude::*;
use std::fs::File;
use std::io::BufReader;

fn main() -> Result<(), std::io::Error> {
    let f = File::open("input.txt")?;
    let r = BufReader::new(f);

    for line in r.lines() {
        println!("Line {}\n", line.unwrap());
    }

    Ok(())
}

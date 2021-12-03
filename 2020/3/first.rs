//use std::io::prelude::*;
use std::fs::File;
use std::io::BufReader;
use std::io::BufRead;

fn main() -> Result<(), std::io::Error> {
    let f = File::open("input.txt")?;
    let r = BufReader::new(f);


    let cells : Vec<Vec<char>> = r.lines().map(|row|
                                                 match row { 
                                                     Ok(r) => r.chars().collect(),
                                                     Err(_e) => Vec::new()
                                                 }
                                         ).collect();



    let rows = cells.len();
    let cols = cells[0].len();

    let steps = [
        [1,1],
        [3,1],
        [5,1],
        [7,1],
        [1,2]
    ];

    
    let trees: Vec<_>= steps.iter().map(|steparr| {

        let mut count = 0;
        let (mut currow,mut curcol) = (0,0);
        let [stepcol,steprow] = steparr;

        loop {
            currow+=steprow;

            if currow >= rows {
                return count;
            }

            curcol=(curcol+stepcol) % cols;

            if cells[currow][curcol] == '#' {
                count+=1;
            }
        }
    }).collect();

    println!("{:?}", trees);
    Ok(())
}

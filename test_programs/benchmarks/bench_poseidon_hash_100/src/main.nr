global SIZE: u32 = 100;

fn main(input: [[Field; 2]; SIZE]) -> pub [Field; SIZE] {
    let mut results: [Field; SIZE] = [0; SIZE];
    for i in 0..SIZE {
        results[i] = poseidon::poseidon::bn254::hash_2(input[i]);
    }

    results
}

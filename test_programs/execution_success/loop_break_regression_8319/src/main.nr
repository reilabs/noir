// Regression for issue #8319 (https://github.com/noir-lang/noir/issues/8319)
unconstrained fn main() {
    func_4(([982714762, 1608230664, 671108204]))
}

unconstrained fn func_4(a: [u32; 3]) {
    {
        let mut idx_b = 0;
        loop {
            if (idx_b == 6) {
                break
            } else {
                idx_b = (idx_b + 1);
                {
                    let mut idx_c = 0;
                    loop {
                        if (idx_c == 7) {
                            break
                        } else {
                            idx_c = (idx_c + 1);
                            for idx_d in ((a[2] / 1193346642) % 4)..(a[1] % 4) {
                                {
                                    let mut idx_g = 0;
                                    loop {
                                        if (idx_g == 3) {
                                            break
                                        } else {
                                            idx_g = (idx_g + 1);
                                            let h = (a[0] % idx_d);
                                            println(h);
                                        }
                                    }
                                };
                                break;
                            }
                        }
                    }
                };
            }
        }
    }
}

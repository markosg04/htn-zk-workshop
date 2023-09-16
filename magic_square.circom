pragma circom 2.0.0;

template MagicSquare() {

    signal input a11;
    signal input a12;
    signal input a13;

    signal input a21;
    signal input a22;
    signal input a23;

    signal input a31;
    signal input a32;
    signal input a33;

    signal cells[9];

    cells[0] <== a11;
    cells[1] <== a12;
    cells[2] <== a13;

    cells[3] <== a21;
    cells[4] <== a22;
    cells[5] <== a23;

    cells[6] <== a31;
    cells[7] <== a32;
    cells[8] <== a33;

    //1st Constraint: row, col, diag sum to 15 -------

    signal sumRows[3];
    signal sumCols[3];
    signal sumDiags[3];


    sumRows[0] <== a11 + a12 + a13;
    sumRows[1] <== a21 + a21 + a31;
    sumRows[2] <== a31 + a32 + a33;

    sumCols[0] <== a11 + a21 + a31;
    sumCols[1] <== a12 + a22 + a32;
    sumCols[2] <== a13 + a23 + a33;

    sumDiags[0] <== a11 + a22 + a33;
    sumDiags[0] <== a13 + a22 + a31;

    for (var i = 0; i < 3; i++) {
        sumRows[i] === 15;
        sumCols[i] === 15;
    }

    for (var i = 0; i < 2; i++) {
        sumDiags[i] === 15;
    }

    // 1st constraint done -------

    // 2nd constraint: uniqueness
    // Use a hashmap or some structure to keep track of frequency
    // 3 x 3 grid (sort cells and then do a linear check 1-9)
    // Pairwise check (9 choose 2)
    // take a hash of a 1-9 list, and then compare hash of sorted array to the original hash

    for (var i = 0; i < 9; i++) {
        for (var j = i+1; j < 9; j++) {
            assert(cells[i] - cells[j] !== 0);
        }
        //3nd constraint: 1 <= n <= 9
        assert(cells[i] >= 1);
        assert(cells[i] <= 9);
    }
}

component main = MagicSquare();
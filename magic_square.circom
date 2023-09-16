pragma circom 2.0.0;

template MagicSquare() {
    signal input magicNumber;

    signal input a11; // Top-left corner
    signal input a12; // Top-middle
    signal input a13; // Top-right corner

    signal input a21; // Middle-left
    signal input a22; // Center
    signal input a23; // Middle-right

    signal input a31; // Bottom-left corner
    signal input a32; // Bottom-middle
    signal input a33; // Bottom-right corner
    
    signal output result;

    // Array to aggregate the cells for easier checks
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

    // Constraint: Each row, column, and diagonal sums to magicNumber
    signal sumRows[3];
    signal sumCols[3];
    signal sumDiags[2];

    // Sum for rows
    sumRows[0] <== a11 + a12 + a13;
    sumRows[1] <== a21 + a22 + a23;
    sumRows[2] <== a31 + a32 + a33;

    // Sum for columns
    sumCols[0] <== a11 + a21 + a31;
    sumCols[1] <== a12 + a22 + a32;
    sumCols[2] <== a13 + a23 + a33;

    // Sum for diagonals
    sumDiags[0] <== a11 + a22 + a33;
    sumDiags[1] <== a13 + a22 + a31;

    for (var i = 0; i < 3; i++) {
        sumRows[i] === magicNumber;
        sumCols[i] === magicNumber;
    }

    for (var i = 0; i < 2; i++) {
        sumDiags[i] === magicNumber;
    }

    // Pairwise checks for uniqueness
    for (var i = 0; i < 9; i++) {
        for (var j = i+1; j < 9; j++) {
            assert(cells[i] - cells[j] != 0);  // Ensure uniqueness by checking the difference is non-zero
        }

        // Ensuring numbers are between 1 to 9
        assert(cells[i] >= 1);
        assert(cells[i] <= 9);
    }
    result <== magicNumber * a11 + a12;
}
component main = MagicSquare();
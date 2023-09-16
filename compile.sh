# Download powersOfTau28_hez_final_12.ptau if it does not exist
if [ ! -f "powersOfTau28_hez_final_12.ptau" ]; then
    wget https://hermez.s3-eu-west-1.amazonaws.com/powersOfTau28_hez_final_12.ptau
else
    echo "powersOfTau28_hez_final_12.ptau already exists. Skipping download."
fi

# Compile magic_square.circom (assuming circom is in PATH)
circom magic_square.circom --wasm --r1cs
npx snarkjs groth16 setup magic_square.r1cs powersOfTau28_hez_final_12.ptau circuit_0000.zkey
npx snarkjs zkey export verificationkey circuit_0000.zkey verification_key.json

# Move files to appropiate locations
mv magic_square_js/magic_square.wasm magic-square/public/
mv circuit_0000.zkey magic-square/public/
mv verification_key.json magic-square/src/

echo "Compile done!"

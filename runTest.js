

const snarkjs = require("snarkjs");
const fs = require("fs");

async function run() {
    const { proof, publicSignals } = await snarkjs.groth16.fullProve({
        magicNumber: 15,
        a11: 4, a12: 9, a13: 2,
        a21: 3, a22: 5, a23: 7,
        a31: 8, a32: 1, a33: 6
    }, "build/magic_square_js/magic_square.wasm", "circuit_0000.zkey");

    console.log("Proof: ");
    console.log(JSON.stringify(proof, null, 1));

    const vKey = JSON.parse(fs.readFileSync("verification_key.json"));

    const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);

    if (res === true) {
        console.log("Verification OK");
    } else {
        console.log("Invalid proof");
    }

}

run().then(() => {
    process.exit(0);
});

// const snarkjs = require("snarkjs");
// const fs = require("fs");

// async function run() {
//     const { proof, publicSignals } = await snarkjs.groth16.fullProve({a: 10, b: 21}, "build/magic_square_js/magic_square.wasm", "circuit_0000.zkey");

//     console.log("Proof: ");
//     console.log(JSON.stringify(proof, null, 1));

//     const vKey = JSON.parse(fs.readFileSync("verification_key.json"));

//     const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);

//     if (res === true) {
//         console.log("Verification OK");
//     } else {
//         console.log("Invalid proof");
//     }

// }

// run().then(() => {
//     process.exit(0);
// });
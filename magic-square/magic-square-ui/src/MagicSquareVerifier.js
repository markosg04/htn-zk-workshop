import React, { useState } from 'react';
import styled from 'styled-components';
import verification_key from './verification_key.json';
const snarkjs = window.snarkjs;

const Wrapper = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 100vh;  // This will ensure the content occupies the full viewport height.
`;

const Table = styled.table`
    border-collapse: collapse;
    margin-top: 20px;
    width: 200px;
    border: 2px solid #2c3e50;
`;

const Cell = styled.td`
    border: 1px solid #7f8c8d;
    width: 60px;
    height: 60px;
    text-align: center;
    background-color: #ecf0f1;
    transition: background-color 0.2s;

    &:hover {
        background-color: #bdc3c7;
    }
`;

const Input = styled.input`
    width: 100%;
    height: 100%;
    border: none;
    font-size: 1.2em;
    text-align: center;
    background-color: transparent;
    outline: none;
    -webkit-appearance: none; /* For removing the spinners/arrows */
    -moz-appearance: textfield; /* For Firefox */
    &::-webkit-inner-spin-button, 
    &::-webkit-outer-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }
`;

const Button = styled.button`
    margin-top: 20px;
    padding: 10px 20px;
    font-size: 1em;
    background-color: #3498db;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
    transition: background-color 0.2s;

    &:hover {
        background-color: #2980b9;
    }
`;

const VerificationMessage = styled.p`
    color: ${({ isSuccess }) => (isSuccess ? 'green' : 'red')};
    font-weight: bold;
    margin-top: 10px;
    text-align: center;
    width: 100%;      
`;

function MagicSquareVerifier() {
    const initialGrid = Array(3).fill(null).map(() => Array(3).fill(''));
    const [grid, setGrid] = useState(initialGrid);
    const [proof, setProof] = useState(null);
    const [verificationSuccess, setVerificationSuccess] = useState(null);
    const [verificationMessage, setVerificationMessage] = useState('');
    const handleInputChange = (row, col, value) => {
        const newGrid = [...grid];
        newGrid[row][col] = value;
        setGrid(newGrid);
    };
    
    const handleGenerateProof = async () => {
        const inputs = {
            magicNumber: 15,
            a11: grid[0][0], a12: grid[0][1], a13: grid[0][2],
            a21: grid[1][0], a22: grid[1][1], a23: grid[1][2],
            a31: grid[2][0], a32: grid[2][1], a33: grid[2][2]
        };
    
        try {
            const { proof: generatedProof, publicSignals } = await snarkjs.groth16.fullProve(
                inputs, 
                "magic_square.wasm", 
                "circuit_0000.zkey"
            );
            console.log(inputs);
            console.log("Proof: ");
            console.log(JSON.stringify(generatedProof, null, 1));
    
            setProof(generatedProof);
    
            const isValid = await handleVerifyProof(publicSignals, generatedProof);
            if (isValid) {
                setVerificationSuccess(true);
                setVerificationMessage('OK!');
            } else {
                setVerificationSuccess(false);
                setVerificationMessage('Proof is Incorrect');
            }
        } catch (error) {
            console.error("Error generating proof:", error);
            setVerificationSuccess(false);
            setVerificationMessage('Proof is Incorrect');
        }
    };
    

    const handleVerifyProof = async (publicSignals, proof) => {
        const vKey = verification_key;
        const res = await snarkjs.groth16.verify(vKey, publicSignals, proof);
        return res;
    };

    return (
        <Wrapper>
            <Table>
                <tbody>
                    {grid.map((row, rowIndex) => (
                        <tr key={rowIndex}>
                            {row.map((value, colIndex) => (
                                <Cell key={colIndex}>
                                    <Input 
                                        type="number" 
                                        value={value}
                                        onChange={(e) => handleInputChange(rowIndex, colIndex, e.target.value)} 
                                    />
                                </Cell>
                            ))}
                        </tr>
                    ))}
                </tbody>
            </Table>
            <Button onClick={handleGenerateProof}>Generate Proof</Button>
            {verificationMessage && (
                <VerificationMessage isSuccess={verificationSuccess}>
                    {verificationMessage}
                </VerificationMessage>
            )}
        </Wrapper>
    );
}

export default MagicSquareVerifier;
/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import { Provider, TransactionRequest } from "@ethersproject/providers";
import type { Counter, CounterInterface } from "../Counter";

const _abi = [
  {
    inputs: [
      {
        internalType: "address payable",
        name: "_pokeMe",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [],
    name: "count",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "increaseCount",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "lastExecuted",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "pokeMe",
    outputs: [
      {
        internalType: "address payable",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

const _bytecode =
  "0x60a060405234801561001057600080fd5b506040516105de3803806105de83398181016040528101906100329190610086565b808073ffffffffffffffffffffffffffffffffffffffff1660808173ffffffffffffffffffffffffffffffffffffffff1660601b8152505050506100f8565b600081519050610080816100e1565b92915050565b60006020828403121561009857600080fd5b60006100a684828501610071565b91505092915050565b60006100ba826100c1565b9050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6100ea816100af565b81146100f557600080fd5b50565b60805160601c6104c261011c6000396000818160d501526101d501526104c26000f3fe608060405234801561001057600080fd5b506004361061004c5760003560e01c806306661abd146100515780631c15ff771461006f57806346d4adf21461008d578063c84eee0d146100a9575b600080fd5b6100596100c7565b6040516100669190610354565b60405180910390f35b6100776100cd565b6040516100849190610354565b60405180910390f35b6100a760048036038101906100a2919061020c565b6100d3565b005b6100b16101d3565b6040516100be91906102f9565b60405180910390f35b60005481565b60015481565b7f000000000000000000000000000000000000000000000000000000000000000073ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff1614610161576040517f08c379a000000000000000000000000000000000000000000000000000000000815260040161015890610314565b60405180910390fd5b60b46001544261017191906103d6565b116101b1576040517f08c379a00000000000000000000000000000000000000000000000000000000081526004016101a890610334565b60405180910390fd5b806000808282546101c29190610380565b925050819055504260018190555050565b7f000000000000000000000000000000000000000000000000000000000000000081565b60008135905061020681610475565b92915050565b60006020828403121561021e57600080fd5b600061022c848285016101f7565b91505092915050565b61023e8161040a565b82525050565b600061025160178361036f565b91507f506f6b654d6552656164793a206f6e6c79506f6b654d650000000000000000006000830152602082019050919050565b600061029160288361036f565b91507f436f756e7465723a20696e637265617365436f756e743a2054696d65206e6f7460008301527f20656c61707365640000000000000000000000000000000000000000000000006020830152604082019050919050565b6102f38161043c565b82525050565b600060208201905061030e6000830184610235565b92915050565b6000602082019050818103600083015261032d81610244565b9050919050565b6000602082019050818103600083015261034d81610284565b9050919050565b600060208201905061036960008301846102ea565b92915050565b600082825260208201905092915050565b600061038b8261043c565b91506103968361043c565b9250827fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff038211156103cb576103ca610446565b5b828201905092915050565b60006103e18261043c565b91506103ec8361043c565b9250828210156103ff576103fe610446565b5b828203905092915050565b60006104158261041c565b9050919050565b600073ffffffffffffffffffffffffffffffffffffffff82169050919050565b6000819050919050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b61047e8161043c565b811461048957600080fd5b5056fea264697066735822122056e09a2f569730dd830a24d7a11c32df66c0c348c32a8ff359959afd56a0d37f64736f6c63430008000033";

export class Counter__factory extends ContractFactory {
  constructor(signer?: Signer) {
    super(_abi, _bytecode, signer);
  }

  deploy(
    _pokeMe: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): Promise<Counter> {
    return super.deploy(_pokeMe, overrides || {}) as Promise<Counter>;
  }
  getDeployTransaction(
    _pokeMe: string,
    overrides?: Overrides & { from?: string | Promise<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(_pokeMe, overrides || {});
  }
  attach(address: string): Counter {
    return super.attach(address) as Counter;
  }
  connect(signer: Signer): Counter__factory {
    return super.connect(signer) as Counter__factory;
  }
  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): CounterInterface {
    return new utils.Interface(_abi) as CounterInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): Counter {
    return new Contract(address, _abi, signerOrProvider) as Counter;
  }
}

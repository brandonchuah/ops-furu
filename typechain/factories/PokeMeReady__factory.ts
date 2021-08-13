/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import { Provider } from "@ethersproject/providers";
import type { PokeMeReady, PokeMeReadyInterface } from "../PokeMeReady";

const _abi = [
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

export class PokeMeReady__factory {
  static readonly abi = _abi;
  static createInterface(): PokeMeReadyInterface {
    return new utils.Interface(_abi) as PokeMeReadyInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): PokeMeReady {
    return new Contract(address, _abi, signerOrProvider) as PokeMeReady;
  }
}

/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  Contract,
  ContractFactory,
  ContractTransactionResponse,
  Interface,
} from "ethers";
import type { Signer, ContractDeployTransaction, ContractRunner } from "ethers";
import type { NonPayableOverrides } from "../../../common";
import type {
  MetaToken,
  MetaTokenInterface,
} from "../../../contracts/mint.sol/MetaToken";

const _abi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Approval",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
    ],
    name: "MetaTransactionExecuted",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "previousOwner",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "OwnershipTransferred",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        indexed: true,
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "value",
        type: "uint256",
      },
    ],
    name: "Transfer",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "owner",
        type: "address",
      },
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
    ],
    name: "allowance",
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
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "approve",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "account",
        type: "address",
      },
    ],
    name: "balanceOf",
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
    name: "decimals",
    outputs: [
      {
        internalType: "uint8",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "subtractedValue",
        type: "uint256",
      },
    ],
    name: "decreaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "user",
        type: "address",
      },
      {
        internalType: "bytes",
        name: "data",
        type: "bytes",
      },
      {
        internalType: "bytes",
        name: "signature",
        type: "bytes",
      },
    ],
    name: "executeMetaTransaction",
    outputs: [
      {
        internalType: "bytes",
        name: "",
        type: "bytes",
      },
    ],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "spender",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "addedValue",
        type: "uint256",
      },
    ],
    name: "increaseAllowance",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "nextNonce",
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
    name: "owner",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "renounceOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "symbol",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "totalSupply",
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
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transfer",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "transferFrom",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newOwner",
        type: "address",
      },
    ],
    name: "transferOwnership",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

const _bytecode =
  "0x60806040523480156200001157600080fd5b506040518060400160405280600981526020016826b2ba30aa37b5b2b760b91b815250604051806040016040528060038152602001624d544b60e81b815250816003908162000061919062000285565b50600462000070828262000285565b5050506200008d62000087620000c060201b60201c565b620000c4565b620000b533620000a06012600a62000466565b620000af90620f42406200047e565b62000116565b6001600655620004ae565b3390565b600580546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b6001600160a01b038216620001715760405162461bcd60e51b815260206004820152601f60248201527f45524332303a206d696e7420746f20746865207a65726f206164647265737300604482015260640160405180910390fd5b806002600082825462000185919062000498565b90915550506001600160a01b038216600081815260208181526040808320805486019055518481527fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef910160405180910390a35050565b505050565b634e487b7160e01b600052604160045260246000fd5b600181811c908216806200020c57607f821691505b6020821081036200022d57634e487b7160e01b600052602260045260246000fd5b50919050565b601f821115620001dc57600081815260208120601f850160051c810160208610156200025c5750805b601f850160051c820191505b818110156200027d5782815560010162000268565b505050505050565b81516001600160401b03811115620002a157620002a1620001e1565b620002b981620002b28454620001f7565b8462000233565b602080601f831160018114620002f15760008415620002d85750858301515b600019600386901b1c1916600185901b1785556200027d565b600085815260208120601f198616915b82811015620003225788860151825594840194600190910190840162000301565b5085821015620003415787850151600019600388901b60f8161c191681555b5050505050600190811b01905550565b634e487b7160e01b600052601160045260246000fd5b600181815b80851115620003a85781600019048211156200038c576200038c62000351565b808516156200039a57918102915b93841c93908002906200036c565b509250929050565b600082620003c15750600162000460565b81620003d05750600062000460565b8160018114620003e95760028114620003f45762000414565b600191505062000460565b60ff84111562000408576200040862000351565b50506001821b62000460565b5060208310610133831016604e8410600b841016171562000439575081810a62000460565b62000445838362000367565b80600019048211156200045c576200045c62000351565b0290505b92915050565b60006200047760ff841683620003b0565b9392505050565b808202811582820484141762000460576200046062000351565b8082018082111562000460576200046062000351565b610ecd80620004be6000396000f3fe6080604052600436106100f35760003560e01c80638da5cb5b1161008a578063d69c3d3011610059578063d69c3d3014610298578063d8ed1acc146102ae578063dd62ed3e146102c1578063f2fde38b146102e157600080fd5b80638da5cb5b1461021b57806395d89b4114610243578063a457c2d714610258578063a9059cbb1461027857600080fd5b8063313ce567116100c6578063313ce5671461019257806339509351146101ae57806370a08231146101ce578063715018a61461020457600080fd5b806306fdde03146100f8578063095ea7b31461012357806318160ddd1461015357806323b872dd14610172575b600080fd5b34801561010457600080fd5b5061010d610301565b60405161011a9190610b9a565b60405180910390f35b34801561012f57600080fd5b5061014361013e366004610bd0565b610393565b604051901515815260200161011a565b34801561015f57600080fd5b506002545b60405190815260200161011a565b34801561017e57600080fd5b5061014361018d366004610bfa565b6103ad565b34801561019e57600080fd5b506040516012815260200161011a565b3480156101ba57600080fd5b506101436101c9366004610bd0565b6103d1565b3480156101da57600080fd5b506101646101e9366004610c36565b6001600160a01b031660009081526020819052604090205490565b34801561021057600080fd5b506102196103f3565b005b34801561022757600080fd5b506005546040516001600160a01b03909116815260200161011a565b34801561024f57600080fd5b5061010d610407565b34801561026457600080fd5b50610143610273366004610bd0565b610416565b34801561028457600080fd5b50610143610293366004610bd0565b610496565b3480156102a457600080fd5b5061016460065481565b61010d6102bc366004610cf4565b6104a4565b3480156102cd57600080fd5b506101646102dc366004610d68565b610623565b3480156102ed57600080fd5b506102196102fc366004610c36565b61064e565b60606003805461031090610d9b565b80601f016020809104026020016040519081016040528092919081815260200182805461033c90610d9b565b80156103895780601f1061035e57610100808354040283529160200191610389565b820191906000526020600020905b81548152906001019060200180831161036c57829003601f168201915b5050505050905090565b6000336103a18185856106c7565b60019150505b92915050565b6000336103bb8582856107eb565b6103c6858585610865565b506001949350505050565b6000336103a18185856103e48383610623565b6103ee9190610deb565b6106c7565b6103fb610a09565b6104056000610a63565b565b60606004805461031090610d9b565b600033816104248286610623565b9050838110156104895760405162461bcd60e51b815260206004820152602560248201527f45524332303a2064656372656173656420616c6c6f77616e63652062656c6f77604482015264207a65726f60d81b60648201526084015b60405180910390fd5b6103c682868684036106c7565b6000336103a1818585610865565b606060006104da85856040516020016104be929190610dfe565b6040516020818303038152906040528051906020012084610ab5565b9050846001600160a01b0316816001600160a01b0316146105315760405162461bcd60e51b8152602060048201526011602482015270496e76616c6964207369676e617475726560781b6044820152606401610480565b600080866001600160a01b03168660405161054c9190610e36565b6000604051808303816000865af19150503d8060008114610589576040519150601f19603f3d011682016040523d82523d6000602084013e61058e565b606091505b5091509150816105e05760405162461bcd60e51b815260206004820152601760248201527f4d6574612d7472616e73616374696f6e206661696c65640000000000000000006044820152606401610480565b7fac470f3118096492e2f9f1d479269b22af43d8c9eba96e8de7d2fe8ebfed0eec8787604051610611929190610e52565b60405180910390a19695505050505050565b6001600160a01b03918216600090815260016020908152604080832093909416825291909152205490565b610656610a09565b6001600160a01b0381166106bb5760405162461bcd60e51b815260206004820152602660248201527f4f776e61626c653a206e6577206f776e657220697320746865207a65726f206160448201526564647265737360d01b6064820152608401610480565b6106c481610a63565b50565b6001600160a01b0383166107295760405162461bcd60e51b8152602060048201526024808201527f45524332303a20617070726f76652066726f6d20746865207a65726f206164646044820152637265737360e01b6064820152608401610480565b6001600160a01b03821661078a5760405162461bcd60e51b815260206004820152602260248201527f45524332303a20617070726f766520746f20746865207a65726f206164647265604482015261737360f01b6064820152608401610480565b6001600160a01b0383811660008181526001602090815260408083209487168084529482529182902085905590518481527f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925910160405180910390a3505050565b60006107f78484610623565b9050600019811461085f57818110156108525760405162461bcd60e51b815260206004820152601d60248201527f45524332303a20696e73756666696369656e7420616c6c6f77616e63650000006044820152606401610480565b61085f84848484036106c7565b50505050565b6001600160a01b0383166108c95760405162461bcd60e51b815260206004820152602560248201527f45524332303a207472616e736665722066726f6d20746865207a65726f206164604482015264647265737360d81b6064820152608401610480565b6001600160a01b03821661092b5760405162461bcd60e51b815260206004820152602360248201527f45524332303a207472616e7366657220746f20746865207a65726f206164647260448201526265737360e81b6064820152608401610480565b6001600160a01b038316600090815260208190526040902054818110156109a35760405162461bcd60e51b815260206004820152602660248201527f45524332303a207472616e7366657220616d6f756e7420657863656564732062604482015265616c616e636560d01b6064820152608401610480565b6001600160a01b03848116600081815260208181526040808320878703905593871680835291849020805487019055925185815290927fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef910160405180910390a361085f565b6005546001600160a01b031633146104055760405162461bcd60e51b815260206004820181905260248201527f4f776e61626c653a2063616c6c6572206973206e6f7420746865206f776e65726044820152606401610480565b600580546001600160a01b038381166001600160a01b0319831681179093556040519116919082907f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e090600090a35050565b6020810151604082015160608301516000929190831a601b811015610ae257610adf601b82610e7e565b90505b60408051600081526020810180835288905260ff831691810191909152606081018490526080810183905260019060a0016020604051602081039080840390855afa158015610b35573d6000803e3d6000fd5b5050604051601f190151979650505050505050565b60005b83811015610b65578181015183820152602001610b4d565b50506000910152565b60008151808452610b86816020860160208601610b4a565b601f01601f19169290920160200192915050565b602081526000610bad6020830184610b6e565b9392505050565b80356001600160a01b0381168114610bcb57600080fd5b919050565b60008060408385031215610be357600080fd5b610bec83610bb4565b946020939093013593505050565b600080600060608486031215610c0f57600080fd5b610c1884610bb4565b9250610c2660208501610bb4565b9150604084013590509250925092565b600060208284031215610c4857600080fd5b610bad82610bb4565b634e487b7160e01b600052604160045260246000fd5b600082601f830112610c7857600080fd5b813567ffffffffffffffff80821115610c9357610c93610c51565b604051601f8301601f19908116603f01168101908282118183101715610cbb57610cbb610c51565b81604052838152866020858801011115610cd457600080fd5b836020870160208301376000602085830101528094505050505092915050565b600080600060608486031215610d0957600080fd5b610d1284610bb4565b9250602084013567ffffffffffffffff80821115610d2f57600080fd5b610d3b87838801610c67565b93506040860135915080821115610d5157600080fd5b50610d5e86828701610c67565b9150509250925092565b60008060408385031215610d7b57600080fd5b610d8483610bb4565b9150610d9260208401610bb4565b90509250929050565b600181811c90821680610daf57607f821691505b602082108103610dcf57634e487b7160e01b600052602260045260246000fd5b50919050565b634e487b7160e01b600052601160045260246000fd5b808201808211156103a7576103a7610dd5565b6bffffffffffffffffffffffff198360601b16815260008251610e28816014850160208701610b4a565b919091016014019392505050565b60008251610e48818460208701610b4a565b9190910192915050565b6001600160a01b0383168152604060208201819052600090610e7690830184610b6e565b949350505050565b60ff81811683821601908111156103a7576103a7610dd556fea264697066735822122046a1ea1bf2cd05a6a3e227cec7cb2fa28556515ccb96a020476d92615f5b307964736f6c63430008120033";

type MetaTokenConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: MetaTokenConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class MetaToken__factory extends ContractFactory {
  constructor(...args: MetaTokenConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(overrides || {});
  }
  override deploy(overrides?: NonPayableOverrides & { from?: string }) {
    return super.deploy(overrides || {}) as Promise<
      MetaToken & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): MetaToken__factory {
    return super.connect(runner) as MetaToken__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): MetaTokenInterface {
    return new Interface(_abi) as MetaTokenInterface;
  }
  static connect(address: string, runner?: ContractRunner | null): MetaToken {
    return new Contract(address, _abi, runner) as unknown as MetaToken;
  }
}

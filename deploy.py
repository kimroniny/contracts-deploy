from compile_solidity_utils import deploy_n_transact
# from solc import link_code
import json, os

# Solidity source code
contract_address, abi = deploy_n_transact([
    './contracts/Charity.sol',
    './contracts/CharityBasicInfo.sol',
    './contracts/CharityCreator.sol',
    './contracts/CharityGetter.sol',
    './contracts/CharityInOut.sol'
])

with open('deploy_result/data.json', 'w') as outfile:
    data = {"abi": abi, "contract_address": contract_address}
    json.dump(data, outfile, indent=4, sort_keys=True)

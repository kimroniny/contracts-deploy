# from compile_solidity_utils import w3
import json
from compile_solidity_utils import w3

w3.eth.defaultAccount = w3.eth.accounts[0]
with open("deploy_result/data.json", 'r') as f:
    datastore = json.load(f)
abi = datastore["abi"]
contract_address = datastore["contract_address"]

# Create the contract instance with the newly-deployed address
charity = w3.eth.contract(
    address=contract_address, abi=abi,
)

admin = w3.geth.personal.newAccount('admin')
print("生成的地址: {}".format(admin))
addr_std = w3.toChecksumAddress(w3.toHex(int(admin, 16)))
# print(w3.toChecksumAddress(admin))
# print(w3.toHex(int(admin, 16)))
tx_hash = charity.functions.createAdmin(
    addr_std,
    'admin',
    '15684505142',
    '131127199710066693'
)
tx_hash = tx_hash.transact()
# # Wait for transaction to be mined...
w3.eth.waitForTransactionReceipt(tx_hash)
# print("交易的hash: {}".format(tx_hash))


admin = charity.functions.getAdminByAddr(addr_std).call()
print("获得的admin信息: {}".format(admin))
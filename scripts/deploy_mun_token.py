from scripts.helpful_scripts import get_account
from brownie import MUNToken
from scripts.deploy_token_sale import deploy_token_sale
from web3 import Web3


def main():
    tokenSale = deploy_token_sale()
    initial_supply = int(
        input('Please enter the amount of initial supply in BNB/ETH:'))
    account = get_account()
    munToken = MUNToken.deploy(
        Web3.toWei(initial_supply, 'ether'), tokenSale.address, {'from': account})
    munToken.tx.wait(1)
    print('Munzi Token Deployed.')

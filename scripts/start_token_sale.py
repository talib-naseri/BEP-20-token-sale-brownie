from scripts.helpful_scripts import get_account
from brownie import TokenSale, MUNToken
from web3 import Web3


def main():
    if(len(TokenSale) == 0):
        return print('No contracts deployed.')
    tokenSale = TokenSale[-1]
    token = MUNToken[-1]
    rate = int(input('Enter rate per EHT/BNB: '))
    hard_cap = int(input('Enter max sale value in ETH/BNB: '))
    max_contribution = int(input('Enter everyones max contribution: '))

    account = get_account()

    tx = tokenSale.startSales(
        token.address,
        Web3.toWei(rate, 'ether'),
        Web3.toWei(hard_cap, 'ether'),
        Web3.toWei(max_contribution, 'ether'),
        0,
        0,
        {'from': account}
    )
    tx.wait(1)

    print('Token Sale Started.')

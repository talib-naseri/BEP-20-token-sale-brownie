from scripts.helpful_scripts import get_account, SALES_STATUS_ENUM
from brownie import TokenSale
from web3 import Web3


def get_token_sale_info():
    if(len(TokenSale) == 0):
        return print('No contracts deployed.')
    tokenSale = TokenSale[-1]
    owner = tokenSale.owner()
    rate = tokenSale.rate()
    hard_cap = tokenSale.hardCap()
    max_contribution = tokenSale.maxContribution()
    sales_status = tokenSale.salesStatus()

    print('owner: ', owner)
    print('Rate: ', Web3.fromWei(rate, 'ether'))
    print('Hard Cap: ', Web3.fromWei(hard_cap, 'ether'))
    print('Max Contribution: ', Web3.fromWei(max_contribution, 'ether'))
    print('Sales Status: ', SALES_STATUS_ENUM[sales_status])

    return (owner, rate, hard_cap, max_contribution, sales_status)


def main():
    get_token_sale_info()

from scripts.helpful_scripts import get_account
from brownie import TokenSale


def deploy_token_sale():
    account = get_account()
    tokenSale = TokenSale.deploy({'from': account})
    tokenSale.tx.wait(1)
    print('Token Sale Contract deployed.')
    return tokenSale


def main():
    deploy_token_sale()

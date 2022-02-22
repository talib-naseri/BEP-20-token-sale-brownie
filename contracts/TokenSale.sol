// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenSale {
    enum SalesStatus {
        Created,
        Started,
        Ended
    }

    address public tokenAddress;
    uint256 public rate;
    uint256 public hardCap;
    uint256 public maxContribution;
    uint256 public startTime;
    uint256 public endTime;
    address public owner;
    SalesStatus public salesStatus;

    constructor() {
        owner = msg.sender;
        salesStatus = SalesStatus.Created;
    }

    // errors
    error MaxContributionExceeded(
        uint256 contribution,
        uint256 maxContribution
    );
    error NotEnoughBalanceToRepay(uint256 currenBanace);
    error SalesNotStarted();
    error SalesEnded();
    error NotOwner();
    error RequestedInAWrongTime(SalesStatus status);

    // Modifiers
    modifier checkMaxContribution() {
        if (maxContribution != 0 && maxContribution < msg.value)
            revert MaxContributionExceeded(msg.value, maxContribution);
        _;
    }

    modifier enoughBalance() {
        if (IERC20(tokenAddress).balanceOf(address(this)) < msg.value * rate)
            revert NotEnoughBalanceToRepay(
                IERC20(tokenAddress).balanceOf(address(this))
            );
        _;
    }

    modifier salesRunning() {
        if (block.timestamp < startTime) revert SalesNotStarted();
        if (block.timestamp > endTime && endTime > 0) revert SalesEnded();
        _;
    }

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    modifier inStatus(SalesStatus status) {
        if (status != salesStatus) revert RequestedInAWrongTime(salesStatus);
        _;
    }

    // Functions
    function buyToken()
        external
        payable
        checkMaxContribution
        enoughBalance
        salesRunning
        inStatus(SalesStatus.Started)
    {
        IERC20(tokenAddress).transfer(msg.sender, msg.value * rate);
    }

    function startSales(
        address _tokenAddress,
        uint256 _rate,
        uint256 _hardCap,
        uint256 _maxContribution,
        uint256 _startTime,
        uint256 _endTime
    ) external onlyOwner inStatus(SalesStatus.Created) {
        require(_rate > 0, "Rate can't be Zero");
        require(_tokenAddress != address(0), "Address Cannot be Zero");
        require(
            IERC20(_tokenAddress).balanceOf(address(this)) > 0,
            "Cannot Start With Zero Balance"
        );

        tokenAddress = _tokenAddress;
        rate = _rate;
        hardCap = _hardCap;
        maxContribution = _maxContribution;
    }

    function endSales() external onlyOwner inStatus(SalesStatus.Started) {
        salesStatus = SalesStatus.Ended;
        payable(owner).transfer(address(this).balance);
    }
}

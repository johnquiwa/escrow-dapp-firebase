pragma solidity 0.4.18;

contract Escrow {

    // Stage Management
    enum Stages {
        Funding,
        SetStrings,
        ApproveOrReject,
        PayoutAndReveal
    }
    
    Stages public stage = Stages.Funding;
    
    modifier isProvider() {
        assert(msg.sender == agreement.providerAddress);
        _;
    }
    
    modifier isClient() {
        assert(msg.sender == agreement.clientAddress);
        _;
    }

    modifier atStage(Stages _stage) {
        assert(stage == _stage);
        _;
    }
    
    modifier transitionNext() {
        _;
        nextStage();
    }

    // Agreement
    struct Agreement {
        uint256 agreementPrice;
        address clientAddress;
        address providerAddress;
        bytes32 previewMessage;
        bytes32 finalMessage;
        bool approved;
        mapping (address => uint256) funders;
    }
    
    Agreement agreement;

    // Contract
    function Escrow(uint256 _agreementPrice, address _clientAddress) public {
        agreement.agreementPrice = _agreementPrice;
        agreement.clientAddress = _clientAddress;
        agreement.providerAddress = msg.sender;
        agreement.approved = false;
    }
    
    // Funding
    function contributeFunding() public payable {
        agreement.funders[msg.sender] = msg.value;
        assert(this.balance >= agreement.agreementPrice);
        nextStage();
    }

    // Provider
    // Make sure to set these uint256 _agreementPrice, address _clientAddress

    function setPreviewMessage(bytes32 _previewMessage) public atStage(Stages.SetStrings) isProvider {
        agreement.previewMessage = _previewMessage;
    }
    
    function setFinalMessage(bytes32 _finalMessage) public atStage(Stages.SetStrings) isProvider {
        assert(agreement.previewMessage.length > 0);
        agreement.finalMessage = _finalMessage;
        nextStage();
    }
    
    // Client
    function getPreviewMessage() public view atStage(Stages.ApproveOrReject) isClient returns (bytes32) {
        return agreement.previewMessage;
    }
    
    function approvePreview() atStage(Stages.ApproveOrReject) public isClient {
        agreement.approved = true;
        agreement.providerAddress.transfer(this.balance);
        nextStage();
    }
    
    function getFinalMessage() public view atStage(Stages.PayoutAndReveal) isClient returns (bytes32) {
        return agreement.finalMessage;
    }
    
    function getFundingAmount() public view returns(uint) {
        return this.balance;
    }

    // Destroy Contract and send remaining balance to provider
    function kill() public isProvider {
        selfdestruct(agreement.providerAddress);
    }

    // Internal
    function nextStage() internal {
        stage = Stages(uint(stage) + 1);
    }
}
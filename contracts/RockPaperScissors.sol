// SPDX-License-Identifier: UNLICENSED
pragma solidity >= 0.8.0;

contract RockPaperScissors {
    uint constant public MIN_BET = 1 ether;

    address payable private player1;
    address payable private player2;


    enum Outcomes {None, Player1, Player2, Draw}
    string private movePlayer1;
    string private movePlayer2;
    
    bool private hasPlayer1Moved;
    bool private hasPlayer2Moved;

    uint public betValue;

    mapping(string => mapping(string => Outcomes)) private states;

    constructor() {
        states['R']['R'] = Outcomes.Draw;
        states['R']['P'] = Outcomes.Player2;
        states['R']['S'] = Outcomes.Player1;
        states['P']['R'] = Outcomes.Player1;
        states['P']['P'] = Outcomes.Draw;
        states['P']['S'] = Outcomes.Player2;
        states['S']['R'] = Outcomes.Player2;
        states['S']['P'] = Outcomes.Player1;
        states['S']['S'] = Outcomes.Draw;

        betValue = MIN_BET;
        player1 = payable(address(0));
        player2 = payable(address(0));
    }


    // modifiers
    modifier isJoinable() {
        require(msg.value >= MIN_BET, "BET value min is 1 ether");
        require(player1 == payable(address(0)) || player2 == payable(address(0)) || player1 == payable(msg.sender) || player2 == payable(msg.sender), 
            "The room is full."
        );
        require((player1 != payable(address(0)) && msg.value >= betValue) || (player1 == payable(address(0))),    //Player1 can choose the betValue, Player2 has to match. 
            "You must pay the betValue to play the game."
        );
        _;
    }

    modifier isPlayer() {
        require(payable(msg.sender) == player1 || payable(msg.sender) == player2,
            "You are not playing this game."
        );
        _;
    }

    modifier isValidChoice(string memory _playerChoice) {
        require(keccak256(bytes(_playerChoice)) == keccak256(bytes('R')) ||
                keccak256(bytes(_playerChoice)) == keccak256(bytes('P')) ||
                keccak256(bytes(_playerChoice)) == keccak256(bytes('S')) ,
                "Your choice is not valid, it should be one of R, P and S."
        );
        _;
    }

    modifier playersMadeChoice() {
        require(hasPlayer1Moved && hasPlayer2Moved,
                "The player(s) have not made their choice yet."
        );
        _;
    }

    // functions
    function join() external payable 
        isJoinable() // To join the game, there must be a free space
    {
        if (player1 == payable(address(0))) {
            player1 = payable(msg.sender);
            betValue = msg.value;   //Player1 determines the betValue
        } else if (player1 != payable(msg.sender)) {
            player2 = payable(msg.sender);
            if (betValue < msg.value) {     // return change to Player2
                uint odd = msg.value - betValue;
                player2.transfer(odd);
            }
        } else {
            player1.transfer(msg.value);    // payback if already joined
        }
    }

    function makeChoice(string calldata _playerChoice) external 
        isPlayer()                      // Only the players can make the choice
        isValidChoice(_playerChoice)    // The choices should be valid 
    {
        if (payable(msg.sender) == player1 && !hasPlayer1Moved) {
            movePlayer1 = _playerChoice;
            hasPlayer1Moved = true;
        } else if (payable(msg.sender) == player2 && !hasPlayer2Moved) {
            movePlayer2 = _playerChoice;
            hasPlayer2Moved = true;
        }
    }

    function whoAmI() public view returns (uint) {
        if (payable(msg.sender) == player1) {
            return 1;
        } else if (payable(msg.sender) == player2) {
            return 2;
        } else {
            return 0;
        }
    }
    
    function disclose() external 
        isPlayer()          // Only players can disclose the game result
        playersMadeChoice() // Can disclose the result when choices are made
    {
        // Disclose the game result
        Outcomes result = states[movePlayer1][movePlayer2];
        if (result == Outcomes.Draw) {
            player1.transfer(betValue); 
            player2.transfer(betValue);
        } else if (result == Outcomes.Player1) {
            player1.transfer(address(this).balance);
        } else if (result == Outcomes.Player2) {
            player2.transfer(address(this).balance);
        }
        
        // Reset the game
        player1 = payable(address(0));
        player2 = payable(address(0));

        movePlayer1 = "";
        movePlayer2 = "";
        
        hasPlayer1Moved = false;
        hasPlayer2Moved = false;
        
        betValue = 1 ether;
    }
}

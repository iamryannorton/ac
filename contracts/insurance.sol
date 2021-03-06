pragma solidity ^0.4.0;



// To be added


contract insurance {
  address shipee_address;
  address shipper_address;
  uint shipping_cost;
  uint insurance_cost;
  enum State {Created, Locked, Inactive}
  State public state;
  bool compromise;

  constructor(uint _shipping_cost, uint _insurance_cost) public {
      shipee = msg.sender;
      shipping_cost = _shipping_cost;
      insurance_cost = _insurance_cost;
  }

  modifier inState(State _state){
  	require(
  		state == _state.
  		"Invalid state."
  		);
  		_;
  }

  //events created to indicate status of shipment
  event Failed();
  event TransactionStarted();
  event ItemReceived();

  //shipment failure, funds are insured and sent to shippee
  function fail() 
  	inState(State.Created)
  	{
  		emit Failed();
  		state = State.Inactive;
  		shippee_address.tranfer(address(this).balance); //shippee receives insurance when shipment is failed
  	}

  function confirmTransaction()
  	inState(State.Created)
  	payable
  	{
  		emit TransactionStarted();
  		state = State.Locked;

  		shipper_address = msg.sender; //Shipper pays insurance to SC escrow once transaction is confirmed

  	}

  function confirmReceived()
  	onlyShipper //Confirm item etc, 
  	inState(State.Locked)
  	{
  		emit ItemReceived();
  		//NOTES:
  		//Need to add Oracle that updates this
  		state = State.Inactive;

  		shipper_address.transfer(address(this).balance); //shipper receives insurance return once item is received

  	}

  // Old functions 
  function shipping_current() constant public returns (uint) {return shipping_cost; }

  function insurance_current() constant public returns (uint) {return insurance_cost; }

  function setShipping(uint new_shipping_cost) public { shipping_cost = new_shipping_cost; }

  function setInsurance(uint new_insurance_cost) public { insurance_cost = new_insurance_cost; }

  function() payable public { /// lets people send money to this address, fall back
    Received(msg.sender, msg.value);
  }
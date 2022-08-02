# Project Title
Supply Chain Smart Contract to track the Product 

# Four Types of DATA

Asset - > The product to be brought by the consumer.

Participants -> All supply chain participants
		Manufacturers, suppliers, shippers, consumers.


Ownership Structure -> which Participants currently owns the product
Track the product


Payment Token -> Particiants pays each other as ownership changes


# FUNCTIONS

Initialize tokens -> Establish initial pool of payments token

Transfer Token -> Move tokens between accounts as payment

Authorize token Payments 

Allow token transfers on behalf on another 


Add & Update Participants

Move products along the supply chain  -> Transfer product ownership

Add and update products

Tracks an asset
	where a product is today 
	find poduct provenance(Ownership)


# Payment Token Smart Contracts Data Items

> Total Supply -> Total number of tokens in circulation

> name -> Descriptive token name 

> decimals -> Number of decimal to use when displaying  token amount

> Symbol -> Short identifier

>balances -> Current balance of each participating account,
	mapped to the account address

>allowed -> Number of tokens authorized to transfer between accounts, mapped to sender's address

# Payment Token Smart Contracts Function
> totalSupply()
	Returns current total number of tokens

> BalanceoF()-:
	Returns current balance of specific account

>allowance-:
	Returns remaining number of tokens allowed to be transferred from one specific account to another speific account 

>transferFrom()-:
	Transfers tokens from one specific account to another specific account

>approve()-:
	Maximum allowed tokens that can be transferred from one specific account to another specific account 


# Supply Chain Smart Contract

> Data and functionality to manage products,participants, ownership transfer data


# Supply Chain Smart Contract Data Structure

>Product Structure -:
	Eg model number, part number, cost, etc
	Data that defines a unique product
	mapping to get Product Structure

>Participant Structure-:
	Data that defines a unique participant
	EX username,password,Ethereum address, etc. 
	
Ownership Structure
> Data that records product ownership transfer information
	EX Product ID, Owner ID, Transaction time , etc
	



# Supply chain Smart contract Data Variables 
> Product_id-:
	unique product Id, mapped to product structure

>Participant_id-:
	Unique participant ID, mapped to participant structure

>Owner_id-:
	Unique owner, mapped to registration structure


# Supply Chain Smart Contract Functions 

> addParticipants()
	Create new participant

>getParticipant()
	Fetch information about a participant

> addProduct()
	create new product

> getProduct()
	Fetch information about a particular product.

>newOwner()
	Transfer of Ownership
    
>getProvenance()
	Record of ownership

>getOwnership()
	Owner of a product in a specific point in time 

> authenticateParticipant()
	Confirms participants is allowed to access certain data

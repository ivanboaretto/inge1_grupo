!classDefinition: #CartTest category: 'TusLibros'!
TestCase subclass: #CartTest
	instanceVariableNames: 'testObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test01NewCartsAreCreatedEmpty

	self assert: testObjectsFactory createCart isEmpty! !

!CartTest methodsFor: 'tests' stamp: 'totot 11/6/2023 21:29:19'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [ cart add: testObjectsFactory itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:10'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self deny: cart isEmpty ! !

!CartTest methodsFor: 'tests' stamp: 'totot 11/6/2023 21:29:30'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 0 of: testObjectsFactory itemSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'totot 11/6/2023 21:29:37'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self 
		should: [cart add: 2 of: testObjectsFactory itemNotSellByTheStore  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test06CartRemembersAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: testObjectsFactory itemSellByTheStore.
	self assert: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	self deny: (cart includes: testObjectsFactory itemSellByTheStore)! !

!CartTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:11'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := testObjectsFactory createCart.
	
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	self assert: (cart occurrencesOf: testObjectsFactory itemSellByTheStore) = 2! !


!CartTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 18:09'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.! !


!classDefinition: #CashierTest category: 'TusLibros'!
TestCase subclass: #CashierTest
	instanceVariableNames: 'testObjectsFactory debitBehavior'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:50'!
test01CanNotCheckoutAnEmptyCart

	| salesBook |
	
	salesBook := OrderedCollection new.
	self 
		should: [ Cashier 
			toCheckout: testObjectsFactory createCart 
			charging: testObjectsFactory notExpiredCreditCard 
			throught: self
			on: testObjectsFactory today
			registeringOn:  salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cartCanNotBeEmptyErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test02CalculatedTotalIsCorrect

	| cart cashier |
	
	cart := testObjectsFactory createCart.
	cart add: 2 of: testObjectsFactory itemSellByTheStore.
	
	cashier :=  Cashier
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard 
		throught: self
		on: testObjectsFactory today 
		registeringOn: OrderedCollection new.
		
	self assert: cashier checkOut = (testObjectsFactory itemSellByTheStorePrice * 2)! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:51'!
test03CanNotCheckoutWithAnExpiredCreditCart

	| cart salesBook |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
	
	self
		should: [ Cashier 
				toCheckout: cart 
				charging: testObjectsFactory expiredCreditCard 
				throught: self
				on: testObjectsFactory today
				registeringOn: salesBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | 
			self assert: anError messageText = Cashier canNotChargeAnExpiredCreditCardErrorMessage.
			self assert: salesBook isEmpty ]! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:04'!
test04CheckoutRegistersASale

	| cart cashier salesBook total |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: testObjectsFactory notExpiredCreditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	total := cashier checkOut.
					
	self assert: salesBook size = 1.
	self assert: salesBook first total = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 19:00'!
test05CashierChargesCreditCardUsingMerchantProcessor

	| cart cashier salesBook total creditCard debitedAmout debitedCreditCard  |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	debitBehavior := [ :anAmount :aCreditCard | 
		debitedAmout := anAmount.
		debitedCreditCard := aCreditCard ].
	total := cashier checkOut.
					
	self assert: debitedCreditCard = creditCard.
	self assert: debitedAmout = total.! !

!CashierTest methodsFor: 'tests' stamp: 'HernanWilkinson 6/17/2013 18:59'!
test06CashierDoesNotSaleWhenTheCreditCardHasNoCredit

	| cart cashier salesBook creditCard |

	cart := testObjectsFactory createCart.
	cart add: testObjectsFactory itemSellByTheStore.
	creditCard := testObjectsFactory notExpiredCreditCard.
	salesBook := OrderedCollection new.
 	debitBehavior := [ :anAmount :aCreditCard | self error: Cashier creditCardHasNoCreditErrorMessage].
	
	cashier:= Cashier 
		toCheckout: cart 
		charging: creditCard
		throught: self
		on: testObjectsFactory today
		registeringOn: salesBook.
		
	self 
		should: [cashier checkOut ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier creditCardHasNoCreditErrorMessage.
			self assert: salesBook isEmpty ]! !


!CashierTest methodsFor: 'setup' stamp: 'HernanWilkinson 6/17/2013 19:03'!
setUp 

	testObjectsFactory := StoreTestObjectsFactory new.
	debitBehavior := [ :anAmount :aCreditCard | ]! !


!CashierTest methodsFor: 'merchant processor protocol' stamp: 'HernanWilkinson 6/17/2013 19:02'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!classDefinition: #StoreSystemTest category: 'TusLibros'!
TestCase subclass: #StoreSystemTest
	instanceVariableNames: 'authenticationProcedure storeSystem idGenerator storeTestObjectsFactory debitBehavior currentDateAndTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 02:21:56'!
test01CreateCartForUnregisteredUser
	
	authenticationProcedure := [self error: 'Invalid username'].
	
	self 
		should: [storeSystem createCartForUserIdentifiedBy: 'Pedro' withPassword:'pass']
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = 'Invalid username'.]! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 02:19:37'!
test02CreateCartWhenUserProvidesWrongPassword
	
	authenticationProcedure := [self error: 'Wrong password'].
	
	self 
		should: [storeSystem createCartForUserIdentifiedBy:'Pedro' withPassword:'pass'. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = 'Wrong password'.]! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 03:28:44'!
test03CreateOnlyOneCart
	
	| cartId cartItems |
	authenticationProcedure:= [].
	
	cartId:= storeSystem createCartForUserIdentifiedBy:'Pedro' withPassword:'pass'. 
	
	cartItems:= storeSystem itemsOfCartIdentifiedBy: cartId.
	
	self assert: cartItems isEmpty.
	^cartId! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 03:28:44'!
test04CreateMoreThanOneCart
	
	|  cartId cartItems |
	
	self test03CreateOnlyOneCart.
	
	cartId:= storeSystem createCartForUserIdentifiedBy:'Juan' withPassword:'pass2'. 
	
	cartItems:= storeSystem itemsOfCartIdentifiedBy: cartId.
	self assert: cartId equals: idGenerator lastAssignedId.
	self assert: cartItems isEmpty.! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 02:16:46'!
test05CanNotAddItemToUnregisteredCart
	
	self 
		should: [storeSystem add: 1 of: storeTestObjectsFactory itemNotSellByTheStore toCartIdentifiedBy: 200]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText ='invalid cartId'].
	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 03:28:44'!
test06CanNotAddInvalidItemsToCart
	
	|  cartId cartItems |
	
	cartId:=self test03CreateOnlyOneCart.
	
	self 
		should: [storeSystem add: 1 of: storeTestObjectsFactory  itemNotSellByTheStore toCartIdentifiedBy: cartId. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart invalidItemErrorMessage .
			cartItems:= storeSystem itemsOfCartIdentifiedBy: cartId.
			self assert: cartId equals: idGenerator lastAssignedId.
			self assert: cartItems isEmpty.].
	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 03:38:00'!
test08CanListItemsAddedToCart
	
	|  cartId cartItems |
	
	cartId:=self test03CreateOnlyOneCart.
	storeSystem add: 2 of: storeTestObjectsFactory  itemSellByTheStore toCartIdentifiedBy: cartId.
	storeSystem add: 2 of: storeTestObjectsFactory  anotherItemSellByTheStore toCartIdentifiedBy: cartId.
	
	cartItems:= storeSystem itemsOfCartIdentifiedBy: cartId.
	self 
		assert: cartItems contents
		equals:
			(Dictionary new 
				at: storeTestObjectsFactory itemSellByTheStore put: 2; 
				at: storeTestObjectsFactory anotherItemSellByTheStore put: 2;
				yourself).
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 03:28:44'!
test08CantListItemsOfUnregisteredCart
	
	self 
		should: [storeSystem itemsOfCartIdentifiedBy: 123] 
		raise: Error - MessageNotUnderstood 
		withMessageText: 'invalid cartId'! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 02:04:51'!
test09CanNotCheckoutUnregisteredCart
	
	self 
		should: [storeSystem checkoutCartIdentifiedBy: 200 payingWith: storeTestObjectsFactory notExpiredCreditCard . ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText ='invalid cartId'].
	
	
	

	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 02:38:05'!
test10CanNotCheckoutAllreadyCheckoutCart

	| cartId |
	
	cartId := self test03CreateOnlyOneCart.
	storeSystem add: 1 of: storeTestObjectsFactory itemSellByTheStore toCartIdentifiedBy: cartId.
	storeSystem checkoutCartIdentifiedBy: cartId payingWith: storeTestObjectsFactory notExpiredCreditCard.
	
	self
		should: [storeSystem checkoutCartIdentifiedBy: cartId payingWith: storeTestObjectsFactory notExpiredCreditCard]
		raise: Error - MessageNotUnderstood
		withMessageText: 'invalid cartId'
	
	
	
	
	

	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 02:38:05'!
test10CheckoutCart

	| cartId transactionId |
	
	cartId := self test03CreateOnlyOneCart.
	storeSystem add: 1 of: storeTestObjectsFactory itemSellByTheStore toCartIdentifiedBy: cartId.
	
	transactionId := storeSystem checkoutCartIdentifiedBy: cartId payingWith: storeTestObjectsFactory notExpiredCreditCard.
	
	self assert: transactionId equals: idGenerator lastAssignedId
	
	
	
	

	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 02:29:33'!
test12CanNotListPurchasesOfUnregisteredUser
	
	authenticationProcedure := [self error: 'Invalid username'].

	self 
		should: [storeSystem purchasesOfUserIdentifiedBy: 123 withPassword: 'pass']
		raise: Error - MessageNotUnderstood
		withMessageText: 'Invalid username'
	
	

	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 02:29:33'!
test13CanNotListPurchasesWhenUserProvidesWrongPassword

	authenticationProcedure := [self error: 'Wrong password'].
	
	self 
		should: [storeSystem purchasesOfUserIdentifiedBy: 123 withPassword: 'pass']
		raise: Error - MessageNotUnderstood
		withMessageText: 'Wrong password'
	
	

	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 02:29:33'!
test14ListPurchasesWhenNoneRegisteredForThatUser

	|purchases|

	purchases := storeSystem purchasesOfUserIdentifiedBy: 123 withPassword: 'pass'.
	
	self assert: purchases isEmpty
	

	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 03:27:57'!
test15ListPurchasesWhenOnlyOneRegisteredForThatUser

	|purchases|
	
	self test10CheckoutCart.

	purchases := storeSystem purchasesOfUserIdentifiedBy: 'Pedro' withPassword: 'pass'.
	
	self 
		assert: purchases size equals: 1;
		assert: purchases asOrderedCollection first total equals: 10;
		assert: purchases asOrderedCollection first items size equals: 1;
		assert: purchases asOrderedCollection first items includes: storeTestObjectsFactory itemSellByTheStore! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 03:39:44'!
test16ListPurchasesWhenMoreThanOneRegisteredForThatUser

	|purchases|
	
	self test10CheckoutCart.
	self test10CheckoutCart.

	purchases := storeSystem purchasesOfUserIdentifiedBy: 'Pedro' withPassword: 'pass'.
	
	self 
		assert: purchases size equals: 2;
		assert: purchases asOrderedCollection first total equals: 10;
		assert: purchases asOrderedCollection first items size equals: 1;
		assert: purchases asOrderedCollection first items includes: storeTestObjectsFactory itemSellByTheStore;
		assert: purchases asOrderedCollection second total equals: 10;
		assert: purchases asOrderedCollection second items size equals: 1;
		assert: purchases asOrderedCollection second items includes: storeTestObjectsFactory itemSellByTheStore! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 03:46:26'!
test17CartExpiresAfterHalfAnHourWithoutInteractingWithIt
	
	|cartId|
	
	cartId := self test03CreateOnlyOneCart.
	
	self assert: (storeSystem itemsOfCartIdentifiedBy: cartId) isEmpty.
		
	self advanceTimeHalfHour.
	
	self 
		should: [storeSystem itemsOfCartIdentifiedBy: cartId]
		raise: Error - MessageNotUnderstood
		withMessageText: 'invalid cartId'
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'IB 11/9/2023 05:04:32'!
test18CartDoesNotExpiresIfItIsInteractedWith
	
	|cartId|
	
	cartId := self test03CreateOnlyOneCart.
		
	self advanceTimeFifteenMinutes.
	self assert: (storeSystem itemsOfCartIdentifiedBy: cartId) isEmpty.
	
	self advanceTimeFifteenMinutes.
	
	self assert: (storeSystem itemsOfCartIdentifiedBy: cartId) isEmpty.
	! !


!StoreSystemTest methodsFor: 'support - stub' stamp: 'IB 11/9/2023 04:21:10'!
advanceTimeFifteenMinutes
	
	currentDateAndTime := currentDateAndTime + (Duration minutes: 15)! !

!StoreSystemTest methodsFor: 'support - stub' stamp: 'IB 11/9/2023 04:21:32'!
advanceTimeHalfHour
	
	2 timesRepeat: [self advanceTimeFifteenMinutes]! !

!StoreSystemTest methodsFor: 'support - stub' stamp: 'IB 11/9/2023 01:46:35'!
authenticateUser: anUserId withPassword: aPassword

	authenticationProcedure value
	! !

!StoreSystemTest methodsFor: 'support - stub' stamp: 'IB 11/9/2023 04:38:54'!
currentDate
	
	^self currentDateAndTime date! !

!StoreSystemTest methodsFor: 'support - stub' stamp: 'IB 11/9/2023 04:38:47'!
currentDateAndTime
	
	^currentDateAndTime! !

!StoreSystemTest methodsFor: 'support - stub' stamp: 'IB 11/9/2023 01:47:11'!
debit: anAmount from: aCreditCard 

	^debitBehavior value: anAmount value: aCreditCard ! !


!StoreSystemTest methodsFor: 'running' stamp: 'IB 11/9/2023 04:16:58'!
setUp

	currentDateAndTime := DateAndTime year: 2023 month: 11 day: 9 hour: 12 minute: 0 second: 0.
	storeTestObjectsFactory := StoreTestObjectsFactory new.
	idGenerator := IdGenerator new.
	debitBehavior := [:amount :card |].
	storeSystem := 
		StoreSystem 
			authenticatingUsersWith: self 
			generatingIdsUsing: idGenerator  
			withCatalog: storeTestObjectsFactory defaultCatalog 
			chargingCardsThrought: self using: self
	! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items owner'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'accessing' stamp: 'IB 11/9/2023 03:22:10'!
items
	
	^items copy! !

!Cart methodsFor: 'accessing' stamp: 'IB 11/9/2023 03:05:04'!
ownerId

	^owner! !

!Cart methodsFor: 'accessing' stamp: 'IB 11/9/2023 03:16:53'!
withItemsDo: aOneArgBlock

	items do: aOneArgBlock! !


!Cart methodsFor: 'assertions' stamp: 'totot 11/6/2023 20:56:22'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self class invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'totot 11/6/2023 20:56:35'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self class invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'IB 11/9/2023 03:35:07'!
initializeOwnedByUserIdentifiedBy: anUserId acceptingItemsOf: aCatalog

	owner := anUserId.
	catalog := aCatalog.
	items := Bag new! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 19:09'!
total

	^ items sum: [ :anItem | catalog at: anItem ]! !


!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:44'!
add: anItem

	^ self add: 1 of: anItem ! !

!Cart methodsFor: 'adding' stamp: 'HernanWilkinson 6/17/2013 17:51'!
add: aQuantity of: anItem

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	1 to: aQuantity do: [ :aNumber | items add: anItem ]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'IB 11/9/2023 03:32:23'!
acceptingItemsOf: aCatalog

	^self ownedByUserIdentifiedBy: 0 acceptingItemsOf: aCatalog
! !

!Cart class methodsFor: 'instance creation' stamp: 'IB 11/9/2023 03:03:28'!
ownedByUserIdentifiedBy: anUserId acceptingItemsOf: aCatalog

	^self new initializeOwnedByUserIdentifiedBy: anUserId acceptingItemsOf: aCatalog ! !


!Cart class methodsFor: 'error messages' stamp: 'totot 11/6/2023 20:56:16'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart class methodsFor: 'error messages' stamp: 'totot 11/6/2023 20:56:32'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart salesBook merchantProcessor creditCard total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:08'!
calculateTotal

	total := cart total.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'IB 11/9/2023 03:25:18'!
createSale

	^ Sale of: cart items for: total
! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
debitTotal

	merchantProcessor debit: total from: creditCard.
	! !

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:06'!
registerSale

	salesBook add: self createSale! !


!Cashier methodsFor: 'checkout' stamp: 'HernanWilkinson 6/17/2013 19:06'!
checkOut

	self calculateTotal.
	self debitTotal.
	self registerSale.

	^ total! !


!Cashier methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:53'!
initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook
	
	cart := aCart.
	creditCard := aCreditCard.
	merchantProcessor := aMerchantProcessor.
	salesBook := aSalesBook! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:22'!
assertIsNotEmpty: aCart 
	
	aCart isEmpty ifTrue: [self error: self cartCanNotBeEmptyErrorMessage ]! !

!Cashier class methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 18:23'!
assertIsNotExpired: aCreditCard on: aDate
	
	(aCreditCard isExpiredOn: aDate) ifTrue: [ self error: self canNotChargeAnExpiredCreditCardErrorMessage ]! !


!Cashier class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:51'!
toCheckout: aCart charging: aCreditCard throught: aMerchantProcessor on: aDate registeringOn: aSalesBook
	
	self assertIsNotEmpty: aCart.
	self assertIsNotExpired: aCreditCard on: aDate.
	
	^self new initializeToCheckout: aCart charging: aCreditCard throught: aMerchantProcessor registeringOn: aSalesBook! !


!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 18:21'!
canNotChargeAnExpiredCreditCardErrorMessage
	
	^'Can not charge an expired credit card'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:56'!
cartCanNotBeEmptyErrorMessage
	
	^'Can not check out an empty cart'! !

!Cashier class methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 19:02'!
creditCardHasNoCreditErrorMessage
	
	^'Credit card has no credit'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'expiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 18:39'!
isExpiredOn: aDate 
	
	^expiration start < (Month month: aDate monthIndex year: aDate yearNumber) start ! !


!CreditCard methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:38'!
initializeExpiringOn: aMonth 
	
	expiration := aMonth ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:38'!
expiringOn: aMonth 
	
	^self new initializeExpiringOn: aMonth! !


!classDefinition: #IdGenerator category: 'TusLibros'!
Object subclass: #IdGenerator
	instanceVariableNames: 'nextId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!IdGenerator methodsFor: 'initialization' stamp: 'IB 11/9/2023 05:06:43'!
initialize

	nextId := 1! !


!IdGenerator methodsFor: 'queries' stamp: 'IB 11/9/2023 01:49:20'!
lastAssignedId
	^nextId -1.! !

!IdGenerator methodsFor: 'queries' stamp: 'totot 11/6/2023 20:49:59'!
nextId
	nextId:= nextId+1.
	^nextId-1.! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total relatedItems'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'IB 11/9/2023 03:23:17'!
initializeOf: itemsRelatedToTheSale for: aTotal 

	relatedItems := itemsRelatedToTheSale.
	total := aTotal! !


!Sale methodsFor: 'accessing' stamp: 'IB 11/9/2023 03:23:44'!
items
	
	^relatedItems copy! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'IB 11/9/2023 03:22:46'!
of: itemsRelatedToTheSale for: aTotal

	^self new initializeOf: itemsRelatedToTheSale for: aTotal ! !


!classDefinition: #SalesBook category: 'TusLibros'!
Object subclass: #SalesBook
	instanceVariableNames: 'idGenerator sales'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!SalesBook methodsFor: 'initialization' stamp: 'IB 11/9/2023 02:02:40'!
initializeGeneratingTransactionIdsUsing: anIdGenerator

	idGenerator := anIdGenerator.
	sales := Dictionary new! !


!SalesBook methodsFor: 'registering' stamp: 'IB 11/9/2023 02:02:23'!
add: aSale 
	
	sales at: idGenerator nextId put: aSale! !


!SalesBook methodsFor: 'accessing' stamp: 'IB 11/9/2023 03:10:31'!
saleIdentifiedBy: aTransactionId 
	
	^sales at: aTransactionId! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SalesBook class' category: 'TusLibros'!
SalesBook class
	instanceVariableNames: ''!

!SalesBook class methodsFor: 'instance creation' stamp: 'IB 11/9/2023 01:59:46'!
generatingTransactionIdsUsing: anIdGenerator 

	^self new initializeGeneratingTransactionIdsUsing: anIdGenerator ! !


!classDefinition: #StoreSystem category: 'TusLibros'!
Object subclass: #StoreSystem
	instanceVariableNames: 'authenticationSystem idGenerator catalog cartsByID merchantProcessor salesBook transactionsByUser timeSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreSystem methodsFor: 'methods - public' stamp: 'IB 11/9/2023 02:04:31'!
add: aQuantity of: anItem toCartIdentifiedBy: aCartId

	self withCartIdentifiedBy: aCartId do: [:cart | cart add: aQuantity of: anItem]
		
	
	
	! !

!StoreSystem methodsFor: 'methods - public' stamp: 'IB 11/9/2023 04:03:52'!
checkoutCartIdentifiedBy: aCartId payingWith: aCreditCard

	self withCartIdentifiedBy: aCartId do: [:cart | | transactionId |
		(self createCashierFor: cart charging: aCreditCard) checkOut.
		transactionId := self registerLastTransactionToUserIdentifiedBy: cart ownerId.
		self removeCartIdentifiedBy: aCartId.
		^transactionId]! !

!StoreSystem methodsFor: 'methods - public' stamp: 'IB 11/9/2023 04:35:49'!
createCartForUserIdentifiedBy: anUserId withPassword: aPassword

	self authenticateUserIdentifiedBy: aPassword withPassword: anUserId.
	
	^cartsByID store: (self createCartForUserIdentifiedBy: anUserId)
	! !

!StoreSystem methodsFor: 'methods - public' stamp: 'IB 11/9/2023 03:52:19'!
itemsOfCartIdentifiedBy: aCartId

	^self 
		withCartIdentifiedBy: aCartId 
		do: [:cart| cart items]! !

!StoreSystem methodsFor: 'methods - public' stamp: 'IB 11/9/2023 03:54:08'!
purchasesOfUserIdentifiedBy: anUserId withPassword: aPassword
 
	self authenticateUserIdentifiedBy: anUserId withPassword: aPassword.
	
	^transactionsByUser 
		at: anUserId 
		ifPresent: [:transactionIds | transactionIds collect: [:transactionId | salesBook saleIdentifiedBy: transactionId ]] 
		ifAbsent: [{}]! !


!StoreSystem methodsFor: 'support' stamp: 'IB 11/9/2023 02:21:02'!
authenticateUserIdentifiedBy: anUserId withPassword: aPassword

	^ authenticationSystem authenticateUser: anUserId withPassword: aPassword! !

!StoreSystem methodsFor: 'support' stamp: 'IB 11/9/2023 03:51:33'!
createCartForUserIdentifiedBy: anUserId

	^ Cart ownedByUserIdentifiedBy: anUserId acceptingItemsOf: catalog! !

!StoreSystem methodsFor: 'support' stamp: 'IB 11/9/2023 04:13:18'!
createCashierFor: aCart charging: aCreditCard

	^ Cashier 
		toCheckout: aCart 
		charging: aCreditCard
		throught: merchantProcessor
		on: timeSystem currentDate
		registeringOn: salesBook! !

!StoreSystem methodsFor: 'support' stamp: 'IB 11/9/2023 04:03:29'!
registerLastTransactionToUserIdentifiedBy: aUserId

	transactionsByUser at: aUserId ifAbsentPut: [Set new].
	^(transactionsByUser at: aUserId) add: idGenerator lastAssignedId! !

!StoreSystem methodsFor: 'support' stamp: 'IB 11/9/2023 04:45:34'!
removeCartIdentifiedBy: aCartId

	^ cartsByID removeObjectIdentifiedBy: aCartId! !

!StoreSystem methodsFor: 'support' stamp: 'IB 11/9/2023 04:42:42'!
withCartIdentifiedBy: aCartId do: aOneArgBlock

	^ cartsByID 
		withObjectIdentifiedBy: aCartId 
		do: aOneArgBlock
		ifAbsent: [self error: 'invalid cartId']! !


!StoreSystem methodsFor: 'initialization' stamp: 'IB 11/9/2023 04:33:24'!
initializeAuthenticatingUsersWith: anAuthenticationSystem generatingIdsUsing: anIdGenerator withCatalog: aCatalog chargingCardsThrought: aMerchantProcessor using: aTimeSystem     
	
	authenticationSystem := anAuthenticationSystem.
	timeSystem := aTimeSystem.
	idGenerator := anIdGenerator.
	cartsByID := TimeSensitiveRepository workingWith: timeSystem assigningIDsUsing: idGenerator.
	transactionsByUser := Dictionary new.
	catalog := aCatalog.
	merchantProcessor := aMerchantProcessor.
	salesBook := SalesBook generatingTransactionIdsUsing: idGenerator! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StoreSystem class' category: 'TusLibros'!
StoreSystem class
	instanceVariableNames: ''!

!StoreSystem class methodsFor: 'instance creation' stamp: 'IB 11/9/2023 03:48:44'!
authenticatingUsersWith: anAuthenticationSystem 
generatingIdsUsing: anIdGenerator 
withCatalog: aCatalog 
chargingCardsThrought: aMerchantProcessor 
using: aTimeSystem     
	
	^self new 
		initializeAuthenticatingUsersWith: anAuthenticationSystem 
		generatingIdsUsing: anIdGenerator 
		withCatalog: aCatalog 
		chargingCardsThrought: aMerchantProcessor 
		using: aTimeSystem ! !


!classDefinition: #StoreTestObjectsFactory category: 'TusLibros'!
Object subclass: #StoreTestObjectsFactory
	instanceVariableNames: 'today'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'totot 11/6/2023 21:28:09'!
anotherItemSellByTheStore
	^'another valid item'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'totot 11/6/2023 21:29:04'!
anotherItemSellByTheStorePrice
	^200! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStore
	
	^ 'validBook'! !

!StoreTestObjectsFactory methodsFor: 'items' stamp: 'HernanWilkinson 6/17/2013 18:08'!
itemSellByTheStorePrice
	
	^10! !


!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'HernanWilkinson 6/17/2013 18:08'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTestObjectsFactory methodsFor: 'cart' stamp: 'totot 11/6/2023 21:28:52'!
defaultCatalog
	
	^ Dictionary new
		at: self itemSellByTheStore put: self itemSellByTheStorePrice;
		at: self anotherItemSellByTheStore put: self anotherItemSellByTheStorePrice;
		yourself ! !


!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:37'!
expiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber - 1)! !

!StoreTestObjectsFactory methodsFor: 'credit card' stamp: 'HernanWilkinson 6/17/2013 18:36'!
notExpiredCreditCard
	
	^CreditCard expiringOn: (Month month: today monthIndex year: today yearNumber + 1)! !


!StoreTestObjectsFactory methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:37'!
initialize

	today := DateAndTime now! !


!StoreTestObjectsFactory methodsFor: 'date' stamp: 'HernanWilkinson 6/17/2013 18:37'!
today
	
	^ today! !


!classDefinition: #TimeSensitiveRepository category: 'TusLibros'!
Object subclass: #TimeSensitiveRepository
	instanceVariableNames: 'timeSystem idGenerator itemsByID timeStoredById'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TimeSensitiveRepository methodsFor: 'initialization' stamp: 'IB 11/9/2023 04:39:32'!
initializeWorkingWith: aTimeSystem assigningIDsUsing: anIdGenerator 

	timeSystem := aTimeSystem.
	idGenerator := anIdGenerator.
	itemsByID := Dictionary new.
	timeStoredById := Dictionary new! !


!TimeSensitiveRepository methodsFor: 'adding' stamp: 'IB 11/9/2023 04:49:55'!
removeObjectIdentifiedBy: anIdentifier 
	
	timeStoredById removeKey: anIdentifier.
	^itemsByID removeKey: anIdentifier! !

!TimeSensitiveRepository methodsFor: 'adding' stamp: 'IB 11/9/2023 04:45:06'!
store: anObjectToStore
	
	|id|
	
	id := idGenerator nextId.
	
	itemsByID at: id put: anObjectToStore.
	timeStoredById at: id put: timeSystem currentDateAndTime.
	
	^id! !


!TimeSensitiveRepository methodsFor: 'time' stamp: 'IB 11/9/2023 05:02:27'!
checkAvailabilityForObjectIdentifiedBy: anIdentifier ifExpiredDo: aNoneBlock
		
	(self isExpiredObjectIdentifiedBy: anIdentifier)
		ifTrue: [
			self removeObjectIdentifiedBy: anIdentifier.
			aNoneBlock value]
		ifFalse: [self refreshTimeStampForObjectIdentifiedBy: anIdentifier]! !

!TimeSensitiveRepository methodsFor: 'time' stamp: 'IB 11/9/2023 04:58:30'!
isExpiredObjectIdentifiedBy: anIdentifier

	^ (timeSystem currentDateAndTime - (timeStoredById at: anIdentifier)) >= (Duration minutes: 30)! !

!TimeSensitiveRepository methodsFor: 'time' stamp: 'IB 11/9/2023 04:48:44'!
refreshTimeStampForObjectIdentifiedBy: anIdentifier

	^ timeStoredById at: anIdentifier put: timeSystem currentDateAndTime! !


!TimeSensitiveRepository methodsFor: 'accessing' stamp: 'IB 11/9/2023 04:54:48'!
withObjectIdentifiedBy: anIdentifier do: aOneArgBlock ifAbsent: aNoneBlock 
	
	^itemsByID 
		at: anIdentifier 
		ifPresent: [:storedObject |
			self checkAvailabilityForObjectIdentifiedBy: anIdentifier ifExpiredDo: aNoneBlock.
			aOneArgBlock value: storedObject] 
		ifAbsent: aNoneBlock! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TimeSensitiveRepository class' category: 'TusLibros'!
TimeSensitiveRepository class
	instanceVariableNames: ''!

!TimeSensitiveRepository class methodsFor: 'instance creation' stamp: 'IB 11/9/2023 04:34:17'!
workingWith: aTimeSystem assigningIDsUsing: anIdGenerator  
	
	^self new initializeWorkingWith: aTimeSystem assigningIDsUsing: anIdGenerator ! !

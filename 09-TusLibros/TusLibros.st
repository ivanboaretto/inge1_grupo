!classDefinition: #MarketTest category: 'TusLibros'!
TestCase subclass: #MarketTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!MarketTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!MarketTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!MarketTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!MarketTest methodsFor: 'tests -- cart' stamp: 'HAW 11/2/2023 17:12:35'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: self itemSellByTheStore withOcurrences: 0  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!MarketTest methodsFor: 'tests -- cart' stamp: 'HAW 11/2/2023 17:12:46'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add:  self itemNotSellByTheStore withOcurrences: 2  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!MarketTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!MarketTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!MarketTest methodsFor: 'tests -- cart' stamp: 'HAW 11/2/2023 17:12:59'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore withOcurrences: 2.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !


!MarketTest methodsFor: 'tests -- cashier' stamp: 's 11/4/2023 20:40:33'!
test09CanNotCreateCashierOfEmptyCart

	| cart cashier creditCard |
	
	cart := self createCart.
	creditCard:= self createNonExpiredCard.
	self 
		should: [ cashier:= Cashier for:cart payingWith: creditCard withPricedCatalog: self defaultPriceCatalog  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier new class emptyCartErrorMessage.
			"falta ver que no se creo el objeto?" ].! !

!MarketTest methodsFor: 'tests -- cashier' stamp: 's 11/4/2023 20:40:33'!
test10CanNotCreateCashierPayingWithAnExpiredCreditCard

	| cart cashier  creditCard | 
	
	cart := self createCart.
	cart add: self itemSellByTheStore.
	creditCard:= self createExpiredCard.
	
	self 
		should: [cashier:= Cashier for:cart payingWith: creditCard withPricedCatalog: self defaultPriceCatalog   ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier new class creditCardExpiredMessageDescription.
			"falta ver que no se creo el objeto?" ].! !

!MarketTest methodsFor: 'tests -- cashier' stamp: 's 11/4/2023 21:15:31'!
test11CanCheckoutCashier

	| cart cashier creditCard | 
	
	cart := self createCart.
	cart add: self itemSellByTheStore.
	creditCard:= self createNonExpiredCard.
	cashier:= Cashier for:cart payingWith: creditCard withPricedCatalog: self defaultPriceCatalog  .
	cashier checkout.
	self assert: cashier transactionList equals: (Bag with: self itemSellByTheStore) "aca falta que tambien agregue la suma de los costos, capaz tenerlo como otra variable puede estar bien, ni idea"! !


!MarketTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:48'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!MarketTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
defaultCatalog
	
	^ Array with: self itemSellByTheStore! !

!MarketTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!MarketTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !


!MarketTest methodsFor: 'support -- cashier' stamp: 's 11/3/2023 00:19:09'!
createExpiredCard
	^CreditCard withCardNumber:1 expiring: FixedGregorianDate theBeginningOfTime monthOfYear ownedBy:'Juan'! !

!MarketTest methodsFor: 'support -- cashier' stamp: 's 11/4/2023 20:19:16'!
createNonExpiredCard
	^CreditCard withCardNumber:1 expiring: FixedGregorianDate theEndOfTime monthOfYear ownedBy:'Juan'! !

!MarketTest methodsFor: 'support -- cashier' stamp: 's 11/4/2023 20:36:57'!
defaultPriceCatalog
	
	^Dictionary new at: self itemSellByTheStore put: 100;yourself.! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidItemErrorMessage
	
	^'Item is not in catalog'! !

!Cart methodsFor: 'error messages' stamp: 'HernanWilkinson 6/17/2013 17:45'!
invalidQuantityErrorMessage
	
	^'Invalid number of items'! !


!Cart methodsFor: 'assertions' stamp: 's 11/4/2023 20:36:07'!
assertIsValidItem: anItem

	(catalog includes: anItem) ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'HernanWilkinson 6/17/2013 17:51'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 's 11/4/2023 20:30:36'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	
	items := Bag new.! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'HAW 11/2/2023 17:13:30'!
add: anItem

	^ self add: anItem withOcurrences: 1 ! !

!Cart methodsFor: 'adding' stamp: 'HAW 11/2/2023 17:13:19'!
add: anItem withOcurrences: aQuantity

	self assertIsValidQuantity: aQuantity.
	self assertIsValidItem: anItem.

	items add: anItem withOccurrences: aQuantity .
	! !


!Cart methodsFor: 'as yet unclassified' stamp: 's 11/4/2023 20:36:26'!
listCart
	^items! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'TusLibros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


!classDefinition: #Cashier category: 'TusLibros'!
Object subclass: #Cashier
	instanceVariableNames: 'cart creditCard pricedCatalog transactionList'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialize' stamp: 's 11/4/2023 20:48:04'!
initializeFor: aCart payingWith: aCreditCard withPricedCatalog: aPricedCatalog 
	
	cart := aCart.
	creditCard:= aCreditCard.
	pricedCatalog:= aPricedCatalog.
	transactionList:= Bag new.! !


!Cashier methodsFor: 'checkout' stamp: 's 11/4/2023 21:16:16'!
checkout
	transactionList addAll: cart listCart."esto no se si tiene que estar adentro de debit o aca"
	self debit: (self costOf: cart listCart) from: creditCard.! !

!Cashier methodsFor: 'checkout' stamp: 's 11/4/2023 20:41:36'!
costOf: anItemList 
	^anItemList  sum:[:item| (cart occurrencesOf:item) * (pricedCatalog at: item)]! !


!Cashier methodsFor: 'debit' stamp: 's 11/4/2023 20:42:00'!
debit: aCart from: aCreditCard 
	! !


!Cashier methodsFor: 'transactions' stamp: 's 11/4/2023 20:47:01'!
transactionList
	^transactionList ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'instance creation' stamp: 's 11/3/2023 00:14:33'!
assertCartIsNotEmpty: aCart

	^ aCart isEmpty ifTrue:[self error: self emptyCartErrorMessage]! !

!Cashier class methodsFor: 'instance creation' stamp: 's 11/4/2023 20:40:45'!
for: aCart payingWith: aCreditCard withPricedCatalog: aPricedCatalog 
	self assertCartIsNotEmpty: aCart.
	aCreditCard isExpired ifTrue:[self error: self creditCardExpiredMessageDescription ].
	^self new initializeFor: aCart payingWith: aCreditCard withPricedCatalog: aPricedCatalog ! !


!Cashier class methodsFor: 'error messages' stamp: 's 11/3/2023 00:18:11'!
creditCardExpiredMessageDescription
	^'Can not create cashier with an expired creditCard'! !

!Cashier class methodsFor: 'error messages' stamp: 's 11/3/2023 00:03:39'!
emptyCartErrorMessage
	^'Can not create cashier for an empty cart'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'creditCardNumber monthOfYearOfExpiration creditCardOwnerName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'initialize' stamp: 's 11/3/2023 00:17:31'!
initializeWithCardNumber: aCreditCardNumber expiring: aMonthOfYearOfExpiration ownedBy: aCreditCardOwnerName 
	
	creditCardNumber := aCreditCardNumber.
	monthOfYearOfExpiration := aMonthOfYearOfExpiration.
	creditCardOwnerName := aCreditCardOwnerName.! !

!CreditCard methodsFor: 'initialize' stamp: 's 11/3/2023 00:20:01'!
isExpired
	^FixedGregorianDate today monthOfYear > monthOfYearOfExpiration.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 's 11/3/2023 00:17:19'!
withCardNumber: aCreditCardNumber expiring: aMonthOfYearOfExpiration ownedBy: aCreditCardOwnerName 
	^self new initializeWithCardNumber: aCreditCardNumber expiring: aMonthOfYearOfExpiration ownedBy: aCreditCardOwnerName ! !

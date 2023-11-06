!classDefinition: #StoreTest category: 'TusLibros'!
TestCase subclass: #StoreTest
	instanceVariableNames: 'merchantProcessorProcedure'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTest methodsFor: 'tests -- cart' stamp: 'IB 11/6/2023 12:23:19'!
test01NewCartsAreCreatedEmpty

	self assert: self emptyCart isEmpty! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'IB 11/6/2023 12:23:19'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self emptyCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'IB 11/6/2023 12:23:19'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self emptyCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'IB 11/6/2023 12:23:19'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self emptyCart.
	
	self 
		should: [cart add: self itemSellByTheStore withOcurrences: 0  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'IB 11/6/2023 12:23:19'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self emptyCart.
	
	self 
		should: [cart add: self itemNotSellByTheStore withOcurrences: 2  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'IB 11/6/2023 12:23:19'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self emptyCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'IB 11/6/2023 12:23:19'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self emptyCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'IB 11/6/2023 12:23:19'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self emptyCart.
	
	cart add: self itemSellByTheStore withOcurrences: 2.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !


!StoreTest methodsFor: 'tests -- cashier' stamp: 's 11/6/2023 13:16:09'!
test09CanNotCreateCashierForEmptyCart

	self setUpMerchantProcessorToExecute: [].
	
	self 
		should: [ Cashier 
				for: self emptyCart 
				payingWith: self nonExpiredCreditCard 
				via: self 
				withPricedCatalog: self defaultPriceCatalog  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier new class emptyCartErrorMessage. ].! !

!StoreTest methodsFor: 'tests -- cashier' stamp: 's 11/6/2023 13:16:37'!
test10CanNotCreateCashierPayingWithAnExpiredCreditCard

	self setUpMerchantProcessorToExecute: [].
	
	self 
		should: [Cashier 
				for: self cartWithCatalogedItem 
				payingWith: self expiredCreditCard 
				via: self 
				withPricedCatalog: self defaultPriceCatalog]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier new class creditCardExpiredErrorMessage.].! !

!StoreTest methodsFor: 'tests -- cashier' stamp: 'IB 11/6/2023 12:28:43'!
test11CashierKnowsAlreadyCheckedOutItems

	| cashier | 
	
	self setUpMerchantProcessorToExecute: [].
	cashier := 
		Cashier 
			for: self cartWithCatalogedItem 
			payingWith: self nonExpiredCreditCard 
			via: self 
			withPricedCatalog: self defaultPriceCatalog.
	
	cashier checkout.
	
	self assert: cashier alreadyCheckOutItems equals: (Bag with: self itemSellByTheStore)! !

!StoreTest methodsFor: 'tests -- cashier' stamp: 's 11/6/2023 13:16:46'!
test12CantCheckoutWhenCreditCardHasNoLimit

	| cashier | 
	
	self setUpMerchantProcessorToExecute: [self error: Cashier creditCardHasNotEnoughFundsErrorMessage].
	
	cashier := Cashier 
				for: self cartWithCatalogedItem 
				payingWith: self nonExpiredCreditCard 
				via: self 
				withPricedCatalog: self defaultPriceCatalog.
	
	self should: [cashier checkout] raise: Error withMessageText:  Cashier creditCardHasNotEnoughFundsErrorMessage! !


!StoreTest methodsFor: 'support -- cart' stamp: 'IB 11/6/2023 12:30:26'!
cartWithCatalogedItem

	^self emptyCart 
		add: self itemSellByTheStore;
		yourself! !

!StoreTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
defaultCatalog
	
	^ Array with: self itemSellByTheStore! !

!StoreTest methodsFor: 'support -- cart' stamp: 'IB 11/6/2023 12:23:19'!
emptyCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !


!StoreTest methodsFor: 'support -- cashier' stamp: 'IB 11/6/2023 12:00:50'!
debit: anAmount from: aCreditCard

	merchantProcessorProcedure value! !

!StoreTest methodsFor: 'support -- cashier' stamp: 'IB 11/6/2023 03:03:17'!
defaultPriceCatalog
	
	^Dictionary new 
		at: self itemSellByTheStore put: 100;
		yourself.! !

!StoreTest methodsFor: 'support -- cashier' stamp: 'IB 11/6/2023 12:25:52'!
expiredCreditCard
	
	^CreditCard expiringOn: FixedGregorianDate theBeginningOfTime monthOfYear! !

!StoreTest methodsFor: 'support -- cashier' stamp: 'IB 11/6/2023 12:26:04'!
nonExpiredCreditCard

	^CreditCard expiringOn: FixedGregorianDate theEndOfTime monthOfYear! !

!StoreTest methodsFor: 'support -- cashier' stamp: 'IB 11/6/2023 12:01:53'!
setUpMerchantProcessorToExecute: aBlock

	merchantProcessorProcedure := aBlock! !


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


!Cart methodsFor: 'assertions' stamp: 'IB 11/6/2023 12:16:26'!
assertCatalogIncludes: anItem

	(catalog includes: anItem) 
		ifFalse: [ self error: self invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'IB 11/6/2023 12:16:57'!
assertValidItemQuantity: aQuantity

	aQuantity strictlyPositive 
		ifFalse: [ self error: self invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'IB 11/6/2023 12:15:50'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := Bag new! !


!Cart methodsFor: 'queries' stamp: 'HernanWilkinson 6/17/2013 17:45'!
occurrencesOf: anItem

	^items occurrencesOf: anItem  ! !

!Cart methodsFor: 'queries' stamp: 'IB 11/6/2023 12:05:08'!
totalPriceConsidering: aPricedCatalog

	^items sum: [:item | (self occurrencesOf: item) * (aPricedCatalog at: item)]! !


!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
includes: anItem

	^items includes: anItem ! !

!Cart methodsFor: 'testing' stamp: 'HernanWilkinson 6/17/2013 17:44'!
isEmpty
	
	^items isEmpty ! !


!Cart methodsFor: 'adding' stamp: 'IB 11/6/2023 12:14:27'!
add: anItem

	^self add: anItem withOcurrences: 1 ! !

!Cart methodsFor: 'adding' stamp: 'IB 11/6/2023 12:17:31'!
add: anItem withOcurrences: aQuantity

	self assertValidItemQuantity: aQuantity.
	self assertCatalogIncludes: anItem.

	items add: anItem withOccurrences: aQuantity
	! !


!Cart methodsFor: 'accessing' stamp: 'IB 11/6/2023 01:40:38'!
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
	instanceVariableNames: 'cart creditCard pricedCatalog alreadyCheckOutItems merchantProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialization' stamp: 's 11/6/2023 15:17:46'!
initializeFor: aCart payingWith: aCreditCard via: aMerchantProcessor withPricedCatalog: aPricedCatalog 
	
	cart := aCart.
	creditCard := aCreditCard.
	pricedCatalog := aPricedCatalog.
	merchantProcessor := aMerchantProcessor.
	alreadyCheckOutItems := Bag new.! !


!Cashier methodsFor: 'checkout' stamp: 'IB 11/6/2023 12:05:45'!
cartTotalCost

	^cart totalPriceConsidering: pricedCatalog! !

!Cashier methodsFor: 'checkout' stamp: 'IB 11/6/2023 11:47:04'!
checkout
	
	merchantProcessor debit: self cartTotalCost from: creditCard.
	alreadyCheckOutItems addAll: cart listCart! !


!Cashier methodsFor: 'purchases' stamp: 'IB 11/6/2023 11:50:02'!
alreadyCheckOutItems

	^alreadyCheckOutItems ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: 'TusLibros'!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'asserting' stamp: 's 11/6/2023 13:17:15'!
assertCardIsNotExpired: aCreditCard

	^ aCreditCard isExpired 
		ifTrue: [self error: self creditCardExpiredErrorMessage]! !

!Cashier class methodsFor: 'asserting' stamp: 'IB 11/6/2023 12:18:42'!
assertCartIsNotEmpty: aCart

	^ aCart isEmpty ifTrue: [self error: self emptyCartErrorMessage]! !


!Cashier class methodsFor: 'instance creation' stamp: 's 11/6/2023 13:17:15'!
for: aCart payingWith: aCreditCard via: aMerchantProcessor withPricedCatalog: aPricedCatalog

	self assertCartIsNotEmpty: aCart.
	self assertCardIsNotExpired: aCreditCard.
	
	^self new 
		initializeFor: aCart 
		payingWith: aCreditCard 
		via: aMerchantProcessor 
		withPricedCatalog: aPricedCatalog ! !


!Cashier class methodsFor: 'error messages' stamp: 's 11/6/2023 13:16:37'!
creditCardExpiredErrorMessage

	^'Can not create cashier with an expired creditCard'! !

!Cashier class methodsFor: 'error messages' stamp: 's 11/6/2023 13:16:46'!
creditCardHasNotEnoughFundsErrorMessage
	^'Not enough funds'! !

!Cashier class methodsFor: 'error messages' stamp: 'IB 11/6/2023 12:19:59'!
emptyCartErrorMessage

	^'Can not create cashier for an empty cart'! !


!classDefinition: #CreditCard category: 'TusLibros'!
Object subclass: #CreditCard
	instanceVariableNames: 'monthOfYearOfExpiration'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CreditCard methodsFor: 'testing' stamp: 's 11/6/2023 13:11:28'!
isExpired
	
	^self isExpiredOn: FixedGregorianDate today.! !

!CreditCard methodsFor: 'testing' stamp: 's 11/6/2023 13:11:28'!
isExpiredOn:aDate
	
	^aDate monthOfYear > monthOfYearOfExpiration.! !


!CreditCard methodsFor: 'initialization' stamp: 's 11/6/2023 13:04:03'!
initializeExpiringOn: aMonth
	monthOfYearOfExpiration := aMonth! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CreditCard class' category: 'TusLibros'!
CreditCard class
	instanceVariableNames: ''!

!CreditCard class methodsFor: 'instance creation' stamp: 's 11/6/2023 13:03:40'!
expiringOn: aMonthOfYearOfExpiration
	
	^self new initializeExpiringOn: aMonthOfYearOfExpiration! !

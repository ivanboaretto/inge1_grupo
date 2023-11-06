!classDefinition: #APIMockTest category: 'TusLibros'!
TestCase subclass: #APIMockTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!APIMockTest methodsFor: 'tests' stamp: 's 11/5/2023 21:05:41'!
test01InvalidUserForCartCreation
	| request api response |
	request:= Dictionary new.
	request at: #clientId put:'Juan'.
	request at: #password put:'pass'.
	
	api:= StoreAPI workingWith: (StoreSystem withUserDataBase: self defaultUserDataBase).
	
	response := api createCartBasedOn: request.
	
	self assert: response code equals: 200.
	self assert: response body equals: self invalidUserResponseBody.! !

!APIMockTest methodsFor: 'tests' stamp: 's 11/5/2023 21:05:38'!
test02WrongPasswordForCartCreation
	| request api response |
	request:= Dictionary new.
	request at: #clientId put:'Pedro'.
	request at: #password put:'wrong pass'.
	
	api:= StoreAPI workingWith: (StoreSystem withUserDataBase: self defaultUserDataBase).
	
	response := api createCartBasedOn: request.
	
	self assert: response code equals: 200.
	self assert: response body equals: self wrongPasswordResponseBody.! !

!APIMockTest methodsFor: 'tests' stamp: 's 11/5/2023 21:05:35'!
test03InvalidRequestForCartCreation
	| request api response |
	request:= Dictionary new.
	
	api:= StoreAPI workingWith: (StoreSystem withUserDataBase: self defaultUserDataBase).
	
	response := api createCartBasedOn: request.
	
	self assert: response code equals: 400.
	! !

!APIMockTest methodsFor: 'tests' stamp: 's 11/5/2023 21:07:34'!
test04CreateCart
	| request api response |
	request:= Dictionary new.
	request at: #clientId put:'Pedro'.
	request at: #password put:'pass'.
	
	api:= StoreAPI workingWith: (StoreSystem withUserDataBase: self defaultUserDataBase).
	
	response := api createCartBasedOn: request.
	
	self assert: response code equals: 200.
	self assert: response body equals: '0|1'.
	! !


!APIMockTest methodsFor: 'support' stamp: 's 11/5/2023 21:04:43'!
defaultUserDataBase
	| userDatabase |
	userDatabase:= Dictionary  new.
	userDatabase at: 'Pedro' put: 'pass'.
	userDatabase at: 'Tomas' put: '1234'.
	^userDatabase.! !

!APIMockTest methodsFor: 'support' stamp: 's 11/5/2023 20:48:56'!
invalidUserResponseBody
	^'1|Invalid user'! !

!APIMockTest methodsFor: 'support' stamp: 's 11/5/2023 20:49:00'!
wrongPasswordResponseBody
	^'1|Wrong password'! !


!classDefinition: #StoreTest category: 'TusLibros'!
TestCase subclass: #StoreTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:08'!
test01NewCartsAreCreatedEmpty

	self assert: self createCart isEmpty! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:45'!
test02CanNotAddItemsThatDoNotBelongToStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [ cart add: self itemNotSellByTheStore ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test03AfterAddingAnItemTheCartIsNotEmptyAnymore

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self deny: cart isEmpty ! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'HAW 11/2/2023 17:12:35'!
test04CanNotAddNonPositiveNumberOfItems

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add: self itemSellByTheStore withOcurrences: 0  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidQuantityErrorMessage.
			self assert: cart isEmpty ]! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'HAW 11/2/2023 17:12:46'!
test05CanNotAddMoreThanOneItemNotSellByTheStore

	| cart |
	
	cart := self createCart.
	
	self 
		should: [cart add:  self itemNotSellByTheStore withOcurrences: 2  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart invalidItemErrorMessage.
			self assert: cart isEmpty ]! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test06CartRemembersAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore.
	self assert: (cart includes: self itemSellByTheStore)! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
test07CartDoesNotHoldNotAddedItems

	| cart |
	
	cart := self createCart.
	
	self deny: (cart includes: self itemSellByTheStore)! !

!StoreTest methodsFor: 'tests -- cart' stamp: 'HAW 11/2/2023 17:12:59'!
test08CartRemembersTheNumberOfAddedItems

	| cart |
	
	cart := self createCart.
	
	cart add: self itemSellByTheStore withOcurrences: 2.
	self assert: (cart occurrencesOf: self itemSellByTheStore) = 2! !


!StoreTest methodsFor: 'tests -- cashier' stamp: 's 11/5/2023 20:05:22'!
test09CanNotCreateCashierOfEmptyCart

	| cart creditCard |
	
	cart := self createCart.
	creditCard:= self createNonExpiredCard.
	self 
		should: [ Cashier for:cart payingWith: creditCard withPricedCatalog: self defaultPriceCatalog  ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier new class emptyCartErrorMessage. ].! !

!StoreTest methodsFor: 'tests -- cashier' stamp: 's 11/5/2023 20:05:17'!
test10CanNotCreateCashierPayingWithAnExpiredCreditCard

	| cart creditCard | 
	
	cart := self createCart.
	cart add: self itemSellByTheStore.
	creditCard:= self createExpiredCard.
	
	self 
		should: [Cashier for:cart payingWith: creditCard withPricedCatalog: self defaultPriceCatalog   ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier new class creditCardExpiredMessageDescription.].! !

!StoreTest methodsFor: 'tests -- cashier' stamp: 's 11/5/2023 20:12:13'!
test11CanCheckoutCashier

	| cart cashier creditCard | 
	
	cart := self createCart.
	cart add: self itemSellByTheStore.
	creditCard:= self createNonExpiredCard.
	cashier:= Cashier for:cart payingWith: creditCard withPricedCatalog: self defaultPriceCatalog  .
	cashier checkout.
	self assert: cashier alreadyCheckOutItems equals: (Bag with: self itemSellByTheStore)! !


!StoreTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:48'!
createCart
	
	^Cart acceptingItemsOf: self defaultCatalog! !

!StoreTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
defaultCatalog
	
	^ Array with: self itemSellByTheStore! !

!StoreTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:44'!
itemNotSellByTheStore
	
	^'invalidBook'! !

!StoreTest methodsFor: 'support -- cart' stamp: 'HernanWilkinson 6/17/2013 17:43'!
itemSellByTheStore
	
	^ 'validBook'! !


!StoreTest methodsFor: 'support -- cashier' stamp: 's 11/5/2023 21:20:46'!
createExpiredCard
	^CreditCard withCardNumber:1 expiring: FixedGregorianDate theBeginningOfTime monthOfYear ownedBy:'Juan'.! !

!StoreTest methodsFor: 'support -- cashier' stamp: 's 11/4/2023 20:19:16'!
createNonExpiredCard
	^CreditCard withCardNumber:1 expiring: FixedGregorianDate theEndOfTime monthOfYear ownedBy:'Juan'! !

!StoreTest methodsFor: 'support -- cashier' stamp: 's 11/4/2023 20:36:57'!
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


!Cart methodsFor: 'initialization' stamp: 's 11/5/2023 20:09:28'!
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
	instanceVariableNames: 'cart creditCard pricedCatalog alreadyCheckOutItems'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'initialize' stamp: 's 11/5/2023 20:11:44'!
initializeFor: aCart payingWith: aCreditCard withPricedCatalog: aPricedCatalog 
	
	cart := aCart.
	creditCard:= aCreditCard.
	pricedCatalog:= aPricedCatalog.
	alreadyCheckOutItems:= Bag new.! !


!Cashier methodsFor: 'checkout' stamp: 's 11/5/2023 20:08:37'!
checkout
	
	self debit: (self costOf: cart listCart) from: creditCard.! !

!Cashier methodsFor: 'checkout' stamp: 's 11/5/2023 20:07:20'!
costOf: anItemList 
	^anItemList  sum:[:item | (cart occurrencesOf: item) * (pricedCatalog at: item)]! !


!Cashier methodsFor: 'debit' stamp: 's 11/5/2023 20:11:44'!
debit: aCart from: aCreditCard 
	alreadyCheckOutItems addAll: cart listCart.! !


!Cashier methodsFor: 'transactions' stamp: 's 11/5/2023 20:11:56'!
alreadyCheckOutItems
	^alreadyCheckOutItems ! !

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


!classDefinition: #Response category: 'TusLibros'!
Object subclass: #Response
	instanceVariableNames: 'code body'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Response methodsFor: 'initialize' stamp: 's 11/5/2023 20:41:50'!
initializeWithCode: aCode withBody: aBody 
	
	code := aCode.
	body := aBody.! !


!Response methodsFor: 'accesing' stamp: 's 11/5/2023 20:59:15'!
body
	^body! !

!Response methodsFor: 'accesing' stamp: 's 11/5/2023 20:59:12'!
code
	^code! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Response class' category: 'TusLibros'!
Response class
	instanceVariableNames: ''!

!Response class methodsFor: 'instance creation' stamp: 's 11/5/2023 20:52:50'!
withCode: aCode 
	
	^self  withCode: aCode withBody: ''. ! !

!Response class methodsFor: 'instance creation' stamp: 's 11/5/2023 20:41:41'!
withCode: aCode withBody: aBody 
	
	^self new initializeWithCode: aCode withBody: aBody ! !


!classDefinition: #StoreAPI category: 'TusLibros'!
Object subclass: #StoreAPI
	instanceVariableNames: 'storeSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreAPI methodsFor: 'initialize' stamp: 's 11/5/2023 20:31:09'!
initializeWorkingWith: aStoreSystem
	storeSystem:= aStoreSystem.! !


!StoreAPI methodsFor: 'metodos' stamp: 's 11/5/2023 21:09:41'!
createCartBasedOn: request 
	| clientId password cart |
	clientId:= request at: #clientId ifAbsent:[^Response withCode:400].
	password:= request at: #password ifAbsent:[^Response withCode:400].
	
	[ cart:= storeSystem createCartFor: clientId withPassword: password] 
		on: Error 
		do: [:anError| ^Response withCode:200 withBody: '1|', anError messageText].
		
	^Response withCode:200 withBody:'0|', cart.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StoreAPI class' category: 'TusLibros'!
StoreAPI class
	instanceVariableNames: ''!

!StoreAPI class methodsFor: 'instance creation' stamp: 's 11/5/2023 20:30:54'!
workingWith: aSystem 
	^self new initializeWorkingWith: aSystem ! !


!classDefinition: #StoreSystem category: 'TusLibros'!
Object subclass: #StoreSystem
	instanceVariableNames: 'usersDatabase passwords'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreSystem methodsFor: 'metodos' stamp: 's 11/5/2023 20:57:21'!
assert: clientId hasPassword: password

	^ ((usersDatabase at: clientId) = password) ifFalse:[self error: 'Wrong password']! !

!StoreSystem methodsFor: 'metodos' stamp: 's 11/5/2023 20:56:08'!
assertRegisteredClientId: clientId

	^ (usersDatabase includesKey: clientId) ifFalse:[self error:'Invalid user']! !

!StoreSystem methodsFor: 'metodos' stamp: 's 11/5/2023 20:58:57'!
authenticate: clientId withPassword: password

	self assertRegisteredClientId: clientId.
	self assert: clientId hasPassword: password! !

!StoreSystem methodsFor: 'metodos' stamp: 's 11/5/2023 21:10:08'!
createCartFor: clientId withPassword: password 
	self authenticate: clientId withPassword: password.
	Cart  new! !


!StoreSystem methodsFor: 'initialize' stamp: 's 11/5/2023 21:07:15'!
initializeWithUserDataBase: aUserDatabase 
	
	usersDatabase := aUserDatabase.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StoreSystem class' category: 'TusLibros'!
StoreSystem class
	instanceVariableNames: ''!

!StoreSystem class methodsFor: 'instance creation' stamp: 's 11/5/2023 21:05:01'!
withUserDataBase: aUserDatabase 
	
	^self new initializeWithUserDataBase: aUserDatabase ! !

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
	instanceVariableNames: 'authenticationProcedure storeSystem cartIdGenerator storeTestObjectsFactory'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreSystemTest methodsFor: 'tests' stamp: 'totot 11/6/2023 20:33:26'!
test01CreateCartWithUnregisteredUser
	
	
	authenticationProcedure:=[self error: 'Invalid username'].

	
	self 
		should: [storeSystem createCartForUserID:'Pedro' withPassword:'pass'. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = 'Invalid username'.]! !

!StoreSystemTest methodsFor: 'tests' stamp: 'totot 11/6/2023 20:33:26'!
test02CreateCartWithWrongPassword
	
	
	authenticationProcedure:= [self error: 'Wrong password'].
	
	
	self 
		should: [storeSystem createCartForUserID:'Pedro' withPassword:'pass'. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = 'Wrong password'.]! !

!StoreSystemTest methodsFor: 'tests' stamp: 'totot 11/6/2023 21:02:13'!
test03CreateOneCart
	
	| cartId cartItems |
	authenticationProcedure:= [].
	
	cartId:= storeSystem createCartForUserID:'Pedro' withPassword:'pass'. 
	
	cartItems:= storeSystem listCart: cartId.
	
	self assert: cartItems isEmpty.
	^cartId! !

!StoreSystemTest methodsFor: 'tests' stamp: 'totot 11/6/2023 20:47:03'!
test04CreateMoreOneCart
	
	|  cartId cartItems |
	
	self test03CreateOneCart.
	
	cartId:= storeSystem createCartForUserID:'Juan' withPassword:'pass2'. 
	
	cartItems:= storeSystem listCart: cartId.
	self assert: cartId equals: cartIdGenerator lastAssignedCartId.
	self assert: cartItems isEmpty.! !

!StoreSystemTest methodsFor: 'tests' stamp: 'totot 11/6/2023 21:31:20'!
test05CanNotAddItemToInvalidCartId
	
	self 
		should: [storeSystem add: 1 ofBookISBN: storeTestObjectsFactory  itemNotSellByTheStore toCart: 200. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText ='invalid cartId'].
	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'totot 11/6/2023 21:26:08'!
test06CanNotAddInvalidItems
	
	|  cartId cartItems |
	
	cartId:=self test03CreateOneCart.
	
	self 
		should: [storeSystem add: 1 ofBookISBN: storeTestObjectsFactory  itemNotSellByTheStore toCart: cartId. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cart invalidItemErrorMessage .
			cartItems:= storeSystem listCart: cartId.
			self assert: cartId equals: cartIdGenerator lastAssignedCartId.
			self assert: cartItems isEmpty.].
	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'totot 11/6/2023 21:30:09'!
test08CanListAddedItems
	
	|  cartId cartItems |
	
	cartId:=self test03CreateOneCart.
	storeSystem add: 2 ofBookISBN: storeTestObjectsFactory  itemSellByTheStore toCart: cartId.
	storeSystem add: 1 ofBookISBN: storeTestObjectsFactory  itemSellByTheStore toCart: cartId.
	storeSystem add: 1 ofBookISBN: storeTestObjectsFactory  anotherItemSellByTheStore toCart: cartId.
	
	cartItems:= storeSystem listCart: cartId.
	self assert: cartItems equals:(Dictionary new at: storeTestObjectsFactory itemSellByTheStore put:3; at: storeTestObjectsFactory anotherItemSellByTheStore put: 1;yourself).
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'totot 11/6/2023 21:33:33'!
test09CanNotCheckoutUnregisteredCart
	
	self 
		should: [storeSystem checkoutCart: 200 payingWith: storeTestObjectsFactory notExpiredCreditCard . ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText ='invalid cartId'].
	
	
	

	
	! !

!StoreSystemTest methodsFor: 'tests' stamp: 'totot 11/6/2023 21:42:12'!
test10CanCheckout
	| cartId transactionId |
	cartId:= self test03CreateOneCart.
	storeSystem add: 1 ofBookISBN: storeTestObjectsFactory itemSellByTheStore toCart: cartId.
	
	transactionId := storeSystem checkoutCart: cartId payingWith: storeTestObjectsFactory notExpiredCreditCard.
	
	self assert: transactionId equals: cartIdGenerator lastAssignedCartId.
	
	
	
	

	
	! !


!StoreSystemTest methodsFor: 'support' stamp: 'totot 11/6/2023 20:27:16'!
authenticateUser: anUserId withPassword: aPassword 
	authenticationProcedure value
	! !


!StoreSystemTest methodsFor: 'running' stamp: 'totot 11/6/2023 21:38:44'!
setUp
	storeTestObjectsFactory:= StoreTestObjectsFactory new.
	cartIdGenerator:= IdGenerator new.
	storeSystem:= StoreSystem authenticatingUsersWith: self generatingCartIdUsing:( cartIdGenerator ) withCatalog: storeTestObjectsFactory defaultCatalog .
	! !


!classDefinition: #Cart category: 'TusLibros'!
Object subclass: #Cart
	instanceVariableNames: 'catalog items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'unclassifed' stamp: 'totot 11/6/2023 21:18:32'!
withItemsDo: aOneArgBlock
	items do: aOneArgBlock.! !



!Cart methodsFor: 'assertions' stamp: 'totot 11/6/2023 20:56:22'!
assertIsValidItem: anItem

	(catalog includesKey: anItem) ifFalse: [ self error: self class invalidItemErrorMessage ]! !

!Cart methodsFor: 'assertions' stamp: 'totot 11/6/2023 20:56:35'!
assertIsValidQuantity: aQuantity

	aQuantity strictlyPositive ifFalse: [ self error: self class invalidQuantityErrorMessage ]! !


!Cart methodsFor: 'initialization' stamp: 'totot 11/6/2023 21:18:08'!
initializeAcceptingItemsOf: aCatalog

	catalog := aCatalog.
	items := OrderedCollection new.! !


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

!Cart class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 17:48'!
acceptingItemsOf: aCatalog

	^self new initializeAcceptingItemsOf: aCatalog ! !


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

!Cashier methodsFor: 'checkout - private' stamp: 'HernanWilkinson 6/17/2013 19:07'!
createSale

	^ Sale of: total
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

!IdGenerator methodsFor: 'as yet unclassified' stamp: 'totot 11/6/2023 20:45:48'!
initialize
	nextId:= 1.! !

!IdGenerator methodsFor: 'as yet unclassified' stamp: 'totot 11/6/2023 20:49:59'!
nextId
	nextId:= nextId+1.
	^nextId-1.! !


!IdGenerator methodsFor: 'queries' stamp: 'totot 11/6/2023 20:49:40'!
lastAssignedCartId
	^nextId -1.! !


!classDefinition: #Sale category: 'TusLibros'!
Object subclass: #Sale
	instanceVariableNames: 'total'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'total' stamp: 'HernanWilkinson 6/17/2013 18:48'!
total
	
	^ total! !


!Sale methodsFor: 'initialization' stamp: 'HernanWilkinson 6/17/2013 18:47'!
initializeTotal: aTotal

	total := aTotal ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: 'TusLibros'!
Sale class
	instanceVariableNames: ''!

!Sale class methodsFor: 'instance creation' stamp: 'HernanWilkinson 6/17/2013 18:47'!
of: aTotal

	"should assert total is not negative or 0!!"
	^self new initializeTotal: aTotal ! !


!classDefinition: #StoreSystem category: 'TusLibros'!
Object subclass: #StoreSystem
	instanceVariableNames: 'authenticationSystem cartIdGenerator catalog cartsIds'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!StoreSystem methodsFor: 'methods' stamp: 'totot 11/6/2023 21:16:06'!
add: aQuantity ofBookISBN: anItem toCart: cartId 
	cartsIds at:cartId 
		ifPresent:[:cart| cart add:aQuantity of: anItem]
		ifAbsent:[self error: 'invalid cartId'].
		
	
	
	! !

!StoreSystem methodsFor: 'methods' stamp: 'totot 11/6/2023 21:34:22'!
checkoutCart: aCartId payingWith: aCreditCard 
	self error: 'invalid cartId'.! !

!StoreSystem methodsFor: 'methods' stamp: 'totot 11/6/2023 20:49:17'!
createCartForUserID: anUserId withPassword: aPassword 
	| cart cartId |
	authenticationSystem authenticateUser: anUserId withPassword:aPassword.
	cart := Cart acceptingItemsOf: catalog.
	cartId:=cartIdGenerator nextId.
	cartsIds at: cartId put:cart.
	
	^cartId.
	! !

!StoreSystem methodsFor: 'methods' stamp: 'totot 11/6/2023 21:25:49'!
listCart: cartId 
	| cartItems |
	cartItems:= Dictionary new.
	cartsIds at:cartId ifPresent:[:cart| cart withItemsDo: [:item| 
			cartItems at: item ifAbsentPut: 0.
			cartItems at: item ifPresent:[:quantity | cartItems at: item put: (quantity + 1)]]].
	^cartItems
		! !


!StoreSystem methodsFor: 'initialization' stamp: 'totot 11/6/2023 21:10:12'!
initializeAuthenticatingUsersWith: anAuthenticationSystem generatingCartIdUsing: anIdGenerator withCatalog: aCatalog   
	
	authenticationSystem := anAuthenticationSystem.
	cartIdGenerator:= anIdGenerator.
	cartsIds := Dictionary new.
	catalog := aCatalog.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'StoreSystem class' category: 'TusLibros'!
StoreSystem class
	instanceVariableNames: ''!

!StoreSystem class methodsFor: 'instance creation' stamp: 'totot 11/6/2023 21:09:47'!
authenticatingUsersWith: anAuthenticationSystem generatingCartIdUsing: anIdGenerator withCatalog: aCatalog   
	
	^self new initializeAuthenticatingUsersWith: anAuthenticationSystem generatingCartIdUsing: anIdGenerator withCatalog: aCatalog ! !


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
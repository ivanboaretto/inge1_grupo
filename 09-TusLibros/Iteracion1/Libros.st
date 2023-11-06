!classDefinition: #CartTest category: 'Libros'!
TestCase subclass: #CartTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Libros'!

!CartTest methodsFor: 'tests' stamp: 'toto 11/6/2023 15:36:40'!
test01NewCartIsEmpty 
	|cart|
	
	cart:= self createCart.
	self assert: cart isEmpty.! !

!CartTest methodsFor: 'tests' stamp: 'toto 11/6/2023 15:43:32'!
test02CanNotAddNotPublishedBooks
	|cart|
	
	cart:= self createCart.
	self 
		should: [ cart add: self notPublishedBook ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart notPublishedBookErrorMessage  .
			self assert: cart isEmpty ]! !

!CartTest methodsFor: 'tests' stamp: 'toto 11/6/2023 15:36:40'!
test03CartRegisterAddedBooks
	|cart|
	
	cart:= self createCart.
	cart add: self publishedBook.
	self deny: cart isEmpty.
	self assert: (cart isAdded: self publishedBook).! !

!CartTest methodsFor: 'tests' stamp: 'toto 11/6/2023 15:56:53'!
test05CartCanOnlyAddStrictlyPositiveQuantity
	|cart|
	
	cart:= self createCart.
	
	self 
		should: [ cart add: self publishedBook withOccurrences: -1. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart nonStrictlyPositiveIntegerQuantityErrorMessage .
			self assert: cart isEmpty ]
	! !

!CartTest methodsFor: 'tests' stamp: 'toto 11/6/2023 15:56:47'!
test06CartCanOnlyAddIntegerQuantity
	|cart|
	
	cart:= self createCart.
	
	self 
		should: [ cart add: self publishedBook withOccurrences: 1.5. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = cart nonStrictlyPositiveIntegerQuantityErrorMessage .
			self assert: cart isEmpty ]
	! !

!CartTest methodsFor: 'tests' stamp: 'toto 11/6/2023 15:59:18'!
test07CartNotRegisterNotAddedBooks
	|cart|
	
	cart:= self createCart.
	self deny: (cart isAdded: self publishedBook).
	! !

!CartTest methodsFor: 'tests' stamp: 'toto 11/6/2023 15:57:49'!
test08CartRegisterHowManyOfABookWereAdded
	|cart|
	
	cart:= self createCart.
	cart add: self publishedBook withOccurrences: 2.
	
	self deny: cart isEmpty.
	self assert: (cart occurrencesOf: self publishedBook ) equals: 2.
	! !


!CartTest methodsFor: 'support' stamp: 'toto 11/6/2023 15:36:40'!
createCart

	^ Cart withEditorial: ( OrderedCollection with: self publishedBook)! !

!CartTest methodsFor: 'support' stamp: 'toto 11/6/2023 15:26:31'!
notPublishedBook
	^1! !

!CartTest methodsFor: 'support' stamp: 'toto 11/6/2023 15:31:20'!
publishedBook
	^2! !


!classDefinition: #Cart category: 'Libros'!
Object subclass: #Cart
	instanceVariableNames: 'editorial addedBooks'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Libros'!

!Cart methodsFor: 'asserting' stamp: 'toto 11/6/2023 15:42:06'!
assertBookIsPublished: anISBNBookToAdd

	^ (editorial includes: anISBNBookToAdd) ifFalse:[self error: self notPublishedBookErrorMessage]! !

!Cart methodsFor: 'asserting' stamp: 'toto 11/6/2023 15:50:59'!
assertIsInteger: Quantity 
	Quantity isInteger ifFalse:[self error: self nonStrictlyPositiveIntegerQuantityErrorMessage ]! !

!Cart methodsFor: 'asserting' stamp: 'toto 11/6/2023 15:49:20'!
assertIsStrictlyPositive: Quantity

	^ Quantity strictlyPositive ifFalse:[self error: self nonStrictlyPositiveIntegerQuantityErrorMessage]! !

!Cart methodsFor: 'asserting' stamp: 'toto 11/6/2023 16:00:29'!
assertValidQuantity: Quantity

	self assertIsStrictlyPositive: Quantity.
	self assertIsInteger: Quantity! !


!Cart methodsFor: 'error' stamp: 'toto 11/6/2023 15:47:58'!
nonStrictlyPositiveIntegerQuantityErrorMessage

	^ 'Can only add strictly positive integer quantity of a book'! !

!Cart methodsFor: 'error' stamp: 'toto 11/6/2023 15:42:06'!
notPublishedBookErrorMessage

	^ 'Book is not in the editorial'! !


!Cart methodsFor: 'initialization' stamp: 'toto 11/6/2023 15:45:43'!
initializeWithEditorial: anEditorial 
	
	editorial := anEditorial.
	addedBooks := Bag new! !


!Cart methodsFor: 'adding' stamp: 'toto 11/6/2023 15:54:27'!
add: aBookISBNToAdd 
	
	self add: aBookISBNToAdd withOccurrences:1.! !

!Cart methodsFor: 'adding' stamp: 'toto 11/6/2023 16:00:29'!
add: aBookISBNToAdd withOccurrences: Quantity 

	self assertBookIsPublished: aBookISBNToAdd.
	self assertValidQuantity: Quantity.
	
	addedBooks add: aBookISBNToAdd withOccurrences:Quantity. ! !


!Cart methodsFor: 'testing' stamp: 'toto 11/6/2023 15:33:14'!
isAdded: anISBNBook 
	^addedBooks includes: anISBNBook .! !

!Cart methodsFor: 'testing' stamp: 'toto 11/6/2023 15:32:31'!
isEmpty
	^addedBooks isEmpty.! !


!Cart methodsFor: 'accesing' stamp: 'toto 11/6/2023 15:54:11'!
occurrencesOf: aBookISBN 
	^addedBooks occurrencesOf: aBookISBN ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: 'Libros'!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'instance creation' stamp: 'toto 11/6/2023 15:34:43'!
withEditorial: anEditorial 
	
	^self new initializeWithEditorial: anEditorial ! !

!classDefinition: #PersistentSet category: 'CustomerImporter'!
Set subclass: #PersistentSet
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentSet methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:25:31'!
initializeOn: aSession from: aNonPersistentSet

	session := aSession.
	self addAll: aNonPersistentSet ! !


!PersistentSet methodsFor: 'adding' stamp: 'HAW 11/14/2023 08:23:40'!
add: newObject

	super add: newObject.
	session persist: newObject.
	
	^newObject! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentSet class' category: 'CustomerImporter'!
PersistentSet class
	instanceVariableNames: ''!

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:24:32'!
on: aSession

	^self on: aSession from: #()! !

!PersistentSet class methodsFor: 'instance creation' stamp: 'HAW 11/14/2023 08:25:00'!
on: aSession from: aNonPersistentSet

	^self new initializeOn: aSession from: aNonPersistentSet
! !


!classDefinition: #CustomerImportTest category: 'CustomerImporter'!
TestCase subclass: #CustomerImportTest
	instanceVariableNames: 'system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImportTest methodsFor: 'tests' stamp: 'IB 11/26/2023 23:53:42'!
test01ValidDataIsImportedCorrectly

	CustomerImporter valueFrom: self validImportData into: system.

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!CustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 21:15:52'!
test02CanNotImportAddressWithoutCustomer

	self
		should: [ CustomerImporter valueFrom: self addressWithoutCustomerData into: system. ]
		raise: Error - MessageNotUnderstood
		withMessageText: CustomerImporter canNotImportAddressWithoutCustomerErrorDescription

	! !

!CustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test03DoesNotImportRecordsStartingWithCButMoreCharacters

	self
		shouldFailImporting: self invalidCustomerRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!CustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:03'!
test04DoesNotImportRecordsStartingWithAButMoreCharacters

	self
		shouldFailImporting: self invalidAddressRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!CustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:36'!
test05CanNotImportAddressRecordWithLessThanSixFields

	self
		shouldFailImporting: self addressRecordWithLessThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!CustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:51:14'!
test06CanNotImportAddressRecordWithMoreThanSixFields

	self
		shouldFailImporting: self addressRecordWithMoreThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!CustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test07CanNotImportCustomerRecordWithLessThanFiveFields

	self
		shouldFailImporting: self customerRecordWithLessThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!CustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test08CanNotImportCustomerRecordWithMoreThanFiveFields

	self
		shouldFailImporting: self customerRecordWithMoreThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!CustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 20:01:43'!
test09CannotImportEmptyLine

	self
		shouldFailImporting: self emptyLine
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !


!CustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!CustomerImportTest methodsFor: 'assertions' stamp: 'IB 11/27/2023 02:47:44'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := system partyOfType: Customer withIdentificationType: anIdType andNumber: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!CustomerImportTest methodsFor: 'assertions' stamp: 'IB 11/27/2023 02:47:44'!
assertImportedOneCustomerWithoutAddress

	| importedCustomer |

	self assert: 1 equals: (system numberOfPartiesOfType: Customer).
	importedCustomer := system partyOfType: Customer withIdentificationType: 'D' andNumber: '22333444'.
	self assert: importedCustomer isAddressesEmpty
	! !

!CustomerImportTest methodsFor: 'assertions' stamp: 'IB 11/27/2023 02:45:53'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: (system numberOfPartiesOfType: Customer)! !

!CustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!CustomerImportTest methodsFor: 'assertions' stamp: 'IB 11/27/2023 02:46:06'!
assertNoCustomerWasImported

	^ self assert: 0 equals: (system numberOfPartiesOfType: Customer)! !

!CustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !

!CustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:15:52'!
shouldFailImporting: aReadStream messageText: anErrorMessageText asserting: anAssertionBlock

	self
		should: [ CustomerImporter valueFrom: aReadStream into: system. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anErrorMessageText equals: anError messageText.
			anAssertionBlock value ]

	! !


!CustomerImportTest methodsFor: 'setUp/tearDown' stamp: 'IB 11/26/2023 23:45:20'!
setUp

	system := Environment current createCustomerSystem.
	system start.
	system beginTransaction! !

!CustomerImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 20:12:16'!
tearDown

	system commit.
	system stop
	! !


!CustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:41:20'!
addressRecordWithLessThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'! !

!CustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:51:35'!
addressRecordWithMoreThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,x'! !

!CustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:14:13'!
addressWithoutCustomerData

	^ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!CustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:53:41'!
customerRecordWithLessThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D'! !

!CustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:55:59'!
customerRecordWithMoreThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444,x'! !

!CustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 20:02:57'!
emptyLine

	^ReadStream on: '
'! !

!CustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:34:25'!
invalidAddressRecordStartData

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
AA,San Martin,3322,Olivos,1636,BsAs'! !

!CustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:22:55'!
invalidCustomerRecordStartData

	^ReadStream on: 'CC,Pepe,Sanchez,D,22333444'! !

!CustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!classDefinition: #SupplierImportTest category: 'CustomerImporter'!
TestCase subclass: #SupplierImportTest
	instanceVariableNames: 'supplierSystem customerSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierImportTest methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:37:19'!
customer

	^Customer 
		withFirstName: 'Pepe' 
		andLast: 'Sanchez'
		withIdentificationType: 'D'			andNumber: '22333444'! !


!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 01:08:09'!
testCanNotImportAddressWithoutSupplier

	self
		should: [ self import: self addressWithoutSupplierData ]
		raise: Error - MessageNotUnderstood
		withMessageText: SupplierImporter canNotImportWithoutSupplierErrorDescription

	! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 01:08:44'!
testCanNotImportNewCustomerWithoutSupplier

	self
		should: [ self import: self newCustomerWithoutSupplierData ]
		raise: Error - MessageNotUnderstood
		withMessageText: SupplierImporter canNotImportWithoutSupplierErrorDescription

	! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 02:55:45'!
testCanNotImportSupplierRecordWithLessThanThreeFields

	self
		shouldFailImporting: self supplierRecordWithLessThanThreeFields
		messageText: SupplierImporter invalidSupplierRecordErrorDescription
		asserting: [ self assertNoSupplierWasImported ]

	! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 02:55:59'!
testCanNotImportSupplierRecordWithMoreThanThreeFields

	self
		shouldFailImporting: self supplierRecordWithMoreThanThreeFields
		messageText: SupplierImporter invalidSupplierRecordErrorDescription
		asserting: [ self assertNoSupplierWasImported ]

	! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/26/2023 23:35:51'!
testCannotImportEmptyLine

	self
		shouldFailImporting: self emptyLine
		messageText: SupplierImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoSupplierWasImported ]

	! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 00:56:49'!
testDoesNotImportRecordsStartingWithAButMoreCharacters

	self
		shouldFailImporting: self invalidAddressRecordStartData
		messageText: SupplierImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneSupplierWithoutAddresses ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 01:42:49'!
testDoesNotImportRecordsStartingWithECButMoreCharacters

	self
		shouldFailImporting: self invalidExistingCustomerRecordStartData
		messageText: SupplierImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneSupplierWithoutCustomer ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 01:10:15'!
testDoesNotImportRecordsStartingWithNCButMoreCharacters

	self
		shouldFailImporting: self invalidNewCustomerRecordStartData
		messageText: SupplierImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneSupplierWithoutCustomer ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 00:36:05'!
testDoesNotImportRecordsStartingWithSButMoreCharacters

	self
		shouldFailImporting: self invalidSupplierRecordStartData
		messageText: SupplierImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoSupplierWasImported ]! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 00:52:28'!
testImportAddress

	|importedSupplier|
	
	self import: self dataWithOneAddress.
	
	self assertNumberOfRegisteredSuppliersIs: 1.
	importedSupplier := self assertThereIsARegisteredSupplierNamed: 'Supplier1' withIdType: 'D' andNumber: '123'.
	self assert: importedSupplier addresses size equals: 1.
	self assertAddressOf: importedSupplier at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 02:49:12'!
testImportExistingCustomer

	|importedSupplier|
	
	customerSystem add: self customer.
	
	self import: self dataWithOneExistingCustomer.
	
	self assertNumberOfRegisteredSuppliersIs: 1.
	self assert: (customerSystem numberOfPartiesOfType: Customer)  equals: 1.
	importedSupplier := self assertThereIsARegisteredSupplierNamed: 'Supplier1' withIdType: 'D' andNumber: '123'.
	self assert: importedSupplier customers size equals: 1.
	self assertCustomerOf: importedSupplier withFirstName: 'Pepe' andLast: 'Sanchez' withIdentificationType: 'D' andNumber: '22333444'! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 00:25:12'!
testImportMoreThanOneSupplier

	self import: self dataWithMoreThanOneSupplier.
	
	self assertNumberOfRegisteredSuppliersIs: 2.
	self assertThereIsARegisteredSupplierNamed: 'Supplier1' withIdType: 'D' andNumber: '123'.
	self assertThereIsARegisteredSupplierNamed: 'Supplier2' withIdType: 'D' andNumber: '456'! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 01:34:14'!
testImportNewCustomer

	|importedSupplier|
	
	self import: self dataWithOneNewCustomer.
	
	self assertNumberOfRegisteredSuppliersIs: 1.
	importedSupplier := self assertThereIsARegisteredSupplierNamed: 'Supplier1' withIdType: 'D' andNumber: '123'.
	self assert: importedSupplier customers size equals: 1.
	self assertCustomerOf: importedSupplier withFirstName: 'Pepe' andLast: 'Sanchez' withIdentificationType: 'D' andNumber: '22333444'! !

!SupplierImportTest methodsFor: 'tests' stamp: 'IB 11/27/2023 00:56:06'!
testImportOnlyOneSupplier

	self import: self dataWithSingleSupplier.
	
	self assertImportedOneSupplierWithoutAddresses! !


!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 00:39:12'!
addressWithoutSupplierData

	^ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 00:34:11'!
dataWithMoreThanOneSupplier 

	^ ReadStream on: self dataWithSingleSupplier contents , '
S,Supplier2,D,456'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 00:45:25'!
dataWithOneAddress
	
	^ReadStream on: self dataWithSingleSupplier contents , '
A,San Martin,3322,Olivos,1636,BsAs'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 01:38:58'!
dataWithOneExistingCustomer

	^ ReadStream on: self dataWithSingleSupplier contents, '
EC,Pepe,Sanchez,D,22333444'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 01:27:36'!
dataWithOneNewCustomer

	^ ReadStream on: self dataWithSingleSupplier contents, '
', self newCustomerWithoutSupplierData contents! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 00:01:24'!
dataWithSingleSupplier

	^ ReadStream on: 'S,Supplier1,D,123'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/26/2023 23:36:35'!
emptyLine

	^ReadStream on: '
'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 00:54:22'!
invalidAddressRecordStartData

	^ReadStream on: self dataWithSingleSupplier contents,'
AA,San Martin,3322,Olivos,1636,BsAs'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 01:43:03'!
invalidExistingCustomerRecordStartData

	^ ReadStream on: self dataWithSingleSupplier contents, '
ECA,Pepe,Sanchez,D,22333444'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 01:11:12'!
invalidNewCustomerRecordStartData

	^ ReadStream on: self dataWithSingleSupplier contents, '
NCA,Pepe,Sanchez,D,22333444'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 00:35:57'!
invalidSupplierRecordStartData

	^ ReadStream on: 'SS,Supplier1,D,123'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 00:58:14'!
newCustomerWithoutSupplierData

	^ ReadStream on: 'NC,Pepe,Sanchez,D,22333444'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 02:51:43'!
supplierRecordWithLessThanThreeFields
	
	^ ReadStream on: 'S,Supplier1,D'! !

!SupplierImportTest methodsFor: 'accessing - data' stamp: 'IB 11/27/2023 02:56:10'!
supplierRecordWithMoreThanThreeFields
	
	^ ReadStream on: 'S,Supplier1,D,123,123123'! !


!SupplierImportTest methodsFor: 'asserting' stamp: 'IB 11/27/2023 00:49:33'!
assertAddressOf: importedSupplier at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedSupplier addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'IB 11/27/2023 01:30:23'!
assertCustomerOf: importedSupplier withFirstName: aFirstName andLast: aLastName withIdentificationType: aIdentificationType andNumber: aIdentificationNumber 
	
	| importedCustomer |

	importedCustomer := importedSupplier customerWithIdentificationType: aIdentificationType andNumber: aIdentificationNumber ifNone: [ self fail ].
	self assert: importedCustomer firstName equals: aFirstName.
	self assert: importedCustomer lastName equals: aLastName

	! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'IB 11/27/2023 00:55:54'!
assertImportedOneSupplierWithoutAddresses
	
	|importedSupplier|
	
	self assertNumberOfRegisteredSuppliersIs: 1.
	importedSupplier := self assertThereIsARegisteredSupplierNamed: 'Supplier1' withIdType: 'D' andNumber: '123'.
	self assert: importedSupplier addresses isEmpty! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'IB 11/27/2023 01:12:07'!
assertImportedOneSupplierWithoutCustomer
	
	|importedSupplier|
	
	self assertNumberOfRegisteredSuppliersIs: 1.
	importedSupplier := self assertThereIsARegisteredSupplierNamed: 'Supplier1' withIdType: 'D' andNumber: '123'.
	self assert: importedSupplier customers isEmpty! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'IB 11/27/2023 02:45:30'!
assertNoSupplierWasImported
	
	^ self assert: 0 equals: (supplierSystem numberOfPartiesOfType: Supplier)! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'IB 11/27/2023 02:45:30'!
assertNumberOfRegisteredSuppliersIs: aNumberOfSuppliers

	^ self assert: (supplierSystem numberOfPartiesOfType: Supplier) equals: aNumberOfSuppliers! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'IB 11/27/2023 02:48:03'!
assertThereIsARegisteredSupplierNamed: aName withIdType: anIdType andNumber: anIdNumber

	| importedSupplier |
	importedSupplier := supplierSystem partyOfType: Supplier withIdentificationType: anIdType andNumber: anIdNumber.
	self assert: importedSupplier firstName equals: aName.
	self assert: importedSupplier identificationType equals: anIdType.
	self assert: importedSupplier identificationNumber equals: anIdNumber.
	^importedSupplier! !

!SupplierImportTest methodsFor: 'asserting' stamp: 'IB 11/27/2023 01:09:27'!
shouldFailImporting: aReadStream messageText: anErrorMessageText asserting: anAssertionBlock

	self
		should: [ SupplierImporter valueFrom: aReadStream into: supplierSystem workingWith: customerSystem ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anErrorMessageText equals: anError messageText.
			anAssertionBlock value ]! !


!SupplierImportTest methodsFor: 'support' stamp: 'IB 11/27/2023 01:03:41'!
import: aStream

	^ SupplierImporter valueFrom: aStream into: supplierSystem workingWith: customerSystem! !


!SupplierImportTest methodsFor: 'running' stamp: 'IB 11/27/2023 01:05:37'!
setUp

	supplierSystem := Environment current createSupplierSystem.
	supplierSystem start.
	supplierSystem beginTransaction.
	customerSystem := Environment current createCustomerSystem.
	customerSystem start.
	customerSystem beginTransaction.! !

!SupplierImportTest methodsFor: 'running' stamp: 'IB 11/27/2023 01:50:10'!
tearDown

	supplierSystem commit.
	supplierSystem stop.
	customerSystem commit.
	customerSystem stop
	! !


!classDefinition: #Address category: 'CustomerImporter'!
Object subclass: #Address
	instanceVariableNames: 'id streetName streetNumber town zipCode province'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province

	^province! !

!Address methodsFor: 'province' stamp: 'HAW 5/22/2022 00:19:29'!
province: aProvince

	province := aProvince
	! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName: aStreetName

	streetName := aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber: aStreetNumber

	streetNumber := aStreetNumber ! !


!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !

!Address methodsFor: 'twon' stamp: 'HAW 5/22/2022 00:19:29'!
town: aTown

	town := aTown! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id inTransaction closed'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:25'!
beginTransaction

	inTransaction := true.! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 11/14/2023 08:52:18'!
commit

	inTransaction := false.! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 11/14/2023 08:52:30'!
close

	closed := true.! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:49:30'!
assertCanUseDatabase

	self assertIsOpen.
	self assertInTransaction ! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:43'!
assertInTransaction

	inTransaction ifFalse: [ self error: 'Not in transaction' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:48:16'!
assertIsOpen

	closed ifTrue: [ self error: 'Connection with database closed' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:09:07'!
assertTypeIsPersisted: aType

	(configuration includes: aType) ifFalse: [ self error: 'Object of type ', aType name, ' are not configured to be persisted' ].! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
isRelationToPersist: possibleRelation

	^ possibleRelation class = Set! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:59'!
persistPossibleRelationOf: anObject at: anInstVarOffset

	| possibleRelation |
		
	possibleRelation := anObject instVarAt: anInstVarOffset.
	(self isRelationToPersist: possibleRelation) ifTrue: [ self persistRelationOf: anObject at: anInstVarOffset with: possibleRelation ]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:03'!
persistRelationOf: anObject at: anInstVarOffset with: aRelation

	| persistentRelation |
	
	persistentRelation := PersistentSet on: self from: aRelation.
	anObject instVarAt: anInstVarOffset put: persistentRelation! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 08:58:34'!
persistRelationsOf: anObject

	anObject class instVarNamesAndOffsetsDo: [ :anInstVarName :anInstVarOffset | self persistPossibleRelationOf: anObject at: anInstVarOffset]! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 11/14/2023 09:06:24'!
tableOfType: aType

	^ tables at: aType ifAbsentPut: [ Set new ]! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 11/14/2023 08:44:19'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.
	inTransaction := false.
	closed := false.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 11/14/2023 09:06:24'!
persist: anObject

	| table |

	self assertCanUseDatabase.
	self assertTypeIsPersisted: anObject class.
	self delay.
	
	table := self tableOfType: anObject class.
	self defineIdOf: anObject.
	table add: anObject.
	self persistRelationsOf: anObject.
! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:06:56'!
select: aCondition ofType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 11/14/2023 09:07:12'!
selectAllOfType: aType

	self assertCanUseDatabase.
	self assertTypeIsPersisted: aType.
	self delay.
	
	^(self tableOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


!classDefinition: #Environment category: 'CustomerImporter'!
Object subclass: #Environment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Environment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:41:06'!
createCustomerSystem

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Environment class' category: 'CustomerImporter'!
Environment class
	instanceVariableNames: ''!

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:37:10'!
current

	^(self subclasses detect: [ :anEnvironmentClass | anEnvironmentClass isCurrent ]) new! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentKey

	^ #ENV! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:46'!
environmentVariable

	^ Smalltalk at: self environmentKey! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:09'!
identifier

	self subclassResponsibility! !

!Environment class methodsFor: 'current' stamp: 'HAW 5/22/2022 21:41:36'!
isCurrent

	self subclassResponsibility ! !

!Environment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:46:01'!
makeCurrent

	"
	Tener en cuenta que en Smalltalk se podría poner directamente la clase de environment,
	esto es DevelopmentEnvironment o IntegrationEnvironmet o hasta una instancia de ellas,
	pero se está simulando el hecho de que esto esté definido por fuera del sistema, como una
	variable del sistema operativo - Hernan"
	
	Smalltalk at: self environmentKey put: self identifier! !


!classDefinition: #DevelopmentEnvironment category: 'CustomerImporter'!
Environment subclass: #DevelopmentEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DevelopmentEnvironment methodsFor: 'customer system' stamp: 'IB 11/27/2023 02:38:57'!
createCustomerSystem

	^TransientPartySystem new! !


!DevelopmentEnvironment methodsFor: 'supplierSystem' stamp: 'IB 11/27/2023 02:38:57'!
createSupplierSystem
	
	^TransientPartySystem new	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DevelopmentEnvironment class' category: 'CustomerImporter'!
DevelopmentEnvironment class
	instanceVariableNames: ''!

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:42:50'!
identifier

	^ #DEV! !

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:43:52'!
isCurrent

	"
	self makeCurrent
	"
	^self environmentVariable = self identifier! !


!classDefinition: #IntegrationEnvironment category: 'CustomerImporter'!
Environment subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!IntegrationEnvironment methodsFor: 'customer system' stamp: 'IB 11/27/2023 02:41:54'!
createCustomerSystem

	^PersistentPartySystem storingObjectsOfType: (Array with: Address with: Customer)! !


!IntegrationEnvironment methodsFor: 'supplier system' stamp: 'IB 11/27/2023 02:41:43'!
createSupplierSystem

	^PersistentPartySystem storingObjectsOfType: (Array with: Address with: Customer with: Supplier)! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IntegrationEnvironment class' category: 'CustomerImporter'!
IntegrationEnvironment class
	instanceVariableNames: ''!

!IntegrationEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:43:07'!
identifier

	^ #INT! !

!IntegrationEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:44:04'!
isCurrent

	"
	self makeCurrent
	"
	^self environmentVariable = self identifier! !


!classDefinition: #Party category: 'CustomerImporter'!
Object subclass: #Party
	instanceVariableNames: 'id firstName addresses identificationNumber identificationType'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Party methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:15:35'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Party methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:15:42'!
addresses

	^ addresses! !

!Party methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:15:08'!
firstName

	^firstName! !

!Party methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:16:20'!
identificationType

	^identificationType! !


!Party methodsFor: 'identification' stamp: 'IB 11/27/2023 01:15:51'!
identificationNumber

	^identificationNumber ! !


!Party methodsFor: 'addresses' stamp: 'IB 11/27/2023 01:16:48'!
addAddress: anAddress

	addresses add: anAddress ! !

!Party methodsFor: 'addresses' stamp: 'IB 11/27/2023 01:16:34'!
isAddressesEmpty

	^addresses isEmpty ! !


!Party methodsFor: 'initialization' stamp: 'IB 11/27/2023 01:22:07'!
initializeWithFirstName: aFirstName withIdentificationType: aIdentificationType andNumber: aIdentificationNumber

	addresses := OrderedCollection new.
	firstName := aFirstName.
	identificationNumber := aIdentificationNumber.
	identificationType := aIdentificationType! !


!classDefinition: #Customer category: 'CustomerImporter'!
Party subclass: #Customer
	instanceVariableNames: 'lastName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !


!Customer methodsFor: 'initialization' stamp: 'IB 11/27/2023 01:22:59'!
initializeWithFirstName: aFirstName
			andLast: aLastName
			withIdentificationType: aIdentificationType
			andNumber: aIdentificationNumber

	self initializeWithFirstName: aFirstName withIdentificationType: aIdentificationType andNumber: aIdentificationNumber.
	lastName := aLastName! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'CustomerImporter'!
Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'instance creation' stamp: 'IB 11/27/2023 01:19:45'!
withFirstName: aFirstName
			andLast: aLastName
			withIdentificationType: aIdentificationType
			andNumber: aIdentificationNumber
			
			^self new initializeWithFirstName: aFirstName
			andLast: aLastName
			withIdentificationType: aIdentificationType
			andNumber: aIdentificationNumber! !


!classDefinition: #Supplier category: 'CustomerImporter'!
Party subclass: #Supplier
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Supplier methodsFor: 'initialization' stamp: 'IB 11/27/2023 01:22:36'!
initializeNamed: aName withIdentificationType: anIdentificationType andNumber: anIdentificationNumber

	self initializeWithFirstName: aName withIdentificationType: anIdentificationType andNumber: anIdentificationNumber.
	customers := OrderedCollection new! !


!Supplier methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:27:52'!
addCustomer: aCustomer

	customers add: aCustomer! !

!Supplier methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:31:33'!
customerWithIdentificationType: aIdentificationType andNumber: aIdentificationNumber ifNone: aBlock

 	^customers detect: [ :customer |  customer identificationType = aIdentificationType and: [customer identificationNumber = aIdentificationNumber]] ifNone: aBlock! !

!Supplier methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:12:23'!
customers
	
	^customers! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Supplier class' category: 'CustomerImporter'!
Supplier class
	instanceVariableNames: ''!

!Supplier class methodsFor: 'instance creation' stamp: 'IB 11/27/2023 00:12:04'!
named: aName withIdentificationType: anIdentificationType andNumber: anIdentificationNumber

	^self new initializeNamed: aName withIdentificationType: anIdentificationType andNumber: anIdentificationNumber ! !


!classDefinition: #PartyImporter category: 'CustomerImporter'!
Object subclass: #PartyImporter
	instanceVariableNames: 'record readStream line'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PartyImporter methodsFor: 'evaluating - private' stamp: 'IB 11/27/2023 01:54:13'!
hasLineToImport

	line := readStream nextLine.
	^line notNil! !


!PartyImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:55:43'!
assertPartyWasImported

	self subclassResponsibility! !

!PartyImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:59:26'!
assertRecordNotEmpty

	record isEmpty ifTrue: [ self error: self class invalidRecordTypeErrorDescription ]! !

!PartyImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:54:44'!
createRecord

	^ record := line findTokens: $,! !

!PartyImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:57:49'!
importAddress

	|address|
	
	self assertPartyWasImported.
	self assertValidAddressRecord.
	
	address := Address new.
	self newParty addAddress: address.
	address streetName: record second.
	address streetNumber: record third asNumber .
	address town: record fourth.
	address zipCode: record fifth asNumber.
	address province: record sixth! !

!PartyImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:59:46'!
isAddressRecord

	^ record first = 'A'! !

!PartyImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:57:38'!
newParty

	self subclassResponsibility! !


!PartyImporter methodsFor: 'address' stamp: 'IB 11/27/2023 01:58:09'!
assertValidAddressRecord

	^ record size ~= 6 ifTrue: [ self error: self class invalidAddressRecordErrorDescription ]! !


!PartyImporter methodsFor: 'evaluating' stamp: 'IB 11/27/2023 02:32:13'!
importRecord

	self subclassResponsibility ! !

!PartyImporter methodsFor: 'evaluating' stamp: 'IB 11/27/2023 02:08:16'!
value

	[self hasLineToImport] whileTrue:[
		self createRecord.
		self assertRecordNotEmpty.
		self importRecord]! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
PartyImporter subclass: #CustomerImporter
	instanceVariableNames: 'newCustomer customerSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'IB 11/27/2023 02:12:13'!
initializeFrom: aReadStream into: aCustomerSystem

	readStream := aReadStream.
	customerSystem := aCustomerSystem ! !



!CustomerImporter methodsFor: 'customer' stamp: 'HAW 5/22/2022 19:59:39'!
assertValidCustomerRecord

	^ record size ~= 5 ifTrue: [ self error: self class invalidCustomerRecordErrorDescription ]! !

!CustomerImporter methodsFor: 'customer' stamp: 'IB 11/27/2023 02:30:00'!
decodeNewCustomer

	newCustomer := 
		Customer 
			withFirstName: record second 
			andLast: record third 
			withIdentificationType: record fourth 
			andNumber: record fifth.
	customerSystem add: newCustomer! !

!CustomerImporter methodsFor: 'customer' stamp: 'IB 11/27/2023 02:33:22'!
importCustomer

	self assertValidCustomerRecord.

	self decodeNewCustomer! !

!CustomerImporter methodsFor: 'customer' stamp: 'HAW 5/22/2022 19:23:55'!
isCustomerRecord

	^ record first = 'C'! !


!CustomerImporter methodsFor: 'address' stamp: 'HAW 5/22/2022 19:58:41'!
assertCustomerWasImported

	^ newCustomer ifNil: [ self error: self class canNotImportAddressWithoutCustomerErrorDescription ]! !

!CustomerImporter methodsFor: 'address' stamp: 'IB 11/27/2023 01:55:34'!
assertPartyWasImported
	
	^self assertCustomerWasImported! !

!CustomerImporter methodsFor: 'address' stamp: 'IB 11/27/2023 01:57:24'!
newParty

	^newCustomer! !


!CustomerImporter methodsFor: 'evaluating - private' stamp: 'IB 11/27/2023 02:33:22'!
importRecord

	self isCustomerRecord ifTrue: [ ^self importCustomer].
	self isAddressRecord ifTrue: [ ^self importAddress ].

	self error: self class invalidRecordTypeErrorDescription! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 21:15:35'!
from: aReadStream into: aCustomerSystem

	^self new initializeFrom: aReadStream into: aCustomerSystem! !


!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 21:15:52'!
valueFrom: aReadStream into: aCustomerSystem

	^(self from: aReadStream into: aCustomerSystem) value! !


!CustomerImporter class methodsFor: 'error messages' stamp: 'HAW 5/22/2022 19:13:48'!
canNotImportAddressWithoutCustomerErrorDescription

	^'Cannot import address without customer'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'HAW 5/22/2022 19:41:39'!
invalidAddressRecordErrorDescription

	^'Address record has to have six fields'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'HAW 5/22/2022 19:53:56'!
invalidCustomerRecordErrorDescription

	^'Invalid Customer record'! !

!CustomerImporter class methodsFor: 'error messages' stamp: 'HAW 5/22/2022 19:24:11'!
invalidRecordTypeErrorDescription

	^'Invalid record type'! !


!classDefinition: #SupplierImporter category: 'CustomerImporter'!
CustomerImporter subclass: #SupplierImporter
	instanceVariableNames: 'supplierSystem newSupplier'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierImporter methodsFor: 'initialization' stamp: 'IB 11/27/2023 02:12:13'!
initializeFrom: aReadStream into: aSupplierSystem workingWith: aCustomerSystem

	readStream := aReadStream.
	supplierSystem := aSupplierSystem.
	customerSystem := aCustomerSystem! !


!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:55:15'!
assertPartyWasImported

	^ self assertSupplierWasImported! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:06:51'!
assertSupplierWasImported

	^ newSupplier ifNil: [ self error: self class canNotImportWithoutSupplierErrorDescription ]! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 02:55:17'!
assertValidSupplierRecord

	^ record size ~= 4 ifTrue: [self error: self class invalidSupplierRecordErrorDescription] ! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 02:47:44'!
decodeNewCustomer

	self assertSupplierWasImported.
	
	[newCustomer := 
		customerSystem 
			partyOfType: Customer withIdentificationType: record fourth 
			andNumber: record fifth] on: Error do: [super decodeNewCustomer].
		
	newSupplier addCustomer: newCustomer! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 02:23:20'!
importRecord
	
	self isSupplierRecord ifTrue: [ ^self importSupplier ].
	super importRecord! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 02:53:09'!
importSupplier

	self assertValidSupplierRecord.
	
	newSupplier := 
		Supplier 
			named: record second
			withIdentificationType: record third 
			andNumber: record fourth.
			
	supplierSystem add: newSupplier! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 02:25:57'!
isCustomerRecord

	^ self isExistingCustomerRecord or: [self isNewCustomerRecord]! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:40:15'!
isExistingCustomerRecord

	^ record first = 'EC'! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:00:09'!
isNewCustomerRecord

	^ record first = 'NC'! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 00:08:01'!
isSupplierRecord

	^ record first = 'S'! !

!SupplierImporter methodsFor: 'accessing' stamp: 'IB 11/27/2023 01:57:04'!
newParty

	^newSupplier! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SupplierImporter class' category: 'CustomerImporter'!
SupplierImporter class
	instanceVariableNames: ''!

!SupplierImporter class methodsFor: 'error' stamp: 'IB 11/27/2023 01:07:04'!
canNotImportWithoutSupplierErrorDescription
	
	^'Cannot import without supplier'! !

!SupplierImporter class methodsFor: 'error' stamp: 'IB 11/26/2023 23:36:59'!
invalidRecordTypeErrorDescription

	^'Invalid record type'! !

!SupplierImporter class methodsFor: 'error' stamp: 'IB 11/27/2023 02:52:10'!
invalidSupplierRecordErrorDescription
	
	^'No es un record valido para supplier'! !


!SupplierImporter class methodsFor: 'instance creation' stamp: 'IB 11/27/2023 01:02:37'!
from: aReadStream into: aSupplierSystem workingWith: aCustomerSystem

	^self new initializeFrom: aReadStream into: aSupplierSystem workingWith: aCustomerSystem! !


!SupplierImporter class methodsFor: 'importing' stamp: 'IB 11/27/2023 01:03:19'!
valueFrom: aReadStream into: aSupplierSystem workingWith: aCustomerSystem

	^(self from: aReadStream into: aSupplierSystem workingWith: aCustomerSystem) value! !


!classDefinition: #PartySystem category: 'CustomerImporter'!
Object subclass: #PartySystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PartySystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:17:57'!
add: aCustomer

	self subclassResponsibility ! !

!PartySystem methodsFor: 'customers' stamp: 'IB 11/27/2023 02:45:29'!
numberOfPartiesOfType: aClass

	self subclassResponsibility ! !

!PartySystem methodsFor: 'customers' stamp: 'IB 11/27/2023 02:47:44'!
partyOfType: aClass withIdentificationType: anIdType andNumber: anIdNumber

	self subclassResponsibility ! !


!PartySystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:04'!
beginTransaction

	self subclassResponsibility ! !

!PartySystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:16'!
commit

	self subclassResponsibility ! !


!PartySystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:10'!
start

	self subclassResponsibility ! !

!PartySystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:13'!
stop

	self subclassResponsibility ! !


!classDefinition: #PersistentPartySystem category: 'CustomerImporter'!
PartySystem subclass: #PersistentPartySystem
	instanceVariableNames: 'session classes'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentPartySystem methodsFor: 'initialization' stamp: 'IB 11/27/2023 02:40:32'!
initializeStoringObjectsOfType: aCollectionOfClasses

	classes := aCollectionOfClasses! !


!PersistentPartySystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:14:14'!
add: aCustomer

	^session persist: aCustomer ! !

!PersistentPartySystem methodsFor: 'customers' stamp: 'IB 11/27/2023 02:45:32'!
numberOfPartiesOfType: aClass

	^(session selectAllOfType: aClass) size! !

!PersistentPartySystem methodsFor: 'customers' stamp: 'IB 11/27/2023 02:47:48'!
partyOfType: aClass withIdentificationType: anIdType andNumber: anIdNumber

	^(session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: aClass) anyOne! !


!PersistentPartySystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:12:39'!
beginTransaction

	session beginTransaction.
! !

!PersistentPartySystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:13:00'!
commit

	session commit ! !


!PersistentPartySystem methodsFor: 'system lifecycle' stamp: 'IB 11/27/2023 02:41:07'!
start

	session := DataBaseSession for: classes
	! !

!PersistentPartySystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 20:13:10'!
stop

	session close! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentPartySystem class' category: 'CustomerImporter'!
PersistentPartySystem class
	instanceVariableNames: ''!

!PersistentPartySystem class methodsFor: 'instance creation' stamp: 'IB 11/27/2023 02:39:51'!
storingObjectsOfType: aCollectionOfClasses

	^self new initializeStoringObjectsOfType: aCollectionOfClasses! !


!classDefinition: #TransientPartySystem category: 'CustomerImporter'!
PartySystem subclass: #TransientPartySystem
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientPartySystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:21:06'!
start

	customers := OrderedCollection new! !

!TransientPartySystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:23:17'!
stop

	customers := nil! !


!TransientPartySystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:21:20'!
beginTransaction

	! !

!TransientPartySystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:23:01'!
commit

	! !


!TransientPartySystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:21:32'!
add: aCustomer

	customers add: aCustomer ! !

!TransientPartySystem methodsFor: 'customers' stamp: 'IB 11/27/2023 02:45:29'!
numberOfPartiesOfType: aClass

	^customers size! !

!TransientPartySystem methodsFor: 'customers' stamp: 'IB 11/27/2023 02:47:44'!
partyOfType: aClass withIdentificationType: anIdType andNumber: anIdNumber

	^customers detect: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]! !

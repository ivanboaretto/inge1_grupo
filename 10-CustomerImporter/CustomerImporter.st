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


!classDefinition: #SupplierImportTest category: 'CustomerImporter'!
TestCase subclass: #SupplierImportTest
	instanceVariableNames: 'supplierSystem customerSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierImportTest methodsFor: 'data' stamp: 'TAO 11/23/2023 21:17:18'!
unChabonData
	^ReadStream on:'C,Alberto,Rodriguez,D,5456774'! !

!SupplierImportTest methodsFor: 'data' stamp: 'TAO 11/24/2023 10:44:41'!
validImportData
	^ReadStream on: 
'S,Supplier1,D,123
NC,Pepe,Sanchez,D,22333444
EC,D,5456774
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires'! !


!SupplierImportTest methodsFor: 'setUp/tearDown' stamp: 'TAO 11/24/2023 11:01:37'!
setUp

	supplierSystem := Environment current createSupplierSystem.
	supplierSystem start.
	supplierSystem beginTransaction.
	customerSystem := Environment current createCustomerSystem.
	customerSystem start.
	customerSystem beginTransaction.
! !

!SupplierImportTest methodsFor: 'setUp/tearDown' stamp: 'TAO 11/24/2023 11:02:12'!
tearDown
	supplierSystem commit.
	supplierSystem stop.
	
	customerSystem commit.
	customerSystem stop.
	! !


!SupplierImportTest methodsFor: 'tests' stamp: 'TAO 11/24/2023 10:46:21'!
assertAddressImportedCorrectly: supplier

	self assert: supplier addresses size equals:2.
	ZCustomerImportTest new assertAddressOf: supplier at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	ZCustomerImportTest new assertAddressOf: supplier at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'! !

!SupplierImportTest methodsFor: 'tests' stamp: 'TAO 11/24/2023 10:53:52'!
assertCustomersImportedCorrectly: supplier

	self assert: supplier customers size equals:2.
	self assertCustomersOf: supplier firstNamed: 'Pepe' secondNamed: 'Sanchez' withIdType: 'D' withIdNumber:'22333444'.
	self assertCustomersOf: supplier firstNamed: 'Alberto' secondNamed: 'Rodriguez' withIdType: 'D' withIdNumber:'5456774'.
	! !

!SupplierImportTest methodsFor: 'tests' stamp: 'TAO 11/24/2023 10:50:07'!
assertSupplierIsImportedCorrectly

	| supplier |
	supplier:=(supplierSystem partyWithIdentificationType:  'D' number:'123').
	self assert: supplier firstName equals: 'Supplier1'.
	self assertAddressImportedCorrectly: supplier.
	self assertCustomersImportedCorrectly: supplier! !

!SupplierImportTest methodsFor: 'tests' stamp: 'TAO 11/24/2023 10:50:10'!
test01ValidDataIsImportedCorrectly
	
	CustomerImporter valueFrom: self unChabonData into: customerSystem.
	SupplierImporter valueFrom: self validImportData into: supplierSystem using:customerSystem.
	
	self assert: supplierSystem numberOfSuppliers equals:1.
	self assertSupplierIsImportedCorrectly.
	
	! !


!SupplierImportTest methodsFor: 'support' stamp: 'TAO 11/24/2023 10:59:18'!
assertCustomersOf: supplier firstNamed: aFirstName secondNamed: aLastName withIdType: anIdType withIdNumber: anIdNumber 
		supplier customers size = 0 ifTrue:[self fail].
	supplier customers 
		detect:[:customer| 
			customer firstName = aFirstName and:
			customer lastName = aLastName and:
			customer identificationType = anIdType and:
			customer identificationNumber = anIdNumber]
		ifNone:[self fail]
! !


!classDefinition: #ZCustomerImportTest category: 'CustomerImporter'!
TestCase subclass: #ZCustomerImportTest
	instanceVariableNames: 'system'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ZCustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 21:15:52'!
test01ValidDataIsImportedCorrectly

	CustomerImporter valueFrom: self validImportData into: system..

	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ZCustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 21:15:52'!
test02CanNotImportAddressWithoutCustomer

	self
		should: [ CustomerImporter valueFrom: self addressWithoutCustomerData into: system. ]
		raise: Error - MessageNotUnderstood
		withMessageText: CustomerImporter canNotImportAddressWithoutCustomerErrorDescription

	! !

!ZCustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test03DoesNotImportRecordsStartingWithCButMoreCharacters

	self
		shouldFailImporting: self invalidCustomerRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ZCustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:03'!
test04DoesNotImportRecordsStartingWithAButMoreCharacters

	self
		shouldFailImporting: self invalidAddressRecordStartData
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ZCustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:49:36'!
test05CanNotImportAddressRecordWithLessThanSixFields

	self
		shouldFailImporting: self addressRecordWithLessThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ZCustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:51:14'!
test06CanNotImportAddressRecordWithMoreThanSixFields

	self
		shouldFailImporting: self addressRecordWithMoreThanSixFields
		messageText: CustomerImporter invalidAddressRecordErrorDescription
		asserting: [ self assertImportedOneCustomerWithoutAddress ]

	! !

!ZCustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test07CanNotImportCustomerRecordWithLessThanFiveFields

	self
		shouldFailImporting: self customerRecordWithLessThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ZCustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 19:56:58'!
test08CanNotImportCustomerRecordWithMoreThanFiveFields

	self
		shouldFailImporting: self customerRecordWithMoreThanFiveFields
		messageText: CustomerImporter invalidCustomerRecordErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !

!ZCustomerImportTest methodsFor: 'tests' stamp: 'HAW 5/22/2022 20:01:43'!
test09CannotImportEmptyLine

	self
		shouldFailImporting: self emptyLine
		messageText: CustomerImporter invalidRecordTypeErrorDescription
		asserting: [ self assertNoCustomerWasImported ]

	! !


!ZCustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince

	| importedAddress |

	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ZCustomerImportTest methodsFor: 'assertions' stamp: 'TAO 11/23/2023 21:01:13'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName

	| importedCustomer |

	importedCustomer := system partyWithIdentificationType: anIdType number: anIdNumber.

	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer

	! !

!ZCustomerImportTest methodsFor: 'assertions' stamp: 'TAO 11/24/2023 11:09:00'!
assertImportedOneCustomerWithoutAddress

	| importedCustomer |

	self assert: 1 equals: system numberOfCustomers.
	importedCustomer := system partyWithIdentificationType: 'D' number: '22333444'.
	self assert: importedCustomer isAddressesEmpty
	! !

!ZCustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: system numberOfCustomers! !

!ZCustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA'
	! !

!ZCustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:33:24'!
assertNoCustomerWasImported

	^ self assert: 0 equals: system numberOfCustomers! !

!ZCustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |

	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.


	! !

!ZCustomerImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 21:15:52'!
shouldFailImporting: aReadStream messageText: anErrorMessageText asserting: anAssertionBlock

	self
		should: [ CustomerImporter valueFrom: aReadStream into: system. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anErrorMessageText equals: anError messageText.
			anAssertionBlock value ]

	! !


!ZCustomerImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 21:36:16'!
setUp

	system := Environment current createCustomerSystem.
	system start.
	system beginTransaction.
! !

!ZCustomerImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 20:12:16'!
tearDown

	system commit.
	system stop
	! !


!ZCustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:41:20'!
addressRecordWithLessThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636'! !

!ZCustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:51:35'!
addressRecordWithMoreThanSixFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs,x'! !

!ZCustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:14:13'!
addressWithoutCustomerData

	^ReadStream on: 'A,San Martin,3322,Olivos,1636,BsAs'! !

!ZCustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:53:41'!
customerRecordWithLessThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D'! !

!ZCustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:55:59'!
customerRecordWithMoreThanFiveFields

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444,x'! !

!ZCustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 20:02:57'!
emptyLine

	^ReadStream on: '
'! !

!ZCustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:34:25'!
invalidAddressRecordStartData

	^ReadStream on: 'C,Pepe,Sanchez,D,22333444
AA,San Martin,3322,Olivos,1636,BsAs'! !

!ZCustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 19:22:55'!
invalidCustomerRecordStartData

	^ReadStream on: 'CC,Pepe,Sanchez,D,22333444'! !

!ZCustomerImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


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


!classDefinition: #CSVImporter category: 'CustomerImporter'!
Object subclass: #CSVImporter
	instanceVariableNames: 'readStream system record line'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CSVImporter methodsFor: 'evaluating' stamp: 'TAO 11/24/2023 11:15:20'!
value
	[ self hasLineToImport ] whileTrue: [
		self createRecord.
		self importRecord ].
	! !


!CSVImporter methodsFor: 'evaluating - private' stamp: 'TAO 11/24/2023 11:14:01'!
createRecord

	^ record := line findTokens: $,! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'TAO 11/24/2023 11:14:48'!
hasLineToImport

	line := readStream nextLine.
	^line notNil! !

!CSVImporter methodsFor: 'evaluating - private' stamp: 'TAO 11/24/2023 11:13:56'!
importRecord

	self subclassResponsibility! !


!classDefinition: #PartyImporter category: 'CustomerImporter'!
CSVImporter subclass: #PartyImporter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PartyImporter methodsFor: 'evaluating - private' stamp: 'TAO 11/23/2023 20:06:21'!
assertRecordNotEmpty

	record isEmpty ifTrue: [ self error: self class invalidRecordTypeErrorDescription ]! !


!PartyImporter methodsFor: 'address' stamp: 'TAO 11/24/2023 11:33:10'!
assertValidAddressRecord
^self failWithErrorDescription:  self class invalidAddressRecordErrorDescription ifRecordSizeIsNot:6 ! !

!PartyImporter methodsFor: 'address' stamp: 'TAO 11/23/2023 20:07:12'!
isAddressRecord

	^ record first = 'A'! !


!PartyImporter methodsFor: 'customer' stamp: 'TAO 11/24/2023 11:33:27'!
assertValidCustomerRecord
^self failWithErrorDescription: self class invalidCustomerRecordErrorDescription ifRecordSizeIsNot:5 
	! !


!PartyImporter methodsFor: 'supplier' stamp: 'TAO 11/24/2023 11:35:08'!
failWithErrorDescription: anErrorDescription ifRecordSizeIsNot: size
	
	^ record size ~= size ifTrue: [self error: anErrorDescription]! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PartyImporter class' category: 'CustomerImporter'!
PartyImporter class
	instanceVariableNames: ''!

!PartyImporter class methodsFor: 'error messages' stamp: 'TAO 11/23/2023 20:32:52'!
canNotImportAddressWithoutCustomerErrorDescription

	^'Cannot import address without customer'! !

!PartyImporter class methodsFor: 'error messages' stamp: 'TAO 11/23/2023 20:32:55'!
invalidAddressRecordErrorDescription

	^'Address record has to have six fields'! !

!PartyImporter class methodsFor: 'error messages' stamp: 'TAO 11/23/2023 20:32:58'!
invalidCustomerRecordErrorDescription

	^'Invalid Customer record'! !

!PartyImporter class methodsFor: 'error messages' stamp: 'TAO 11/23/2023 20:33:00'!
invalidRecordTypeErrorDescription

	^'Invalid record type'! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
PartyImporter subclass: #CustomerImporter
	instanceVariableNames: 'newCustomer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'TAO 11/23/2023 20:33:55'!
initializeFrom: aReadStream into: aCustomerSystem

	readStream := aReadStream.
	system := aCustomerSystem ! !


!CustomerImporter methodsFor: 'customer' stamp: 'TAO 11/23/2023 20:12:35'!
importCustomer

	self assertValidCustomerRecord.

	newCustomer := Customer new.
	newCustomer firstName: record second.
	newCustomer lastName: record third.
	newCustomer identificationType: record fourth.
	newCustomer identificationNumber: record fifth.
	system add: newCustomer! !

!CustomerImporter methodsFor: 'customer' stamp: 'HAW 5/22/2022 19:23:55'!
isCustomerRecord

	^ record first = 'C'! !


!CustomerImporter methodsFor: 'address' stamp: 'TAO 11/24/2023 11:11:21'!
assertCustomerWasImported

	^ newCustomer ifNil: [ self error: self class canNotImportAddressWithoutCustomerErrorDescription ]! !

!CustomerImporter methodsFor: 'address' stamp: 'HAW 5/22/2022 19:59:12'!
importAddress

	| newAddress |

	self assertCustomerWasImported.
	self assertValidAddressRecord.

	newAddress := Address new.
	newCustomer addAddress: newAddress.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth! !


!CustomerImporter methodsFor: 'evaluating - private' stamp: 'TAO 11/23/2023 20:12:35'!
importRecord

	self assertRecordNotEmpty.

	self isCustomerRecord ifTrue: [ ^self importCustomer ].
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


!classDefinition: #SupplierImporter category: 'CustomerImporter'!
PartyImporter subclass: #SupplierImporter
	instanceVariableNames: 'newSupplier customerSystem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!SupplierImporter methodsFor: 'evaluating - private' stamp: 'TAO 11/23/2023 20:18:11'!
importRecord

	self assertRecordNotEmpty.

	self isCustomerRecord ifTrue: [ ^self importCustomer ].
	self isAddressRecord ifTrue: [ ^self importAddress ].
	self isSupplierRecord ifTrue: [ ^self importSupplier ].

	self error: self class invalidRecordTypeErrorDescription! !


!SupplierImporter methodsFor: 'address' stamp: 'TAO 11/23/2023 20:13:34'!
importAddress

	| newAddress |

	self assertCustomerWasImported.
	self assertValidAddressRecord.

	newAddress := Address new.
	newAddress streetName: record second.
	newAddress streetNumber: record third asNumber .
	newAddress town: record fourth.
	newAddress zipCode: record fifth asNumber .
	newAddress province: record sixth.
	newSupplier addAddress: newAddress.! !


!SupplierImporter methodsFor: 'customer' stamp: 'TAO 11/23/2023 20:07:46'!
assertCustomerWasImported

	^ newSupplier ifNil: [ self error: self class canNotImportAddressWithoutCustomerErrorDescription ]! !

!SupplierImporter methodsFor: 'customer' stamp: 'TAO 11/24/2023 11:34:08'!
assertValidExistingCustomerRecord.	^self failWithErrorDescription: self class invalidCustomerRecordErrorDescription ifRecordSizeIsNot: 3
! !

!SupplierImporter methodsFor: 'customer' stamp: 'TAO 11/23/2023 20:57:34'!
importCustomer
	record first = 'EC' ifTrue:[ ^self importExistingCustomer].
	record first = 'NC' ifTrue:[^self importNonExistingCustomer].
	self shouldNotHappen ! !

!SupplierImporter methodsFor: 'customer' stamp: 'TAO 11/24/2023 10:23:24'!
importExistingCustomer
	
	| newCustomer |
	self assertValidExistingCustomerRecord.
	newCustomer := customerSystem 
		partyWithIdentificationType: record second
		number: record third.
	
	
	newSupplier addCustomer: newCustomer! !

!SupplierImporter methodsFor: 'customer' stamp: 'TAO 11/23/2023 20:14:21'!
importNonExistingCustomer
	
	| newCustomer |
	self assertValidCustomerRecord.

	newCustomer := Customer new.
	newCustomer firstName: record second.
	newCustomer lastName: record third.
	newCustomer identificationType: record fourth.
	newCustomer identificationNumber: record fifth.
	customerSystem add: newCustomer.
	newSupplier addCustomer: newCustomer! !

!SupplierImporter methodsFor: 'customer' stamp: 'TAO 11/23/2023 20:18:01'!
isCustomerRecord

	^ record first = 'NC' or: record first = 'EC'! !


!SupplierImporter methodsFor: 'supplier' stamp: 'TAO 11/24/2023 11:34:25'!
assertValidSupplierRecord
	
	^ self failWithErrorDescription:  self class invalidSupplierRecordErrorDescription ifRecordSizeIsNot: 4! !

!SupplierImporter methodsFor: 'supplier' stamp: 'TAO 11/23/2023 20:54:58'!
importSupplier


	self assertValidSupplierRecord.

	newSupplier := Supplier new.
	newSupplier firstName: record second.
	newSupplier identificationType: record third.
	newSupplier identificationNumber: record fourth.
	system add: newSupplier! !

!SupplierImporter methodsFor: 'supplier' stamp: 'TAO 11/23/2023 20:49:53'!
isSupplierRecord
	^record first = 'S'! !


!SupplierImporter methodsFor: 'initialization' stamp: 'TAO 11/23/2023 20:57:05'!
initializeFrom: aReadStream into: aSupplierSystem using:aCustomerSystem

	readStream := aReadStream.
	system := aSupplierSystem.
	customerSystem:=aCustomerSystem .
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SupplierImporter class' category: 'CustomerImporter'!
SupplierImporter class
	instanceVariableNames: ''!

!SupplierImporter class methodsFor: 'as yet unclassified' stamp: 'TAO 11/23/2023 20:33:30'!
from: aReadStream into: aSupplierSystem using: aCustomerSystem

	^self new initializeFrom: aReadStream into: aSupplierSystem using: aCustomerSystem! !

!SupplierImporter class methodsFor: 'as yet unclassified' stamp: 'TAO 11/23/2023 20:39:02'!
invalidSupplierRecordErrorDescription
	
	^'Supplier record has to have five fields'! !

!SupplierImporter class methodsFor: 'as yet unclassified' stamp: 'TAO 11/23/2023 20:32:36'!
valueFrom: aReadStream into: aSupplierSystem using: aCustomerSystem

	^(self from: aReadStream into: aSupplierSystem using: aCustomerSystem) value! !


!classDefinition: #CustomerSystem category: 'CustomerImporter'!
Object subclass: #CustomerSystem
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:17:57'!
add: aCustomer

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:18:51'!
numberOfCustomers

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'customers' stamp: 'TAO 11/23/2023 21:01:13'!
partyWithIdentificationType: anIdType number: anIdNumber

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:04'!
beginTransaction

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:18:16'!
commit

	self subclassResponsibility ! !


!CustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:10'!
start

	self subclassResponsibility ! !

!CustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 21:18:13'!
stop

	self subclassResponsibility ! !


!classDefinition: #PersistentCustomerSystem category: 'CustomerImporter'!
CustomerSystem subclass: #PersistentCustomerSystem
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:14:14'!
add: aCustomer

	^session persist: aCustomer ! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'HAW 5/22/2022 21:08:47'!
numberOfCustomers

	^(session selectAllOfType: Customer) size! !

!PersistentCustomerSystem methodsFor: 'customers' stamp: 'TAO 11/23/2023 21:01:13'!
partyWithIdentificationType: anIdType number: anIdNumber

	^(session
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!PersistentCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:12:39'!
beginTransaction

	session beginTransaction.
! !

!PersistentCustomerSystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 20:13:00'!
commit

	session commit ! !


!PersistentCustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 11/14/2023 09:21:54'!
start

	session := DataBaseSession for: (Array with: Address with: Customer).
	! !

!PersistentCustomerSystem methodsFor: 'system lifecycle' stamp: 'HAW 5/22/2022 20:13:10'!
stop

	session close! !


!classDefinition: #TransientPartySystem category: 'CustomerImporter'!
CustomerSystem subclass: #TransientPartySystem
	instanceVariableNames: 'parties'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientPartySystem methodsFor: 'system lifecycle' stamp: 'TAO 11/23/2023 20:49:12'!
start

	parties := OrderedCollection new! !

!TransientPartySystem methodsFor: 'system lifecycle' stamp: 'TAO 11/23/2023 20:49:12'!
stop

	parties := nil! !


!TransientPartySystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:21:20'!
beginTransaction

	! !

!TransientPartySystem methodsFor: 'transactions' stamp: 'HAW 5/22/2022 21:23:01'!
commit

	! !


!TransientPartySystem methodsFor: 'customers' stamp: 'TAO 11/23/2023 20:49:17'!
add: aParty

	parties add: aParty ! !

!TransientPartySystem methodsFor: 'customers' stamp: 'TAO 11/24/2023 11:09:33'!
numberOfCustomers
	^self numberOfParties! !

!TransientPartySystem methodsFor: 'customers' stamp: 'TAO 11/23/2023 21:01:13'!
partyWithIdentificationType: anIdType number: anIdNumber

	^parties detect: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]! !


!TransientPartySystem methodsFor: 'suppliers' stamp: 'TAO 11/24/2023 11:09:24'!
numberOfParties

	^ parties size! !

!TransientPartySystem methodsFor: 'suppliers' stamp: 'TAO 11/24/2023 11:09:24'!
numberOfSuppliers
	^self numberOfParties! !


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

!DevelopmentEnvironment methodsFor: 'customer system' stamp: 'TAO 11/23/2023 20:48:57'!
createCustomerSystem

	^TransientPartySystem new! !

!DevelopmentEnvironment methodsFor: 'customer system' stamp: 'TAO 11/23/2023 20:48:57'!
createSupplierSystem

	^TransientPartySystem new! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DevelopmentEnvironment class' category: 'CustomerImporter'!
DevelopmentEnvironment class
	instanceVariableNames: ''!

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'HAW 11/23/2023 16:42:50'!
identifier

	^ #DEV! !

!DevelopmentEnvironment class methodsFor: 'current' stamp: 'TAO 11/24/2023 10:18:51'!
isCurrent
	self makeCurrent.
	^self environmentVariable = self identifier! !


!classDefinition: #IntegrationEnvironment category: 'CustomerImporter'!
Environment subclass: #IntegrationEnvironment
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!IntegrationEnvironment methodsFor: 'customer system' stamp: 'HAW 5/22/2022 21:40:48'!
createCustomerSystem

	^PersistentCustomerSystem new! !

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
	instanceVariableNames: 'id firstName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Party methodsFor: 'addresses' stamp: 'TAO 11/23/2023 20:22:39'!
addAddress: anAddress

	addresses add: anAddress ! !

!Party methodsFor: 'addresses' stamp: 'TAO 11/23/2023 20:22:42'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Party methodsFor: 'addresses' stamp: 'TAO 11/23/2023 20:22:47'!
addresses

	^ addresses! !

!Party methodsFor: 'addresses' stamp: 'TAO 11/23/2023 20:23:17'!
isAddressesEmpty

	^addresses isEmpty ! !


!Party methodsFor: 'name' stamp: 'TAO 11/23/2023 20:22:50'!
firstName

	^firstName ! !

!Party methodsFor: 'name' stamp: 'TAO 11/23/2023 20:22:57'!
firstName: aName

	firstName := aName! !


!Party methodsFor: 'identification' stamp: 'TAO 11/23/2023 20:23:00'!
identificationNumber

	^identificationNumber ! !

!Party methodsFor: 'identification' stamp: 'TAO 11/23/2023 20:23:04'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Party methodsFor: 'identification' stamp: 'TAO 11/23/2023 20:23:10'!
identificationType

	^identificationType ! !

!Party methodsFor: 'identification' stamp: 'TAO 11/23/2023 20:23:12'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Party methodsFor: 'initialization' stamp: 'TAO 11/23/2023 20:23:15'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!classDefinition: #Customer category: 'CustomerImporter'!
Party subclass: #Customer
	instanceVariableNames: 'lastName'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'name' stamp: 'TAO 11/23/2023 20:52:03'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'TAO 11/23/2023 20:52:09'!
lastName: aLastName

	lastName := aLastName
! !


!classDefinition: #Supplier category: 'CustomerImporter'!
Party subclass: #Supplier
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Supplier methodsFor: 'as yet unclassified' stamp: 'TAO 11/23/2023 20:26:44'!
addCustomer: aCustomer
	customers add: aCustomer! !

!Supplier methodsFor: 'as yet unclassified' stamp: 'TAO 11/23/2023 20:24:07'!
customers 
	^customers! !

!Supplier methodsFor: 'as yet unclassified' stamp: 'TAO 11/23/2023 20:24:48'!
initialize 

	super initialize.
	customers:= OrderedCollection new.
	! !

!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'repository'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'IB 11/22/2023 21:31:18'!
test01ImportValidData
	
	self importReadingFrom: self validImportData.
	
	self assertAmountOfCustomersRegisteredIs: 2.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'IB 11/22/2023 21:36:45'!
test02CantImportLineStartingWithInvalidLineType
	
	self 
		importReadingFrom: self invalidImportDataBecauseOfInvalidLineType 
		shouldFailWithMessageText: CustomerImporter invalidBeginOfLineErrorDescription
		thenExecute: [self assertOnlyOneCustomerRegisteredWithoutAddresses]
	
		
	
	! !

!ImportTest methodsFor: 'tests' stamp: 'IB 11/22/2023 21:35:12'!
test03ImportWorksUntilCustomerMissingField
	
	self 
		importReadingFrom: self invalidImportDataBecauseOfCustomerMissingField 
		shouldFailWithMessageText: CustomerImporter missingFieldErrorDescription 
		thenExecute: [self assertOnlyOneCustomerRegisteredWithoutAddresses]
		
	 
	
	
		
	
	! !

!ImportTest methodsFor: 'tests' stamp: 'IB 11/22/2023 21:35:27'!
test04ImportWorksUntilAddressMissingField
	
	self 
		importReadingFrom: self invalidImportDataBecauseOfAddressMissingField 
		shouldFailWithMessageText: CustomerImporter missingFieldErrorDescription 
		thenExecute: [self assertOnlyOneCustomerRegisteredWithoutAddresses]
	
		
	
	! !

!ImportTest methodsFor: 'tests' stamp: 'IB 11/22/2023 21:35:42'!
test05ImportFailWhenDataIsEmpty
	
	self 
		importReadingFrom: self emptyData 
		shouldFailWithMessageText: CustomerImporter noImportDataErrorDescription 
		thenExecute: [self assertNoCustomerRegistered]! !

!ImportTest methodsFor: 'tests' stamp: 'IB 11/22/2023 21:35:56'!
test06ImportFailWithDataWithAddressBeforeCustomer
	
	self 
		importReadingFrom: self invalidImportDataBecauseOfAddressWithNoCustomer 
		shouldFailWithMessageText: CustomerImporter noCustomerErrorDescription 
		thenExecute: [self assertNoCustomerRegistered]! !


!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:22:05'!
assertAddressOf: importedCustomer at: aStreetName hasNumber: aNumber town: aTown zipCode: aZipCode province: aProvince      

	| importedAddress |
		
	importedAddress := importedCustomer addressAt: aStreetName ifNone: [ self fail ].
	self assert: aStreetName equals: importedAddress streetName.
	self assert: aNumber equals: importedAddress streetNumber.
	self assert: aTown equals: importedAddress town.
	self assert: aZipCode equals: importedAddress zipCode.
	self assert: aProvince equals: importedAddress province.

	! !

!ImportTest methodsFor: 'assertions' stamp: 'IB 11/22/2023 21:27:41'!
assertAmountOfCustomersRegisteredIs: anAmountOfCustomers

	self assert: anAmountOfCustomers equals: (self repository selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:27:57'!
assertCustomerWithIdentificationType: anIdType number: anIdNumber hasFirstName: aFirstName lastName: aLastName   

	| importedCustomer |
	
	importedCustomer := self customerWithIdentificationType: anIdType number: anIdNumber.
		
	self assert: aFirstName equals: importedCustomer firstName.
	self assert: aLastName equals: importedCustomer lastName.
	self assert: anIdType equals: importedCustomer identificationType.
	self assert: anIdNumber equals: importedCustomer identificationNumber.

	^importedCustomer 
	
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |
		
	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA' 
	! !

!ImportTest methodsFor: 'assertions' stamp: 'IB 11/22/2023 21:27:30'!
assertNoCustomerRegistered

	self assertAmountOfCustomersRegisteredIs: 0! !

!ImportTest methodsFor: 'assertions' stamp: 'IB 11/22/2023 21:27:13'!
assertOnlyOneCustomerRegisteredWithoutAddresses

	| importedCustomer | 
	
	self assertAmountOfCustomersRegisteredIs: 1.
	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assert: importedCustomer addresses size equals: 0! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |
	
	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.
	
	
	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'IB 11/22/2023 21:28:31'!
setUp

	self setUpRepository
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'IB 11/22/2023 21:29:13'!
setUpRepository

	repository := TransientRepository new! !


!ImportTest methodsFor: 'customer' stamp: 'IB 11/22/2023 21:00:57'!
customerWithIdentificationType: anIdType number: anIdNumber 

	^ (self repository 
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!ImportTest methodsFor: 'test data' stamp: 'IB 11/22/2023 21:42:59'!
emptyData

	^ReadStream on: ''! !

!ImportTest methodsFor: 'test data' stamp: 'TAO 11/20/2023 19:32:50'!
invalidImportDataBecauseOfAddressMissingField
	^ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'IB 11/22/2023 21:45:45'!
invalidImportDataBecauseOfAddressWithNoCustomer
	
	^ ReadStream on: 
'A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'TAO 11/20/2023 19:31:48'!
invalidImportDataBecauseOfCustomerMissingField
	^ ReadStream on: 
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'TAO 11/20/2023 16:04:05'!
invalidImportDataBecauseOfInvalidLineType
	^ ReadStream on: 
'C,Pepe,Sanchez,D,22333444
B,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'HAW 5/22/2022 18:08:08'!
validImportData

	^ ReadStream on: 
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos,1636,BsAs
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !


!ImportTest methodsFor: 'support' stamp: 'IB 11/22/2023 21:20:32'!
importReadingFrom: aStream

	^ CustomerImporter valueReadingFrom: aStream storingInto: self repository! !

!ImportTest methodsFor: 'support' stamp: 'IB 11/22/2023 21:43:21'!
importReadingFrom: aStream shouldFailWithMessageText: aMessageErrorDescription thenExecute: aBlock  
	
	self 
		should: [self importReadingFrom: aStream ]
		raise: Error - MessageNotUnderstood 
		withMessageText: aMessageErrorDescription.
	
	aBlock value! !


!ImportTest methodsFor: 'accessing' stamp: 'IB 11/22/2023 21:16:44'!
repository
	
	^repository! !


!classDefinition: #PersistentImportTest category: 'CustomerImporter'!
ImportTest subclass: #PersistentImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentImportTest methodsFor: 'setUp/tearDown' stamp: 'IB 11/22/2023 21:29:01'!
setUp
	
	self setUpSession.
	super setUp! !

!PersistentImportTest methodsFor: 'setUp/tearDown' stamp: 'IB 11/22/2023 21:29:21'!
setUpRepository
	
	repository := PersistentRepository workingWith: session! !

!PersistentImportTest methodsFor: 'setUp/tearDown' stamp: 'IB 11/22/2023 21:30:08'!
setUpSession

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction! !

!PersistentImportTest methodsFor: 'setUp/tearDown' stamp: 'IB 11/22/2023 21:29:54'!
tearDown

	session commit.
	session close.
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


!Address methodsFor: 'initialization' stamp: 'TAO 11/20/2023 15:32:19'!
initializeWithStreetName: anStreetName withStreetNumber: aStreetNumber placedAtTown:aTown withZipCode: aZipCode inProvince:aProvince

	streetName := anStreetName .
	streetNumber := aStreetNumber  .
	town := aTown.
	zipCode := aZipCode.
	province := aProvince
	 .! !


!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 17:55:46'!
isAt: aStreetName

	^streetName = aStreetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetName

	^streetName ! !

!Address methodsFor: 'street' stamp: 'HAW 5/22/2022 00:19:29'!
streetNumber

	^streetNumber ! !


!Address methodsFor: 'town' stamp: 'HAW 5/22/2022 00:19:29'!
town

	^town! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Address class' category: 'CustomerImporter'!
Address class
	instanceVariableNames: ''!

!Address class methodsFor: 'as yet unclassified' stamp: 'TAO 11/20/2023 15:21:23'!
withStreetName: anStreetName withStreetNumber: aStreetNumber placedAtTown:aTown withZipCode: aZipCode inProvince:aProvince

	^self new initializeWithStreetName: anStreetName withStreetNumber: aStreetNumber placedAtTown:aTown withZipCode: aZipCode inProvince:aProvince! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress 

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 17:55:17'!
addressAt: aStreetName ifNone: aNoneBlock

	^addresses detect: [ :address | address isAt: aStreetName ] ifNone: aNoneBlock ! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName
	
	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber
	
	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType
	
	^identificationType ! !


!Customer methodsFor: 'initialization' stamp: 'TAO 11/20/2023 15:29:27'!
initializeWithFirstName: aFirstName withLastName: aSecondName withIdentificationType: anIdType withIdentificationNumber: anIdNumber 
	super initialize.
	addresses := OrderedCollection new.
	firstName := aFirstName.
	lastName := aSecondName.
	identificationType := anIdType.
	identificationNumber := anIdNumber.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Customer class' category: 'CustomerImporter'!
Customer class
	instanceVariableNames: ''!

!Customer class methodsFor: 'instance creation' stamp: 'TAO 11/20/2023 15:26:56'!
withFirstName: aFirstName withLastName: aSecondName withIdentificationType: anIdType withIdentificationNumber: anIdNumber 
	
	^self new initializeWithFirstName: aFirstName withLastName: aSecondName withIdentificationType: anIdType withIdentificationNumber: anIdNumber ! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'repository readStream newCustomer decodingProcedures line data'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'IB 11/22/2023 20:40:25'!
initializeReadingFrom: aReadStream storingInto: aRepository

	repository := aRepository.
	readStream := aReadStream
	! !


!CustomerImporter methodsFor: 'asserting' stamp: 'IB 11/22/2023 21:40:06'!
assertValidAddressData

	^data size < 6 ifTrue: [self error: self class missingFieldErrorDescription]! !

!CustomerImporter methodsFor: 'asserting' stamp: 'IB 11/22/2023 21:53:09'!
assertValidCustomerData

	^data size < 5 ifTrue: [self error: self class missingFieldErrorDescription]! !


!CustomerImporter methodsFor: 'address' stamp: 'IB 11/22/2023 20:16:32'!
addressBasedOn: addressData
	
	^ Address 
		withStreetName: addressData second  
		withStreetNumber: addressData third asNumber 
		placedAtTown:  addressData fourth 
		withZipCode: addressData fifth asNumber 
		inProvince: addressData sixth.
	
	! !

!CustomerImporter methodsFor: 'address' stamp: 'IB 11/22/2023 20:16:32'!
importAddress

	self assertValidAddressData.
	newCustomer addAddress: (self addressBasedOn: data)! !

!CustomerImporter methodsFor: 'address' stamp: 'IB 11/22/2023 20:16:44'!
lineIsForDecodingAddresses

	^ data first = 'A'! !


!CustomerImporter methodsFor: 'customer' stamp: 'TAO 11/20/2023 18:56:49'!
createNewCustomerBasedOn: customerData

	^ Customer 
		withFirstName: customerData second
		withLastName: customerData third
		withIdentificationType: customerData fourth
 		withIdentificationNumber: customerData fifth! !

!CustomerImporter methodsFor: 'customer' stamp: 'IB 11/22/2023 20:43:45'!
importCustomer

	self assertValidCustomerData.
	newCustomer := self createNewCustomerBasedOn: data.
	repository store: newCustomer! !

!CustomerImporter methodsFor: 'customer' stamp: 'IB 11/22/2023 20:17:06'!
lineIsForDecodingCustomer

	^ data first = 'C'! !


!CustomerImporter methodsFor: 'evaluating--private' stamp: 'IB 11/22/2023 20:13:49'!
canKeepImporting

	line := readStream nextLine.
	^ line notNil! !

!CustomerImporter methodsFor: 'evaluating--private' stamp: 'IB 11/22/2023 21:38:27'!
importData
	
	(self lineIsForDecodingCustomer) ifTrue: [^self importCustomer].
	(self lineIsForDecodingAddresses) ifTrue: [^self importAddress].
	self error: self class invalidBeginOfLineErrorDescription! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'IB 11/22/2023 21:50:06'!
value
	
	[self canKeepImporting] whileTrue: [
		data := line findTokens: $,.
		self importData]
			
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'IB 11/22/2023 21:52:25'!
readingFrom: aReadStream storingInto: aRepository

	self assertDataIsNotEmpty: aReadStream.
	self assertFirstLineIsForCustomer: aReadStream.
	
	^self new initializeReadingFrom: aReadStream storingInto: aRepository! !


!CustomerImporter class methodsFor: 'importing' stamp: 'IB 11/22/2023 20:39:56'!
valueReadingFrom: aReadStream storingInto: aRepository

	^(self readingFrom: aReadStream storingInto: aRepository) value! !


!CustomerImporter class methodsFor: 'error' stamp: 'IB 11/22/2023 21:36:45'!
invalidBeginOfLineErrorDescription
		
	^'invalid begin of line'! !

!CustomerImporter class methodsFor: 'error' stamp: 'IB 11/22/2023 21:38:50'!
missingFieldErrorDescription
	
	^'missing field'! !

!CustomerImporter class methodsFor: 'error' stamp: 'IB 11/22/2023 21:44:47'!
noCustomerErrorDescription
	
	^'no customer imported'! !

!CustomerImporter class methodsFor: 'error' stamp: 'IB 11/22/2023 21:40:51'!
noImportDataErrorDescription
	
	^'no data!!!!!!'! !


!CustomerImporter class methodsFor: 'asserting' stamp: 'IB 11/22/2023 21:52:14'!
assertDataIsNotEmpty: aStream

	aStream isEmpty ifTrue: [self error: self class noImportDataErrorDescription]! !

!CustomerImporter class methodsFor: 'asserting' stamp: 'IB 11/22/2023 21:51:03'!
assertFirstLineIsForCustomer: aStream
	
	aStream contents first = $C ifFalse: [self error: self class noCustomerErrorDescription]! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id inTransaction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'IB 11/22/2023 20:32:46'!
commit

	(tables at: Customer ifAbsent:[^self]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
	! !


!DataBaseSession methodsFor: 'closing' stamp: 'HAW 5/22/2022 00:19:29'!
close
	
	! !


!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
defineIdOf: anObject

	anObject instVarNamed: 'id' put: (self newIdFor: anObject).! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
delay

	(Delay forMilliseconds: 100) wait! !

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 00:19:29'!
persistAddressesOf: anObjectWithAddresses

	anObjectWithAddresses addresses do: [ :anAddress | self persist: anAddress ]
	! !


!DataBaseSession methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initializeFor: aConfiguration

	configuration := aConfiguration.
	tables := Dictionary new.
	id := 0.! !


!DataBaseSession methodsFor: 'id' stamp: 'HAW 5/22/2022 00:19:29'!
newIdFor: anObject

	id := id + 1.
	^id! !


!DataBaseSession methodsFor: 'persistance' stamp: 'HAW 5/22/2022 00:19:29'!
persist: anObject

	| table |
	
	self delay.
	table := tables at: anObject class ifAbsentPut: [ Set new ].
	
	self defineIdOf: anObject.
	table add: anObject.
	
	(anObject isKindOf: Customer) ifTrue: [ self persistAddressesOf: anObject ].! !


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 00:19:29'!
select: aCondition ofType: aType

	self delay.
	^(tables at: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'TAO 11/20/2023 16:09:23'!
selectAllOfType: aType

	self delay.
	^(tables at: aType ifAbsent:[OrderedCollection new]) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !


!classDefinition: #Repository category: 'CustomerImporter'!
Object subclass: #Repository
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Repository methodsFor: 'querying' stamp: 'IB 11/22/2023 21:05:19'!
select: aOneArgBlock ofType: aClass

	self subclassResponsibility! !

!Repository methodsFor: 'querying' stamp: 'IB 11/22/2023 21:05:34'!
selectAllOfType: aClass

	self subclassResponsibility! !


!Repository methodsFor: 'storing' stamp: 'IB 11/22/2023 21:05:46'!
store: anObject

	self subclassResponsibility! !


!classDefinition: #PersistentRepository category: 'CustomerImporter'!
Repository subclass: #PersistentRepository
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!PersistentRepository methodsFor: 'initialization' stamp: 'IB 11/22/2023 20:43:33'!
initializeWorkingWith: aSession 
	
	session := aSession! !


!PersistentRepository methodsFor: 'storing' stamp: 'IB 11/22/2023 20:44:13'!
store: anObject

	session persist: anObject! !


!PersistentRepository methodsFor: 'querying' stamp: 'IB 11/22/2023 21:03:50'!
select: aOneArgBlock ofType: Customer

	^session select: aOneArgBlock ofType: Customer! !

!PersistentRepository methodsFor: 'querying' stamp: 'IB 11/22/2023 21:03:14'!
selectAllOfType: aClass

	^session selectAllOfType: aClass! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PersistentRepository class' category: 'CustomerImporter'!
PersistentRepository class
	instanceVariableNames: ''!

!PersistentRepository class methodsFor: 'instance creation' stamp: 'IB 11/22/2023 20:43:11'!
workingWith: aSession 

	^self new initializeWorkingWith: aSession ! !


!classDefinition: #TransientRepository category: 'CustomerImporter'!
Repository subclass: #TransientRepository
	instanceVariableNames: 'elements'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!TransientRepository methodsFor: 'storing' stamp: 'IB 11/22/2023 21:06:33'!
initialize
	
	elements := Set new! !

!TransientRepository methodsFor: 'storing' stamp: 'IB 11/22/2023 21:06:33'!
store: anObject 
	
	elements add: anObject! !


!TransientRepository methodsFor: 'querying' stamp: 'IB 11/22/2023 21:01:58'!
select: aOneArgBlock ofType: aClass

	^(self selectAllOfType: aClass) select: aOneArgBlock! !

!TransientRepository methodsFor: 'querying' stamp: 'IB 11/22/2023 21:06:33'!
selectAllOfType: aClass

	^elements select: [:storedObject | storedObject class = aClass]! !

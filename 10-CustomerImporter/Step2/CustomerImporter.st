!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'tests' stamp: 'TAO 11/20/2023 18:57:23'!
test01ImportValidData
	
	CustomerImporter valueFrom: self validImportData into: session.
	
	self assertImportedRightNumberOfCustomers.
	self assertPepeSanchezWasImportedCorrecty.
	self assertJuanPerezWasImportedCorrectly ! !

!ImportTest methodsFor: 'tests' stamp: 'TAO 11/20/2023 19:50:21'!
test02ImportWorksUntilLineStartsWithOutCOrA
	
	| importedCustomer |
	self 
		import: self invalidImportDataBecauseOfInvalidLineType into: session
		shouldFailWithMessageText:CustomerImporter invalidLineErrorDescription.
		
	 self assert: 1 equals: (session selectAllOfType: Customer) size.
	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assert:importedCustomer addresses size equals:0.
	
	
		
	
	! !

!ImportTest methodsFor: 'tests' stamp: 'TAO 11/20/2023 19:50:21'!
test03ImportWorksUntilCustomerMissingField
	
	| importedCustomer |
	self 
		import: self invalidImportDataBecauseOfCustomerMissingField into: session
		shouldFailWithMessageText:CustomerImporter invalidLineErrorDescription.
		
	 self assert: 1 equals: (session selectAllOfType: Customer) size.
	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assert:importedCustomer addresses size equals:0.
	
	
		
	
	! !

!ImportTest methodsFor: 'tests' stamp: 'TAO 11/20/2023 19:50:21'!
test04ImportWorksUntilAddressMissingField
	
	| importedCustomer |
	self 
		import: self invalidImportDataBecauseOfAddressMissingField into: session
		shouldFailWithMessageText:CustomerImporter invalidLineErrorDescription.
		
	 self assert: 1 equals: (session selectAllOfType: Customer) size.
	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assert:importedCustomer addresses size equals:0.
	
	
		
	
	! !

!ImportTest methodsFor: 'tests' stamp: 'TAO 11/20/2023 19:50:21'!
test05ImportFailWhenDataIsEmpty
	
	
	self 
		import: self emptyData into: session
		shouldFailWithMessageText:CustomerImporter invalidLineErrorDescription.
		
	 self assert: 0 equals: (session selectAllOfType: Customer) size.
	
	
	
		
	
	! !

!ImportTest methodsFor: 'tests' stamp: 'TAO 11/20/2023 19:50:21'!
test06ImportFailWithDataWithAddressBeforeCustomer
	
	
	self 
		import: self invalidImportDataBecauseOfAddressWithNoCustomer into: session
		shouldFailWithMessageText:CustomerImporter invalidLineErrorDescription.
		
	 self assert: 0 equals: (session selectAllOfType: Customer) size.
	
	
	
		
	
	! !


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

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:12:18'!
assertImportedRightNumberOfCustomers

	^ self assert: 2 equals: (session selectAllOfType: Customer) size! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:45'!
assertJuanPerezWasImportedCorrectly

	| importedCustomer |
		
	importedCustomer := self assertCustomerWithIdentificationType: 'C' number: '23-25666777-9' hasFirstName: 'Juan' lastName: 'Perez'.
	self assertAddressOf: importedCustomer at: 'Alem' hasNumber: 1122 town: 'CABA' zipCode: 1001 province: 'CABA' 
	! !

!ImportTest methodsFor: 'assertions' stamp: 'HAW 5/22/2022 18:28:05'!
assertPepeSanchezWasImportedCorrecty

	| importedCustomer |
	
	importedCustomer := self assertCustomerWithIdentificationType: 'D' number: '22333444' hasFirstName: 'Pepe' lastName: 'Sanchez'.
	self assertAddressOf: importedCustomer at: 'San Martin' hasNumber: 3322 town: 'Olivos' zipCode: 1636 province: 'BsAs'.
	self assertAddressOf: importedCustomer at: 'Maipu' hasNumber: 888 town: 'Florida' zipCode: 1122 province: 'Buenos Aires'.
	
	
	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:27:50'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'HAW 5/22/2022 00:28:23'!
tearDown

	session commit.
	session close.
	! !


!ImportTest methodsFor: 'customer' stamp: 'HAW 5/22/2022 18:14:22'!
customerWithIdentificationType: anIdType number: anIdNumber 

	^ (session 
		select: [ :aCustomer | aCustomer identificationType = anIdType and: [ aCustomer identificationNumber = anIdNumber ]]
		ofType: Customer) anyOne! !


!ImportTest methodsFor: 'test data' stamp: 'TAO 11/20/2023 19:24:35'!
emptyData
	^ReadStream on:' '.! !

!ImportTest methodsFor: 'test data' stamp: 'TAO 11/20/2023 19:32:50'!
invalidImportDataBecauseOfAddressMissingField
	^ReadStream on:
'C,Pepe,Sanchez,D,22333444
A,San Martin,3322,Olivos
A,Maipu,888,Florida,1122,Buenos Aires
C,Juan,Perez,C,23-25666777-9
A,Alem,1122,CABA,1001,CABA'! !

!ImportTest methodsFor: 'test data' stamp: 'TAO 11/20/2023 16:07:59'!
invalidImportDataBecauseOfAddressWithNoCustomer
	
	^ ReadStream on: 
'
A,San Martin,3322,Olivos,1636,BsAs
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


!ImportTest methodsFor: 'support' stamp: 'TAO 11/20/2023 19:50:20'!
import: aData into: aSession shouldFailWithMessageText: aMessageErrorDescription 
	self 
		should:[CustomerImporter valueFrom: aData into: aSession.]
		raise: Error-MessageNotUnderstood 
		withMessageText: aMessageErrorDescription.! !


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
	instanceVariableNames: 'session readStream newCustomer decodingProcedures line data'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'TAO 11/20/2023 18:57:04'!
initializeFrom: aReadStream into: aSession
	session := aSession.
	readStream := aReadStream.
	! !


!CustomerImporter methodsFor: 'asserting' stamp: 'TAO 11/20/2023 19:13:51'!
assertDataIsNotEmpty

	^ data isEmpty ifTrue:[self error: self class invalidLineErrorDescription ]! !

!CustomerImporter methodsFor: 'asserting' stamp: 'TAO 11/20/2023 19:22:46'!
assertValidAddressData

	^data size < 6 ifTrue: [self error: self class invalidLineErrorDescription]! !

!CustomerImporter methodsFor: 'asserting' stamp: 'TAO 11/20/2023 19:22:50'!
assertValidCustomerData

	^data size < 5 ifTrue: [self error: self class invalidLineErrorDescription]! !


!CustomerImporter methodsFor: 'address' stamp: 'TAO 11/20/2023 18:56:39'!
createNewAddressBasedOn: addressData
	
	^ Address 
		withStreetName: addressData second  
		withStreetNumber: addressData third asNumber 
		placedAtTown:  addressData fourth 
		withZipCode: addressData fifth asNumber 
		inProvince: addressData sixth.
	
	! !

!CustomerImporter methodsFor: 'address' stamp: 'TAO 11/20/2023 19:12:40'!
importAddress
	self assertValidAddressData.
	newCustomer addAddress: (self createNewAddressBasedOn: data)! !

!CustomerImporter methodsFor: 'address' stamp: 'TAO 11/20/2023 18:56:00'!
lineIsForDecodingAddresses
	^ data first = 'A'! !


!CustomerImporter methodsFor: 'customer' stamp: 'TAO 11/20/2023 18:56:49'!
createNewCustomerBasedOn: customerData

	^ Customer 
		withFirstName: customerData second
		withLastName: customerData third
		withIdentificationType: customerData fourth
 		withIdentificationNumber: customerData fifth! !

!CustomerImporter methodsFor: 'customer' stamp: 'TAO 11/20/2023 19:11:54'!
importCustomer
	self assertValidCustomerData.
	newCustomer := self createNewCustomerBasedOn: data.
	session persist: newCustomer! !

!CustomerImporter methodsFor: 'customer' stamp: 'TAO 11/20/2023 19:08:57'!
lineIsForDecodingCustomer
	^ data first = 'C'! !


!CustomerImporter methodsFor: 'evaluating--private' stamp: 'TAO 11/20/2023 18:49:11'!
canKeepImporting
	line := readStream nextLine.
	^ line notNil! !

!CustomerImporter methodsFor: 'evaluating--private' stamp: 'TAO 11/20/2023 19:14:56'!
importData
	
	(self lineIsForDecodingCustomer) ifTrue: [^self importCustomer].
	(self lineIsForDecodingAddresses) ifTrue: [^self importAddress].
	self error: self class invalidLineErrorDescription! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'TAO 11/20/2023 19:15:02'!
value 
	[ self canKeepImporting] whileTrue: [
		data := line findTokens: $,.
		self assertDataIsNotEmpty.
		self importData.
		].
			
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 18:06:47'!
from: aReadStream into: aSession
	^self new initializeFrom: aReadStream into: aSession! !


!CustomerImporter class methodsFor: 'importing' stamp: 'HAW 5/22/2022 18:11:27'!
valueFrom: aReadStream into: aSession

	^(self from: aReadStream into: aSession) value! !


!CustomerImporter class methodsFor: 'error' stamp: 'TAO 11/20/2023 16:02:59'!
invalidLineErrorDescription
	^'invalid begin of line'! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id inTransaction'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'TAO 11/20/2023 16:19:58'!
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

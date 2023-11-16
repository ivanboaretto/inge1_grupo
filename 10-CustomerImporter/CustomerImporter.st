!classDefinition: #AddressTest category: 'CustomerImporter'!
TestCase subclass: #AddressTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!AddressTest methodsFor: 'accessing' stamp: 'IB 11/16/2023 16:36:24'!
address

	^ Address new 
		streetName: 'Calle Falsa';
		streetNumber: 123;
		town: 'Springfield';
		zipCode: 123;
		province: 'Buenos Aires'! !


!AddressTest methodsFor: 'tests' stamp: 'IB 11/16/2023 16:36:50'!
testEquality

	|address sameAddress|
	
	address := self address.
	sameAddress := self address.
	
	self assert: address equals: sameAddress! !


!classDefinition: #CustomerImportTest category: 'CustomerImporter'!
TestCase subclass: #CustomerImportTest
	instanceVariableNames: 'session pepe juan pepeAddresses juanAddresses calleSanMartin calleMaipu calleAlem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImportTest methodsFor: 'assertions' stamp: 'IB 11/16/2023 11:20:50'!
assertThat: aCustomer isIn: storedCustomers

	^ self 
		assertThersIsACustomerIn: storedCustomers 
		withIdentificationType: aCustomer identificationType 
		andNumber: aCustomer identificationNumber
		thenDo: [:storedCustomer | 
			self 
				assert: storedCustomer equals: aCustomer;
				assert: storedCustomer addresses equals: aCustomer addresses]! !

!CustomerImportTest methodsFor: 'assertions' stamp: 'IB 11/16/2023 10:42:54'!
assertThersIsACustomerIn: aCustomersCollection withIdentificationType: aCustomerIdentificationType andNumber: aCustomerIdentificationNumber thenDo: aBlock

	^ aCustomersCollection 
		detect: [:customer | 
			customer identificationType = aCustomerIdentificationType and: [
				customer identificationNumber = aCustomerIdentificationNumber]]
		ifFound: aBlock 
		ifNone: [self fail]! !


!CustomerImportTest methodsFor: 'support' stamp: 'IB 11/16/2023 11:16:26'!
importCustomersFrom: inputData

	^ (CustomerImporter importingFrom: session registeringTo: inputData) import! !

!CustomerImportTest methodsFor: 'support' stamp: 'IB 11/16/2023 11:11:53'!
withRegisteredCustomersDo: aOneArgBlock

	aOneArgBlock value: (session selectAllOfType: Customer)
	
	
	
	! !


!CustomerImportTest methodsFor: 'tests' stamp: 'IB 11/16/2023 11:54:21'!
testCustomerImport
	
	self importCustomersFrom: self inputData.
	
	self withRegisteredCustomersDo: [:storedCustomers |
		self assert: storedCustomers size equals: 2.
		self 
			assertThat: self customer isIn: storedCustomers;
			assertThat: self anotherCustomer isIn: storedCustomers]
	
	
	
	! !


!CustomerImportTest methodsFor: 'running' stamp: 'IB 11/16/2023 10:53:46'!
setUp

	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction! !

!CustomerImportTest methodsFor: 'running' stamp: 'IB 11/16/2023 10:53:51'!
tearDown

	session commit.
	session close! !


!CustomerImportTest methodsFor: 'addresses' stamp: 'IB 11/16/2023 10:49:33'!
addressAtStreet: aStreetName numbered: aStreetNumber inTown: aTown withZIPCode: aZIPCode onProvince: aProvince

	^ Address new 
		streetName: aStreetName;
		streetNumber: aStreetNumber;
		town: aTown;
		zipCode: aZIPCode;
		province: aProvince! !

!CustomerImportTest methodsFor: 'addresses' stamp: 'IB 11/16/2023 10:52:00'!
alemAddress
	
	^ self 
		addressAtStreet: 'Alem' 
		numbered: 1122 
		inTown: 'CABA' 
		withZIPCode: 1001 
		onProvince: 'CABA'! !

!CustomerImportTest methodsFor: 'addresses' stamp: 'IB 11/16/2023 11:01:13'!
anotherCustomerAddresses

	^ OrderedCollection with: self alemAddress! !

!CustomerImportTest methodsFor: 'addresses' stamp: 'IB 11/16/2023 10:53:14'!
customerAddresses

	^ OrderedCollection with: self sanMartinAddress with: self maipuAddress! !

!CustomerImportTest methodsFor: 'addresses' stamp: 'IB 11/16/2023 10:51:51'!
maipuAddress

	^ self 
		addressAtStreet: 'Maipu' 
		numbered: 888 
		inTown: 'Florida' 
		withZIPCode: 1122 
		onProvince: 'Buenos Aires'! !

!CustomerImportTest methodsFor: 'addresses' stamp: 'IB 11/16/2023 10:52:11'!
sanMartinAddress

	^ self 
		addressAtStreet: 'San Martin' 
		numbered: 3322 
		inTown: 'Olivos' 
		withZIPCode: 1636 
		onProvince: 'BsAs'! !


!CustomerImportTest methodsFor: 'customers' stamp: 'IB 11/16/2023 11:19:40'!
anotherCustomer
	 
	^self 
		customerWithFirstName: 'Juan' 
		andLastName: 'Perez' 
		withIdentificationOfType: 'C' 
		andNumber: '23-25666777-9' 
		withRegisteredAddresses: self anotherCustomerAddresses! !

!CustomerImportTest methodsFor: 'customers' stamp: 'IB 11/16/2023 11:19:32'!
customer

	 ^self 
		customerWithFirstName: 'Pepe' 
		andLastName: 'Sanchez' 
		withIdentificationOfType: 'D' 
		andNumber: '22333444' 
		withRegisteredAddresses: self customerAddresses! !

!CustomerImportTest methodsFor: 'customers' stamp: 'IB 11/16/2023 11:14:06'!
customerWithFirstName: aCustomerFirstName andLastName: aCustomerLastName withIdentificationOfType: anIdentificationType andNumber: anIdentificationNumber withRegisteredAddresses: anAddressCollection 
	 
	^ Customer new 
		firstName: aCustomerFirstName;
		lastName: aCustomerLastName;
		identificationType: anIdentificationType;
		identificationNumber: anIdentificationNumber;
		addAddressesIn: anAddressCollection
	! !


!CustomerImportTest methodsFor: 'data' stamp: 'IB 11/16/2023 11:52:53'!
importerEntryForAddress: anAddress

	^((OrderedCollection
		with: anAddress streetName 
		with: anAddress streetNumber
		with: anAddress town
		with: anAddress zipCode
		with: anAddress province ) 
			inject: 'A' 
			into: [:previousString :customerData | previousString asString, ',' , customerData asString]) ,String lfString
! !

!CustomerImportTest methodsFor: 'data' stamp: 'IB 11/16/2023 11:52:40'!
importerEntryForCustomer: customer

	^((OrderedCollection
		with: customer firstName 
		with: customer lastName 
		with: customer identificationType 
		with: customer identificationNumber) 
			inject: 'C' 
			into: [:previousString :customerData | previousString, ',' , customerData]), String lfString
! !

!CustomerImportTest methodsFor: 'data' stamp: 'IB 11/16/2023 11:53:19'!
inputData

	^ ReadStream on: 
		(self importerEntryForCustomer: self customer),
		(self importerEntryForAddress: self sanMartinAddress),
		(self importerEntryForAddress: self maipuAddress),
		(self importerEntryForCustomer: self anotherCustomer),
		(self importerEntryForAddress: self alemAddress)! !


!classDefinition: #CustomerTest category: 'CustomerImporter'!
TestCase subclass: #CustomerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerTest methodsFor: 'accessing' stamp: 'IB 11/16/2023 16:39:10'!
customer
	
	^Customer new 
		firstName: 'Pepe';
		lastName: 'Argento';
		identificationType: 'D';
		identificationNumber: 3482305923;
		yourself
	! !


!CustomerTest methodsFor: 'tests' stamp: 'IB 11/16/2023 16:37:58'!
testEquality

	|customer sameCustomer|
	
	customer := self customer.
	sameCustomer := self customer.
	
	self assert: customer equals: sameCustomer! !


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


!Address methodsFor: 'testing' stamp: 'TAO 11/16/2023 03:19:41'!
=aStreetToCompareTo
	^(streetName = aStreetToCompareTo streetName and: 
	streetNumber = aStreetToCompareTo streetNumber and: 
	town = aStreetToCompareTo town and: 
	zipCode = aStreetToCompareTo zipCode and: 
	province = aStreetToCompareTo province).
	
	! !

!Address methodsFor: 'testing' stamp: 'IB 11/16/2023 16:42:10'!
hash

	^ (((zipCode hash bitXor: province hash) 
		bitXor: streetName hash) 
		bitXor: streetNumber hash)
		bitXor: town hash! !


!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode

	^zipCode! !

!Address methodsFor: 'zip code' stamp: 'HAW 5/22/2022 00:19:29'!
zipCode: aZipCode

	zipCode := aZipCode! !


!classDefinition: #Customer category: 'CustomerImporter'!
Object subclass: #Customer
	instanceVariableNames: 'id firstName lastName identificationType identificationNumber addresses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addAddress: anAddress

	addresses add: anAddress ! !

!Customer methodsFor: 'addresses' stamp: 'IB 11/16/2023 11:14:29'!
addAddressesIn: anAddressCollection

	addresses addAll: anAddressCollection! !

!Customer methodsFor: 'addresses' stamp: 'HAW 5/22/2022 00:19:29'!
addresses

	^ addresses! !


!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName

	^firstName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
firstName: aName

	firstName := aName! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName

	^lastName ! !

!Customer methodsFor: 'name' stamp: 'HAW 5/22/2022 00:19:29'!
lastName: aLastName

	lastName := aLastName
! !


!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber

	^identificationNumber ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationNumber: anIdentificationNumber

	identificationNumber := anIdentificationNumber! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType

	^identificationType ! !

!Customer methodsFor: 'identification' stamp: 'HAW 5/22/2022 00:19:29'!
identificationType: anIdentificationType

	identificationType := anIdentificationType! !


!Customer methodsFor: 'initialization' stamp: 'HAW 5/22/2022 00:19:29'!
initialize

	super initialize.
	addresses := OrderedCollection new.! !


!Customer methodsFor: 'testing' stamp: 'TAO 11/16/2023 03:17:38'!
= aCustomerToCompareTo
	^(firstName = aCustomerToCompareTo firstName and:  
	lastName = aCustomerToCompareTo lastName and: 
	identificationNumber = aCustomerToCompareTo identificationNumber and: 
	identificationType = aCustomerToCompareTo identificationType).! !

!Customer methodsFor: 'testing' stamp: 'IB 11/16/2023 16:42:00'!
hash

	^ (((firstName hash bitXor: lastName hash) 
		bitXor: identificationType hash) 
		bitXor: identificationNumber hash)! !


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'stream session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'IB 11/16/2023 11:16:06'!
initializeImportingFrom: anStream registeringTo: aSession 

	stream := anStream.
	session := aSession
	! !


!CustomerImporter methodsFor: 'evaluating' stamp: 'TAO 11/16/2023 03:32:40'!
import

	| newCustomer line |
	
	line := stream nextLine.
	[ line notNil ] whileTrue: [
		(line beginsWith: 'C') ifTrue: [ | customerData |
			customerData := line findTokens: $,.
			newCustomer := Customer new.
			newCustomer firstName: customerData second.
			newCustomer lastName: customerData third.
			newCustomer identificationType: customerData fourth.
			newCustomer identificationNumber: customerData fifth.
			session persist: newCustomer ].

		(line beginsWith: 'A') ifTrue: [ | addressData newAddress |
			addressData := line findTokens: $,.
			newAddress := Address new.
			newCustomer addAddress: newAddress.
			newAddress streetName: addressData second.
			newAddress streetNumber: addressData third asNumber .
			newAddress town: addressData fourth.
			newAddress zipCode: addressData fifth asNumber .
			newAddress province: addressData sixth.
			].

		line := stream nextLine. ].
	stream close.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerImporter class' category: 'CustomerImporter'!
CustomerImporter class
	instanceVariableNames: ''!

!CustomerImporter class methodsFor: 'instance creation' stamp: 'IB 11/16/2023 11:16:30'!
importingFrom: anInputStream registeringTo: aSession 

	^self new initializeImportingFrom: aSession registeringTo: anInputStream ! !


!classDefinition: #DataBaseSession category: 'CustomerImporter'!
Object subclass: #DataBaseSession
	instanceVariableNames: 'configuration tables id'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 00:19:29'!
beginTransaction

	! !

!DataBaseSession methodsFor: 'transaction management' stamp: 'HAW 5/22/2022 19:17:36'!
commit

	(tables at: Customer ifAbsent: [#()]) do: [ :aCustomer | self persistAddressesOf: aCustomer ]
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

!DataBaseSession methodsFor: 'persistence - private' stamp: 'HAW 5/22/2022 19:29:06'!
objectsOfType: aType

	^ tables at: aType ifAbsent: [ #() ]! !

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


!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
select: aCondition ofType: aType

	self delay.
	^(self objectsOfType: aType) select: aCondition ! !

!DataBaseSession methodsFor: 'selecting' stamp: 'HAW 5/22/2022 19:29:06'!
selectAllOfType: aType

	self delay.
	^(self objectsOfType: aType) copy ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'DataBaseSession class' category: 'CustomerImporter'!
DataBaseSession class
	instanceVariableNames: ''!

!DataBaseSession class methodsFor: 'instance creation' stamp: 'HAW 5/22/2022 00:19:29'!
for: aConfiguration

	^self new initializeFor: aConfiguration! !

!classDefinition: #AddressTests category: 'CustomerImporter'!
TestCase subclass: #AddressTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!AddressTests methodsFor: 'tests' stamp: 'TAO 11/16/2023 03:15:14'!
test01Equals
	self assert: self defaultStreet = self defaultStreet.! !


!AddressTests methodsFor: 'as yet unclassified' stamp: 'TAO 11/16/2023 03:17:00'!
defaultStreet
	| defaultStreet |
	defaultStreet:= Address new.
	defaultStreet streetName:'Alem'.
	defaultStreet streetNumber:'1122'.
	defaultStreet town:'CABA'.
	defaultStreet zipCode: '1001'.
defaultStreet province: 'CABA'.
	^defaultStreet! !


!classDefinition: #CustomerTests category: 'CustomerImporter'!
TestCase subclass: #CustomerTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerTests methodsFor: 'tests' stamp: 'TAO 11/16/2023 03:15:28'!
test01Equals
	self assert: self defaultCustomer = self defaultCustomer.! !


!CustomerTests methodsFor: 'as yet unclassified' stamp: 'TAO 11/16/2023 03:15:28'!
defaultCustomer
	| pepe |
	pepe := Customer new.
	pepe firstName: 'Pepe'.
	pepe lastName: 'Sanchez'.
	pepe identificationType: 'D'.
	pepe identificationNumber: '22333444'.
	^pepe! !


!classDefinition: #ImportTest category: 'CustomerImporter'!
TestCase subclass: #ImportTest
	instanceVariableNames: 'session pepe juan pepeAddresses juanAddresses calleSanMartin calleMaipu calleAlem'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!ImportTest methodsFor: 'assertions' stamp: 'TAO 11/16/2023 02:58:03'!
assertQuantityOfCustomersIsCorrect

	^ self assert: (session selectAllOfType: Customer) size equals:2! !


!ImportTest methodsFor: 'tests' stamp: 'TAO 11/16/2023 03:35:27'!
test01Import

	| firstCustomer secondCustomer  |
	(CustomerImporter from: session in: self defaultInputData)import.
	
	self assertQuantityOfCustomersIsCorrect.
	
	firstCustomer := (session select:[:aCostumer| aCostumer  = pepe] ofType:Customer) anyOne.
	secondCustomer := (session select:[:aCostumer| aCostumer  = juan] ofType:Customer) anyOne.
	
	self assert: pepeAddresses equals: firstCustomer addresses.
	self assert: juanAddresses equals: secondCustomer addresses.
	
	
	
	! !


!ImportTest methodsFor: 'setUp/tearDown' stamp: 'TAO 11/16/2023 03:04:24'!
setUp
	session := DataBaseSession for: (Array with: Address with: Customer).
	session beginTransaction.
	self pepe.
	self juan.
	self calleSanMartin.
	self calleMaipu.
	self calleAlem.
	pepeAddresses := OrderedCollection with: calleSanMartin with: calleMaipu.
	juanAddresses := OrderedCollection with:calleAlem.
	! !

!ImportTest methodsFor: 'setUp/tearDown' stamp: 'TAO 11/16/2023 02:27:32'!
tearDown
	session commit.
	session close! !


!ImportTest methodsFor: 'addresses' stamp: 'TAO 11/16/2023 03:24:22'!
calleAlem
	calleAlem:= Address new.
	self crearCalle: calleAlem  withStreetName: 'Alem' withStreetNumber: 1122 inTown: 'CABA' withZipCode: 1001  inProvince: 'CABA'! !

!ImportTest methodsFor: 'addresses' stamp: 'TAO 11/16/2023 03:24:26'!
calleMaipu
	calleMaipu:= Address new.
	self crearCalle: calleMaipu  withStreetName: 'Maipu' withStreetNumber: 888 inTown: 'Florida' withZipCode: 1122  inProvince: 'Buenos Aires'
	! !

!ImportTest methodsFor: 'addresses' stamp: 'TAO 11/16/2023 03:24:30'!
calleSanMartin
	calleSanMartin := Address new.
	self crearCalle: calleSanMartin  withStreetName: 'San Martin' withStreetNumber: 3322 inTown: 'Olivos' withZipCode: 1636  inProvince: 'BsAs'
	
	! !

!ImportTest methodsFor: 'addresses' stamp: 'TAO 11/16/2023 03:10:43'!
crearCalle: anStreet withStreetName: anStreetName withStreetNumber:anStreetNumber inTown:aTown withZipCode: aZipCode inProvince: aProvince

	
	anStreet streetName:anStreetName.
	anStreet streetNumber:anStreetNumber.
	anStreet town:aTown.
	anStreet zipCode: aZipCode.
	anStreet province: aProvince! !


!ImportTest methodsFor: 'customers' stamp: 'TAO 11/15/2023 23:54:50'!
juan
	 
	juan := Customer new.
	juan firstName: 'Juan'.
	juan lastName: 'Perez'.
	juan identificationType: 'C'.
	juan identificationNumber: '23-25666777-9'.
	! !

!ImportTest methodsFor: 'customers' stamp: 'TAO 11/15/2023 23:54:39'!
pepe
	pepe := Customer new.
	pepe firstName: 'Pepe'.
	pepe lastName: 'Sanchez'.
	pepe identificationType: 'D'.
	pepe identificationNumber: '22333444'.
	! !


!ImportTest methodsFor: 'data' stamp: 'TAO 11/16/2023 03:35:09'!
defaultInputData

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


!classDefinition: #CustomerImporter category: 'CustomerImporter'!
Object subclass: #CustomerImporter
	instanceVariableNames: 'stream session'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CustomerImporter'!

!CustomerImporter methodsFor: 'initialization' stamp: 'TAO 11/16/2023 03:33:05'!
initializeIn: anStream From: aSession 

	stream := anStream.
	session := aSession.
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

!CustomerImporter class methodsFor: 'instance creation' stamp: 'TAO 11/16/2023 03:33:05'!
from: anInputStream in: aSession 
	^self new initializeIn: aSession From: anInputStream ! !


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

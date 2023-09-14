!classDefinition: #NumeroTest category: 'Numero-Exercise'!
TestCase subclass: #NumeroTest
	instanceVariableNames: 'zero one two four oneFifth oneHalf five twoFifth twoTwentyfifth fiveHalfs three eight negativeOne negativeTwo'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:11'!
test01isCeroReturnsTrueWhenAskToZero

	self assert: zero isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:12'!
test02isCeroReturnsFalseWhenAskToOthersButZero

	self deny: one isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:13'!
test03isOneReturnsTrueWhenAskToOne

	self assert: one isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:13'!
test04isOneReturnsFalseWhenAskToOtherThanOne

	self deny: zero isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:14'!
test05EnteroAddsWithEnteroCorrectly

	self assert: one + one equals: two! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:18'!
test06EnteroMultipliesWithEnteroCorrectly

	self assert: two * two equals: four! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:20'!
test07EnteroDividesEnteroCorrectly

	self assert: two / two equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:38'!
test08FraccionAddsWithFraccionCorrectly
"
    La suma de fracciones es:
	 
	a/b + c/d = (a.d + c.b) / (b.d)
	 
	SI ESTAN PENSANDO EN LA REDUCCION DE FRACCIONES NO SE PREOCUPEN!!
	TODAVIA NO SE ESTA TESTEANDO ESE CASO
"
	| sevenTenths |

	sevenTenths := (Entero with: 7) / (Entero with: 10).

	self assert: oneFifth + oneHalf equals: sevenTenths! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:52'!
test09FraccionMultipliesWithFraccionCorrectly
"
    La multiplicacion de fracciones es:
	 
	(a/b) * (c/d) = (a.c) / (b.d)
"

	self assert: oneFifth * twoFifth equals: twoTwentyfifth! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 20:56'!
test10FraccionDividesFraccionCorrectly
"
    La division de fracciones es:
	 
	(a/b) / (c/d) = (a.d) / (b.c)
"

	self assert: oneHalf / oneFifth equals: fiveHalfs! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:07'!
test11EnteroAddsFraccionCorrectly
"
	Ahora empieza la diversion!!
"

	self assert: one + oneFifth equals: (Entero with: 6) / (Entero with: 5)! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:07'!
test12FraccionAddsEnteroCorrectly

	self assert: oneFifth + one equals: (Entero with: 6) / (Entero with: 5)! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:50'!
test13EnteroMultipliesFraccionCorrectly

	self assert: two * oneFifth equals: twoFifth ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:52'!
test14FraccionMultipliesEnteroCorrectly

	self assert: oneFifth * two equals: twoFifth ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:57'!
test15EnteroDividesFraccionCorrectly

	self assert: one / twoFifth equals: fiveHalfs  ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 21:59'!
test16FraccionDividesEnteroCorrectly

	self assert: twoFifth / five equals: twoTwentyfifth ! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:38'!
test17AFraccionCanBeEqualToAnEntero

	self assert: two equals: four / two! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:39'!
test18AparentFraccionesAreEqual

	self assert: oneHalf equals: two / four! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:40'!
test19AddingFraccionesCanReturnAnEntero

	self assert: oneHalf + oneHalf equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:42'!
test20MultiplyingFraccionesCanReturnAnEntero

	self assert: (two/five) * (five/two) equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:42'!
test21DividingFraccionesCanReturnAnEntero

	self assert: oneHalf / oneHalf equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:43'!
test22DividingEnterosCanReturnAFraccion

	self assert: two / four equals: oneHalf! !

!NumeroTest methodsFor: 'tests' stamp: 'ff 9/13/2023 20:50:52'!
test23CanNotDivideEnteroByZero

	self 
		should: [ one / zero ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: EnteroCero canNotDivideByZeroErrorDescription ]
	! !

!NumeroTest methodsFor: 'tests' stamp: 'ff 9/13/2023 20:50:58'!
test24CanNotDivideFraccionByZero

	self 
		should: [ oneHalf / zero ]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: EnteroCero canNotDivideByZeroErrorDescription ]
	! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:50'!
test25AFraccionCanNotBeZero

	self deny: oneHalf isZero! !

!NumeroTest methodsFor: 'tests' stamp: 'HernanWilkinson 5/7/2016 22:50'!
test26AFraccionCanNotBeOne

	self deny: oneHalf isOne! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 4/15/2021 16:45:35'!
test27EnteroSubstractsEnteroCorrectly

	self assert: four - one equals: three! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:47:41'!
test28FraccionSubstractsFraccionCorrectly
	
	self assert: twoFifth - oneFifth equals: oneFifth.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:48:00'!
test29EnteroSubstractsFraccionCorrectly

	self assert: one - oneHalf equals: oneHalf! !

!NumeroTest methodsFor: 'tests' stamp: 'HAW 9/24/2018 08:48:05'!
test30FraccionSubstractsEnteroCorrectly

	| sixFifth |
	
	sixFifth := (Entero with: 6) / (Entero with: 5).
	
	self assert: sixFifth - one equals: oneFifth! !

!NumeroTest methodsFor: 'tests' stamp: 'HAW 9/24/2018 08:48:08'!
test31SubstractingFraccionesCanReturnAnEntero

	| threeHalfs |
	
	threeHalfs := (Entero with: 3) / (Entero with: 2).
	
	self assert: threeHalfs - oneHalf equals: one.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:48:48'!
test32SubstractingSameEnterosReturnsZero

	self assert: one - one equals: zero.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:01'!
test33SubstractingSameFraccionesReturnsZero

	self assert: oneHalf - oneHalf equals: zero.! !

!NumeroTest methodsFor: 'tests' stamp: 'HAW 9/24/2018 08:48:14'!
test34SubstractingAHigherValueToANumberReturnsANegativeNumber

	| negativeThreeHalfs |
	
	negativeThreeHalfs := (Entero with: -3) / (Entero with: 2).	

	self assert: one - fiveHalfs equals: negativeThreeHalfs.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:23'!
test35FibonacciZeroIsOne

	self assert: zero fibonacci equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:32'!
test36FibonacciOneIsOne

	self assert: one fibonacci equals: one! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:39'!
test37FibonacciEnteroReturnsAddingPreviousTwoFibonacciEnteros

	self assert: four fibonacci equals: five.
	self assert: three fibonacci equals: three. 
	self assert: five fibonacci equals: four fibonacci + three fibonacci.! !

!NumeroTest methodsFor: 'tests' stamp: 'ff 9/13/2023 20:23:35'!
test38FibonacciNotDefinedForNegativeNumbers

	self 
		should: [negativeOne fibonacci]
		raise: Error
		withExceptionDo: [ :anError | self assert: anError messageText equals: EnteroNegativo negativeFibonacciErrorDescription ].! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:49:55'!
test39NegationOfEnteroIsCorrect

	self assert: two negated equals: negativeTwo.
		! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:50:03'!
test40NegationOfFraccionIsCorrect

	self assert: oneHalf negated equals: negativeOne / two.! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:50:11'!
test41SignIsCorrectlyAssignedToFractionWithTwoNegatives

	self assert: oneHalf equals: (negativeOne / negativeTwo)! !

!NumeroTest methodsFor: 'tests' stamp: 'NR 9/23/2018 23:50:17'!
test42SignIsCorrectlyAssignedToFractionWithNegativeDivisor

	self assert: oneHalf negated equals: (one / negativeTwo)! !


!NumeroTest methodsFor: 'setup' stamp: 'NR 9/23/2018 23:46:28'!
setUp

	zero := Entero with: 0.
	one := Entero with: 1.
	two := Entero with: 2.
	three:= Entero with: 3.
	four := Entero with: 4.
	five := Entero with: 5.
	eight := Entero with: 8.
	negativeOne := Entero with: -1.
	negativeTwo := Entero with: -2.
	
	oneHalf := one / two.
	oneFifth := one / five.
	twoFifth := two / five.
	twoTwentyfifth := two / (Entero with: 25).
	fiveHalfs := five / two.
	! !


!classDefinition: #Numero category: 'Numero-Exercise'!
Object subclass: #Numero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:48'!
* aMultiplier

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:49'!
+ anAdder

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'NR 9/23/2018 22:21:28'!
- aSubtrahend

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:49'!
/ aDivisor

	self subclassResponsibility ! !

!Numero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 22:48'!
invalidNumberType

	self error: self class invalidNumberTypeErrorDescription! !

!Numero methodsFor: 'arithmetic operations' stamp: 'NR 9/23/2018 23:37:13'!
negated
	
	^self * (Entero with: -1)! !


!Numero methodsFor: 'asserting' stamp: 'IB 9/14/2023 15:07:06'!
assertCanDivide

	self subclassResponsibility ! !


!Numero methodsFor: 'testing' stamp: 'NR 9/23/2018 23:36:49'!
isNegative

	self subclassResponsibility ! !

!Numero methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:49'!
isOne

	self subclassResponsibility ! !

!Numero methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:49'!
isZero

	self subclassResponsibility ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Numero class' category: 'Numero-Exercise'!
Numero class
	instanceVariableNames: ''!

!Numero class methodsFor: 'error descriptions' stamp: 'NR 4/15/2021 16:42:09'!
invalidNumberTypeErrorDescription
	
	^ 'Tipo de número inválido!!!!!!'! !


!classDefinition: #Entero category: 'Numero-Exercise'!
Numero subclass: #Entero
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Entero methodsFor: 'arithmetic operations - private' stamp: 'IB 9/14/2023 14:53:40'!
dividirAFraccion: unaFraccionADividir
 
	^unaFraccionADividir * self inverso! !

!Entero methodsFor: 'arithmetic operations - private' stamp: 'IB 9/14/2023 14:53:52'!
dividirAlEntero: unEnteroADividir

	^Fraccion with: unEnteroADividir over: self
	! !

!Entero methodsFor: 'arithmetic operations - private' stamp: 'IB 9/14/2023 14:54:12'!
multiplicarPorEntero: unEnteroAMultiplicar

	^self class with: value *  unEnteroAMultiplicar integerValue
	
	
	! !

!Entero methodsFor: 'arithmetic operations - private' stamp: 'IB 9/14/2023 14:54:58'!
multiplicarPorFraccion: unaFraccionAMultiplicar

	| nuevoNumerador nuevoDenominador |
	
	nuevoNumerador := unaFraccionAMultiplicar numerator * self.
	nuevoDenominador := unaFraccionAMultiplicar denominator.
	
	^nuevoNumerador / nuevoDenominador 
! !

!Entero methodsFor: 'arithmetic operations - private' stamp: 'IB 9/14/2023 14:56:12'!
restarAFraccion: unaFraccionMinuendo

	| nuevoNumerador nuevoDenominador |
	
	nuevoNumerador := unaFraccionMinuendo numerator - (self * unaFraccionMinuendo denominator).
	nuevoDenominador := unaFraccionMinuendo denominator.
	
	^nuevoNumerador / nuevoDenominador 
	! !

!Entero methodsFor: 'arithmetic operations - private' stamp: 'IB 9/14/2023 14:56:32'!
restarAlEntero: unEnteroMinuendo

	^ Entero with: (unEnteroMinuendo integerValue - value)
	! !

!Entero methodsFor: 'arithmetic operations - private' stamp: 'IB 9/14/2023 14:56:49'!
sumarConEntero: unEnteroASumar
	
	^self class with: value + unEnteroASumar integerValue
	! !

!Entero methodsFor: 'arithmetic operations - private' stamp: 'IB 9/14/2023 14:57:30'!
sumarConFraccion: unaFraccionASumar

	| nuevoNumerador nuevoDenominador |
	
	nuevoNumerador := self * unaFraccionASumar denominator + unaFraccionASumar  numerator.
	nuevoDenominador := unaFraccionASumar  denominator.
	
	^nuevoNumerador / nuevoDenominador 
! !


!Entero methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 14:57:39'!
* aMultiplier 

	^aMultiplier multiplicarPorEntero: self
	
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 14:57:44'!
+ anAdder

	 ^anAdder sumarConEntero: self
	
	
! !

!Entero methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 14:57:53'!
- aSubtrahend 

	^aSubtrahend restarAlEntero: self
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 14:57:57'!
/ aDivisor 

	^aDivisor dividirAlEntero: self
	
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 21:55'!
// aDivisor 
	
	^self class with: value // aDivisor integerValue! !

!Entero methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:06:24'!
fibonacci
	
	self subclassResponsibility ! !

!Entero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 21:00'!
greatestCommonDivisorWith: anEntero 
	
	^self class with: (value gcd: anEntero integerValue)! !

!Entero methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 14:58:15'!
inverso

	^Fraccion with: (Entero with: 1 ) over: self
! !


!Entero methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 21:01'!
= anObject

	^(anObject isKindOf: self class) and: [ value = anObject integerValue ]! !

!Entero methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 20:17'!
hash

	^value hash! !


!Entero methodsFor: 'initialization' stamp: 'ff 9/13/2023 20:22:58'!
initializeWith: aValue 
	
	value := aValue! !


!Entero methodsFor: 'value' stamp: 'HernanWilkinson 5/7/2016 21:02'!
integerValue

	"Usamos integerValue en vez de value para que no haya problemas con el mensaje value implementado en Object - Hernan"
	
	^value! !


!Entero methodsFor: 'printing' stamp: 'HAW 9/24/2018 08:53:19'!
printOn: aStream

	aStream print: value ! !


!Entero methodsFor: 'testing' stamp: 'NR 9/23/2018 22:17:55'!
isNegative
	
	^value < 0! !

!Entero methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 20:14'!
isOne
	
	^value = 1! !

!Entero methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 20:12'!
isZero
	
	^value = 0! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Entero class' category: 'Numero-Exercise'!
Entero class
	instanceVariableNames: ''!

!Entero class methodsFor: 'testing' stamp: 'IB 9/14/2023 15:01:18'!
canHandle: anObject

	self subclassResponsibility! !


!Entero class methodsFor: 'instance creation' stamp: 'IB 9/14/2023 15:00:35'!
with: aValue 
	
	^Entero subclasses 
		detect: [:subclass| subclass canHandle: aValue]
		ifFound:[:class| class createWith: aValue] 
		ifNone: [
			"Esta verificacion esta puesta por si se equivocan y quieren crear un Entero pasando otra cosa que un Integer - Hernan"
			self error: 'aValue debe ser anInteger']
	
	! !


!Entero class methodsFor: 'instance creation - private' stamp: 'ff 9/13/2023 21:01:45'!
createWith: aValue 
	
	"Esta verificacion esta puesta por si se equivocan y quieren crear un Entero pasando otra cosa que un Integer - Hernan"
	
	^self new initializeWith: aValue! !


!classDefinition: #EnteroCero category: 'Numero-Exercise'!
Entero subclass: #EnteroCero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!EnteroCero methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:08:28'!
fibonacci

	^Entero with: 1! !


!EnteroCero methodsFor: 'asserting' stamp: 'IB 9/14/2023 15:04:30'!
assertCanDivide

	self error: self class canNotDivideByZeroErrorDescription 
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnteroCero class' category: 'Numero-Exercise'!
EnteroCero class
	instanceVariableNames: ''!

!EnteroCero class methodsFor: 'accessing' stamp: 'ff 9/13/2023 20:49:56'!
canNotDivideByZeroErrorDescription

	^'No se puede dividir por cero!!!!!!'! !


!EnteroCero class methodsFor: 'testing' stamp: 'IB 9/14/2023 15:03:29'!
canHandle: aValue

	^aValue = 0! !


!classDefinition: #EnteroNegativo category: 'Numero-Exercise'!
Entero subclass: #EnteroNegativo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!EnteroNegativo methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:05:28'!
fibonacci

	^self error: self class negativeFibonacciErrorDescription! !


!EnteroNegativo methodsFor: 'testing' stamp: 'IB 9/14/2023 15:07:22'!
assertCanDivide
! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnteroNegativo class' category: 'Numero-Exercise'!
EnteroNegativo class
	instanceVariableNames: ''!

!EnteroNegativo class methodsFor: 'testing' stamp: 'IB 9/14/2023 15:03:36'!
canHandle: aValue

	^aValue < 0! !


!EnteroNegativo class methodsFor: 'accessing' stamp: 'ff 9/13/2023 20:16:20'!
negativeFibonacciErrorDescription
	^ ' Fibonacci no está definido aquí para Enteros Negativos!!!!!!'! !


!classDefinition: #EnteroPositivoSinUno category: 'Numero-Exercise'!
Entero subclass: #EnteroPositivoSinUno
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!EnteroPositivoSinUno methodsFor: 'testing' stamp: 'IB 9/14/2023 15:07:34'!
assertCanDivide
! !


!EnteroPositivoSinUno methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:06:09'!
fibonacci

	| one two |
	
	one := Entero with: 1.
	two := Entero with: 2.
		
	^ (self - one) fibonacci + (self - two) fibonacci! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnteroPositivoSinUno class' category: 'Numero-Exercise'!
EnteroPositivoSinUno class
	instanceVariableNames: ''!

!EnteroPositivoSinUno class methodsFor: 'testing' stamp: 'IB 9/14/2023 15:03:47'!
canHandle: aValue

	^aValue > 1! !


!classDefinition: #EnteroUno category: 'Numero-Exercise'!
Entero subclass: #EnteroUno
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!EnteroUno methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:09:04'!
assertCanDivide
! !

!EnteroUno methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:08:21'!
fibonacci

	^Entero with: 1! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnteroUno class' category: 'Numero-Exercise'!
EnteroUno class
	instanceVariableNames: ''!

!EnteroUno class methodsFor: 'testing' stamp: 'IB 9/14/2023 15:03:10'!
canHandle: aValue

	^aValue = 1! !


!classDefinition: #Fraccion category: 'Numero-Exercise'!
Numero subclass: #Fraccion
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:09:16'!
* aMultiplier 

	^aMultiplier multiplicarPorFraccion: self
	
	
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:11:59'!
+ anAdder 

	^anAdder sumarConFraccion: self! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:12:04'!
- aSubtrahend

	^ aSubtrahend restarAFraccion: self
	
! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:12:09'!
/ aDivisor

	^aDivisor dividirAFraccion: self

	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:09:49'!
dividirAFraccion: unaFraccionADividir
	
	 ^unaFraccionADividir * self inverso
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:10:03'!
dividirAlEntero: unEnteroADividir
	
	^self inverso * unEnteroADividir! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:10:13'!
inverso 
	
	^denominator / numerator! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:10:49'!
multiplicarPorEntero: unEnteroAMultiplicar

	| nuevoNumerador nuevoDenominador |
	
	nuevoNumerador := unEnteroAMultiplicar * self numerator.
	nuevoDenominador := self denominator.
	
	^nuevoNumerador / nuevoDenominador! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:12:54'!
multiplicarPorFraccion: unaFraccionAMultiplicar
	
	| nuevoNumerador nuevoDenominador |
	
	nuevoNumerador := numerator * unaFraccionAMultiplicar numerator.
	nuevoDenominador := denominator * unaFraccionAMultiplicar denominator.
	
	^nuevoNumerador / nuevoDenominador
! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:13:38'!
restarAFraccion: unaFraccionMinuendo
	
	| nuevoNumerador nuevoDenominador |
	
	nuevoNumerador :=  denominator * unaFraccionMinuendo numerator - (numerator * unaFraccionMinuendo denominator).
	nuevoDenominador := denominator * unaFraccionMinuendo denominator.
	
	^nuevoNumerador / nuevoDenominador 
	
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:14:29'!
restarAlEntero: unEnteroMinuendo

	| nuevoNumerador nuevoDenominador |
	
	nuevoNumerador := unEnteroMinuendo * self denominator - self numerator.
	nuevoDenominador := self denominator.
	
	^nuevoNumerador / nuevoDenominador! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:14:58'!
sumarConEntero: unEnteroASumar

	| nuevoNumerador nuevoDenominador |
	
	nuevoNumerador := unEnteroASumar * self denominator + self numerator.
	nuevoDenominador := self denominator.
	
	^nuevoNumerador / nuevoDenominador 
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'IB 9/14/2023 15:11:47'!
sumarConFraccion: unaFraccionASumar

	| nuevoNumerador nuevoDenominador |
	
	nuevoNumerador := (numerator * unaFraccionASumar denominator) + (denominator * unaFraccionASumar numerator).
	nuevoDenominador := denominator * unaFraccionASumar denominator.
	
	^nuevoNumerador / nuevoDenominador ! !


!Fraccion methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 20:42'!
= anObject

	^(anObject isKindOf: self class) and: [ (numerator * anObject denominator) = (denominator * anObject numerator) ]! !

!Fraccion methodsFor: 'comparing' stamp: 'HernanWilkinson 5/7/2016 20:50'!
hash

	^(numerator hash / denominator hash) hash! !


!Fraccion methodsFor: 'accessing' stamp: 'HernanWilkinson 5/7/2016 21:56'!
denominator

	^ denominator! !

!Fraccion methodsFor: 'accessing' stamp: 'HernanWilkinson 5/7/2016 21:56'!
numerator

	^ numerator! !


!Fraccion methodsFor: 'initialization' stamp: 'HernanWilkinson 5/7/2016 22:54'!
initializeWith: aNumerator over: aDenominator

	"Estas precondiciones estan por si se comenten errores en la implementacion - Hernan"
	aNumerator isZero ifTrue: [ self error: 'una fraccion no puede ser cero' ].
	aDenominator isOne ifTrue: [ self error: 'una fraccion no puede tener denominador 1 porque sino es un entero' ].
	
	numerator := aNumerator.
	denominator := aDenominator ! !


!Fraccion methodsFor: 'testing' stamp: 'NR 9/23/2018 23:41:38'!
isNegative
	
	^numerator < 0! !

!Fraccion methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:51'!
isOne
	
	^false! !

!Fraccion methodsFor: 'testing' stamp: 'HernanWilkinson 5/7/2016 22:51'!
isZero
	
	^false! !


!Fraccion methodsFor: 'printing' stamp: 'HAW 9/24/2018 08:54:46'!
printOn: aStream

	aStream 
		print: numerator;
		nextPut: $/;
		print: denominator ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Fraccion class' category: 'Numero-Exercise'!
Fraccion class
	instanceVariableNames: ''!

!Fraccion class methodsFor: 'intance creation' stamp: 'ff 9/13/2023 20:46:52'!
with: aDividend over: aDivisor
	
	| greatestCommonDivisor numerator denominator |
	
	aDividend isZero ifTrue: [ ^aDividend ].
	
	aDivisor assertCanDivide.
	aDivisor isNegative ifTrue:[ ^aDividend negated / aDivisor negated].
	
	greatestCommonDivisor := aDividend greatestCommonDivisorWith: aDivisor. 
	numerator := aDividend // greatestCommonDivisor.
	denominator := aDivisor // greatestCommonDivisor.
	
	denominator isOne ifTrue: [ ^numerator ].

	^self new initializeWith: numerator over: denominator
	! !

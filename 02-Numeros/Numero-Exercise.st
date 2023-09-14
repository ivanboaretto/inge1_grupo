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


!Numero methodsFor: 'testing' stamp: 'ff 9/13/2023 20:49:15'!
assertCanDivide
! !

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

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 20:56:14'!
* aMultiplier 
	^aMultiplier multiplicarPorEntero: self.
	
	
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 21:04:44'!
+ anAdder 
	 ^anAdder sumarConEntero: self.
	
	
! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 21:11:07'!
- aSubtrahend 
	^aSubtrahend restarAlEntero: self.
	
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 21:17:04'!
/ aDivisor 
	^aDivisor dividirAlEntero: self.
	
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 21:55'!
// aDivisor 
	
	^self class with: value // aDivisor integerValue! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:18:07'!
dividirAFraccion: aFraccionDividend 
	^aFraccionDividend * self inverso.! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:18:19'!
dividirAlEntero: anEnteroDividend
	^Fraccion with: anEnteroDividend over: self
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 20:40:06'!
fibonacci

	| one two |
	
	one := Entero with: 1.
	two := Entero with: 2.
		
	^ (self - one) fibonacci + (self - two) fibonacci
		! !

!Entero methodsFor: 'arithmetic operations' stamp: 'HernanWilkinson 5/7/2016 21:00'!
greatestCommonDivisorWith: anEntero 
	
	^self class with: (value gcd: anEntero integerValue)! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 20:48:39'!
inverso
	^Fraccion with: (Entero  with: 1 ) over: self. 
	
! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 20:57:25'!
multiplicarPorEntero: anEnteroMultiplier 
	^self class with: value *  anEnteroMultiplier  integerValue
	
	
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:34:52'!
multiplicarPorFraccion: aFraccionMultiplier
	| newNumerator newDenominator |
	
	newNumerator :=aFraccionMultiplier numerator *self .
	newDenominator :=aFraccionMultiplier denominator .
	
	^newNumerator / newDenominator 
! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:34:01'!
restarAFraccion: aFraccionMinuend
	| newNumerator newDenominator |
	
	newNumerator := aFraccionMinuend numerator - (self *aFraccionMinuend denominator).
	newDenominator := aFraccionMinuend denominator.
	
	^newNumerator / newDenominator 
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:20:12'!
restarAlEntero: anEnteroMinuend 
	^ Entero with:(anEnteroMinuend integerValue - value).
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:32:51'!
sumarConEntero: anEnteroAdder
	

	^self class with: value + anEnteroAdder integerValue
	! !

!Entero methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:32:26'!
sumarConFraccion: aFraccionAdder
	| newNumerator newDenominator |
	
	newNumerator := self *aFraccionAdder denominator + aFraccionAdder  numerator .
	newDenominator := aFraccionAdder  denominator.
	
	^newNumerator / newDenominator 
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

!Entero class methodsFor: 'instance creation' stamp: 'ff 9/13/2023 21:01:45'!
createWith: aValue 
	
	"Esta verificacion esta puesta por si se equivocan y quieren crear un Entero pasando otra cosa que un Integer - Hernan"
	
	^self new initializeWith: aValue! !

!Entero class methodsFor: 'instance creation' stamp: 'ff 9/13/2023 21:06:01'!
with: aValue 
	
	"Esta verificacion esta puesta por si se equivocan y quieren crear un Entero pasando otra cosa que un Integer - Hernan"
	Entero subclasses detect: [:subclass| subclass canHandle:aValue ]ifFound:[:class| ^class createWith:aValue] ifNone: [self error: 'aValue debe ser anInteger' ] . 
	
	! !


!classDefinition: #EnteroCero category: 'Numero-Exercise'!
Entero subclass: #EnteroCero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!EnteroCero methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 20:49:02'!
assertCanDivide
	self error: self class canNotDivideByZeroErrorDescription 
	! !

!EnteroCero methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 20:42:13'!
fibonacci
	^EnteroUno new.! !

!EnteroCero methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 20:39:54'!
initialize
	value:= 0.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnteroCero class' category: 'Numero-Exercise'!
EnteroCero class
	instanceVariableNames: ''!

!EnteroCero class methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 20:59:57'!
canHandle: aValue
	^aValue=0.
	! !

!EnteroCero class methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 20:49:56'!
canNotDivideByZeroErrorDescription

	^'No se puede dividir por cero!!!!!!'! !

!EnteroCero class methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 20:43:03'!
with: aValue
	^self basicNew initialize.
	! !


!classDefinition: #EnteroNegativo category: 'Numero-Exercise'!
Entero subclass: #EnteroNegativo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!EnteroNegativo methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 20:15:50'!
fibonacci
	^self error: self class negativeFibonacciErrorDescription.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnteroNegativo class' category: 'Numero-Exercise'!
EnteroNegativo class
	instanceVariableNames: ''!

!EnteroNegativo class methodsFor: 'instance creation' stamp: 'ff 9/13/2023 21:00:12'!
canHandle: aValue
	^aValue <0.! !

!EnteroNegativo class methodsFor: 'instance creation' stamp: 'ff 9/13/2023 20:16:20'!
negativeFibonacciErrorDescription
	^ ' Fibonacci no está definido aquí para Enteros Negativos!!!!!!'! !

!EnteroNegativo class methodsFor: 'instance creation' stamp: 'ff 9/13/2023 20:21:49'!
with: aValue
	^self new initializeWith: aValue.! !


!classDefinition: #EnteroPositivoSinUno category: 'Numero-Exercise'!
Entero subclass: #EnteroPositivoSinUno
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnteroPositivoSinUno class' category: 'Numero-Exercise'!
EnteroPositivoSinUno class
	instanceVariableNames: ''!

!EnteroPositivoSinUno class methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 21:00:34'!
canHandle: aValue
	^aValue>1.! !


!classDefinition: #EnteroUno category: 'Numero-Exercise'!
Entero subclass: #EnteroUno
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!EnteroUno methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 20:29:18'!
fibonacci
	^EnteroUno new.! !

!EnteroUno methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 20:27:56'!
initialize
	value:=1.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EnteroUno class' category: 'Numero-Exercise'!
EnteroUno class
	instanceVariableNames: ''!

!EnteroUno class methodsFor: 'as yet unclassified' stamp: 'ff 9/13/2023 21:00:52'!
canHandle: aValue
	^aValue =1.! !


!classDefinition: #Fraccion category: 'Numero-Exercise'!
Numero subclass: #Fraccion
	instanceVariableNames: 'numerator denominator'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numero-Exercise'!

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 21:00:20'!
* aMultiplier 
	^aMultiplier multiplicarPorFraccion: self.
	
	
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 21:25:43'!
+ anAdder 
	^anAdder sumarConFraccion: self.
	
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 21:27:41'!
- aSubtrahend 
	^ aSubtrahend restarAFraccion: self.
	
! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/12/2023 21:35:34'!
/ aDivisor 
	^aDivisor dividirAFraccion: self.

	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:21:25'!
dividirAFraccion: aFraccionDividend
	
	 ^aFraccionDividend * self inverso.
	
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:21:32'!
dividirAlEntero: anEnteroDividend
	
	^self inverso * anEnteroDividend.! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:30:42'!
inverso 
	
	^denominator /numerator.! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:30:06'!
multiplicarPorEntero: anEnteroMultiplier
	| newNumerator newDenominator |
	
	newNumerator :=  anEnteroMultiplier* self numerator.
	newDenominator := self denominator.
	
	^newNumerator / newDenominator.! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:29:31'!
multiplicarPorFraccion: aFraccionMultiplier
	
	| newNumerator newDenominator |
	
	newNumerator :=  numerator * aFraccionMultiplier numerator.
	newDenominator := denominator * aFraccionMultiplier denominator.
	
	^newNumerator / newDenominator .
! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:22:14'!
restarAFraccion: aFraccionMinuend
	
	| newNumerator newDenominator |
	
	newNumerator :=  denominator * aFraccionMinuend numerator - (numerator * aFraccionMinuend denominator).
	newDenominator := denominator * aFraccionMinuend denominator.
	
	^newNumerator / newDenominator 
	
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:28:50'!
restarAlEntero: anEnteroMinuend 
	| newNumerator newDenominator |
	
	newNumerator :=  anEnteroMinuend * self denominator - self numerator.
	newDenominator := self denominator.
	
	^newNumerator / newDenominator 
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:28:25'!
sumarConEntero: anEnteroAdder
	| newNumerator newDenominator |
	
	newNumerator := anEnteroAdder * self denominator + self numerator.
	newDenominator := self denominator .
	
	^newNumerator / newDenominator 
	! !

!Fraccion methodsFor: 'arithmetic operations' stamp: 'ff 9/13/2023 21:22:40'!
sumarConFraccion: aFraccionAdder
	| newNumerator newDenominator |
	
	newNumerator := (numerator * aFraccionAdder denominator) + (denominator * aFraccionAdder numerator).
	newDenominator := denominator * aFraccionAdder denominator.
	
	^newNumerator / newDenominator ! !


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

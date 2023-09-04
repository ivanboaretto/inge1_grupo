!classDefinition: #I category: 'Números Naturales'!
DenotativeObject subclass: #I
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Números Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'I class' category: 'Números Naturales'!
I class
	instanceVariableNames: ''!

!I class methodsFor: 'operaciones' stamp: 'IB 9/3/2023 23:01:05'!
* aNaturalNumber

	^aNaturalNumber
	! !

!I class methodsFor: 'operaciones' stamp: 'IB 9/3/2023 23:01:09'!
+ aNaturalNumber

	^aNaturalNumber next
	! !

!I class methodsFor: 'operaciones' stamp: 'IB 9/3/2023 23:00:07'!
- aNumber

	self error: self descripcionDeErrorDeNumerosNegativosNoSoportados ! !

!I class methodsFor: 'operaciones' stamp: 'IB 9/3/2023 23:16:28'!
/ aNaturalNumber

	^self = aNaturalNumber 
		ifTrue: [I] 
		ifFalse: [self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor]
	
	! !


!I class methodsFor: 'testing' stamp: 'IB 9/3/2023 23:02:02'!
< aNaturalNumber

	^aNaturalNumber ~= self
	! !

!I class methodsFor: 'testing' stamp: 'IB 9/3/2023 23:19:42'!
<= aNaturalNumber

	^true
	! !


!I class methodsFor: 'accessing' stamp: 'IB 9/3/2023 23:05:35'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	
	^'No se puede dividir por un numero mayor'! !

!I class methodsFor: 'accessing' stamp: 'IB 9/3/2023 22:59:15'!
descripcionDeErrorDeNumerosNegativosNoSoportados
	
	^'No se soportan numeros negativos'! !

!I class methodsFor: 'accessing' stamp: 'IB 9/3/2023 23:08:16'!
next

	^II
	! !


!I class methodsFor: 'support' stamp: 'IB 9/3/2023 23:20:19'!
dividirA: aNaturalNumber

	^aNaturalNumber
	! !

!I class methodsFor: 'support' stamp: 'IB 9/3/2023 23:10:42'!
previous: aNaturalNumber

	^aNaturalNumber previous! !

!I class methodsFor: 'support' stamp: 'IB 9/3/2023 23:20:26'!
restarleA: aNaturalNumber

	^aNaturalNumber previous
	! !


!classDefinition: #II category: 'Números Naturales'!
DenotativeObject subclass: #II
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Números Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'II class' category: 'Números Naturales'!
II class
	instanceVariableNames: 'next prev imayus'!

!II class methodsFor: 'testing' stamp: 'IB 9/3/2023 23:23:33'!
< aNaturalNumber

	^(aNaturalNumber = I or: [self = I ]) 
		ifTrue: [false] 
		ifFalse: [(self previous < aNaturalNumber previous) ]
	! !

!II class methodsFor: 'testing' stamp: 'IB 9/3/2023 23:27:09'!
<= aNaturalNumber

	^aNaturalNumber = self or: [self < aNaturalNumber]
	! !


!II class methodsFor: 'support' stamp: 'IB 9/3/2023 23:29:00'!
dividirA: aNaturalNumber

	self  < aNaturalNumber ifFalse: [^I].
	self = aNaturalNumber ifTrue: [^I].
	^ I + (self  dividirA: (aNaturalNumber  - self)).
	
	! !

!II class methodsFor: 'support' stamp: 'IB 9/3/2023 23:07:30'!
previous: aNaturalNumber

	prev := aNaturalNumber
	! !

!II class methodsFor: 'support' stamp: 'IB 9/3/2023 23:06:45'!
restarleA: aNaturalNumber

	^(aNaturalNumber previous - self previous).
	
	! !


!II class methodsFor: 'accessing' stamp: 'IB 9/3/2023 23:00:36'!
descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor
	
	^'No se puede dividir por un numero mayor'! !

!II class methodsFor: 'accessing' stamp: 'IB 9/3/2023 23:08:08'!
next

	next ifNotNil: [^next].
	next := II createChildNamed: self name,'I'. 
	next previous: self.		
	^next.! !

!II class methodsFor: 'accessing' stamp: 'IB 9/3/2023 23:07:59'!
previous

	^prev! !


!II class methodsFor: 'asserting' stamp: 'IB 9/3/2023 23:28:42'!
assertMayorThan: aNaturalNumber

	self < aNaturalNumber ifTrue: [self error: self descripcionDeErrorDeNoSePuedeDividirPorUnNumeroMayor]! !


!II class methodsFor: 'operaciones' stamp: 'sx 8/30/2023 20:31:36'!
* aNaturalNumber
	^(self previous * aNaturalNumber  + aNaturalNumber ) 
	! !

!II class methodsFor: 'operaciones' stamp: 'sx 8/30/2023 20:31:36'!
+ aNaturalNumber
	^(self previous + aNaturalNumber next) 
	! !

!II class methodsFor: 'operaciones' stamp: 'IB 9/3/2023 23:06:38'!
- aNaturalNumber

	^aNaturalNumber restarleA: self
	! !

!II class methodsFor: 'operaciones' stamp: 'IB 9/3/2023 23:28:37'!
/ aNaturalNumber

	self assertMayorThan: aNaturalNumber.
	^aNaturalNumber dividirA: self.
	! !


!II class methodsFor: '--** private fileout/in **--' stamp: 'IB 9/3/2023 23:32:56'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := III.
	prev := I.
	imayus := nil.! !


!classDefinition: #III category: 'Números Naturales'!
II subclass: #III
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Números Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'III class' category: 'Números Naturales'!
III class
	instanceVariableNames: ''!

!III class methodsFor: '--** private fileout/in **--' stamp: 'IB 9/3/2023 23:32:56'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIII.
	prev := II.
	imayus := nil.! !


!classDefinition: #IIII category: 'Números Naturales'!
II subclass: #IIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Números Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIII class' category: 'Números Naturales'!
IIII class
	instanceVariableNames: ''!

!IIII class methodsFor: '--** private fileout/in **--' stamp: 'IB 9/3/2023 23:32:56'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIII.
	prev := III.
	imayus := nil.! !


!classDefinition: #IIIII category: 'Números Naturales'!
II subclass: #IIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Números Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIII class' category: 'Números Naturales'!
IIIII class
	instanceVariableNames: ''!

!IIIII class methodsFor: '--** private fileout/in **--' stamp: 'IB 9/3/2023 23:32:56'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIIII.
	prev := IIII.
	imayus := nil.! !


!classDefinition: #IIIIII category: 'Números Naturales'!
II subclass: #IIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Números Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIII class' category: 'Números Naturales'!
IIIIII class
	instanceVariableNames: ''!

!IIIIII class methodsFor: '--** private fileout/in **--' stamp: 'IB 9/3/2023 23:32:56'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIIIII.
	prev := IIIII.
	imayus := nil.! !


!classDefinition: #IIIIIII category: 'Números Naturales'!
II subclass: #IIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Números Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIII class' category: 'Números Naturales'!
IIIIIII class
	instanceVariableNames: ''!

!IIIIIII class methodsFor: '--** private fileout/in **--' stamp: 'IB 9/3/2023 23:32:56'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := IIIIIIII.
	prev := IIIIII.
	imayus := nil.! !


!classDefinition: #IIIIIIII category: 'Números Naturales'!
II subclass: #IIIIIIII
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Números Naturales'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IIIIIIII class' category: 'Números Naturales'!
IIIIIIII class
	instanceVariableNames: ''!

!IIIIIIII class methodsFor: '--** private fileout/in **--' stamp: 'IB 9/3/2023 23:32:56'!
initializeCollaboratorsFromFile
	"Auto generated method for loading purposes - Do not modify it"

	next := nil.
	prev := IIIIIII.
	imayus := nil.! !

II initializeAfterFileIn!
III initializeAfterFileIn!
IIII initializeAfterFileIn!
IIIII initializeAfterFileIn!
IIIIII initializeAfterFileIn!
IIIIIII initializeAfterFileIn!
IIIIIIII initializeAfterFileIn!
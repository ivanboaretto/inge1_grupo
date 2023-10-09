!classDefinition: #MarsRoversTests category: 'Mars Rover'!
TestCase subclass: #MarsRoversTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!MarsRoversTests methodsFor: 'assertions' stamp: 'TAO 10/8/2023 19:31:33'!
assert: marsRover placedAt: finalPosition facing: finalFacingDirection

	self assert: marsRover position equals: finalPosition.
	self assert: marsRover direction equals: finalFacingDirection! !


!MarsRoversTests methodsFor: 'support' stamp: 'TAO 10/8/2023 19:45:18'!
marsRoverInitiallyPlacedAt: initialPosition facingAt: initialFacingDirection afterExecuting: aCommandToBeExecute
	
	| marsRover |
	
	marsRover := MarsRover placedAt:initialPosition facing: initialFacingDirection.
	marsRover executeCommand: aCommandToBeExecute .
	
	^marsRover.
	! !


!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 19:50:47'!
test01WhenNoCommandExecutedStayStill
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt:North new afterExecuting: ''.
	
	self assert: marsRover placedAt: 0@0 facing: North new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:00:45'!
test02MovingFowardOneTimeFacingNorth
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: North new afterExecuting: 'f'.
	
	
	self assert: marsRover placedAt: 0@1 facing: North new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:00:50'!
test03MovingFowardOneTimeFacingEast
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: East new afterExecuting: 'f'.
	
	self assert: marsRover placedAt: 1@0 facing: East new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:00:54'!
test04MovingFowardOneTimeFacingSouth
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: South new afterExecuting: 'f'.
	
	self assert: marsRover placedAt: 0@-1 facing: South new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:01:00'!
test05MovingFowardOneTimeFacingWest
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: West new afterExecuting: 'f'.
	
	self assert: marsRover placedAt: -1@0 facing: West new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:05:07'!
test06MovingBackwardOneTimeFacingNorth
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: North new afterExecuting: 'b'.
	
	self assert: marsRover placedAt: 0@-1 facing: North new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:08:10'!
test07MovingBackwardOneTimeFacingEast
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: East new afterExecuting: 'b'.
	
	self assert: marsRover placedAt: -1@0 facing: East new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:12:01'!
test09MovingFowardMoreThanOneTime
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: North new afterExecuting: 'ff'.
	
	self assert: marsRover placedAt: 0@2 facing: North new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:16:24'!
test10MovingBackwardMoreThanOneTime
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: North new afterExecuting: 'bb'.
	
	self assert: marsRover placedAt: 0@-2 facing: North new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:37:33'!
test11RotateLeftOneTimeFacingEastLeftYouFacingNorthAtTheSamePlace
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: East new afterExecuting: 'l'.
	
	self assert: marsRover placedAt: 0@0 facing: North new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:37:43'!
test12RotateLeftOneTimeFacingNorthLeftYouFacingWestAtTheSamePlace
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: North new afterExecuting: 'l'.
	
	self assert: marsRover placedAt: 0@0 facing: West new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:37:57'!
test13RotateLeftOneTimeFacingSouthLeftYouFacingEastAtTheSamePlace
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: South new afterExecuting: 'l'.
	
	self assert: marsRover placedAt: 0@0 facing: East new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:38:02'!
test14RotateLeftOneTimeFacingWestLeftYouFacingSouthAtTheSamePlace
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: West new afterExecuting: 'l'.
	
	self assert: marsRover placedAt: 0@0 facing: South new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:40:28'!
test15RotateRightOneTimeFacingWestLeftYouFacingSouthAtTheSamePlace
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: West new afterExecuting: 'r'.
	
	self assert: marsRover placedAt: 0@0 facing: North new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:44:13'!
test16RotateRightOneTimeFacingNorthLeftYouFacingEastAtTheSamePlace
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: North new afterExecuting: 'r'.
	
	self assert: marsRover placedAt: 0@0 facing: East new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:46:45'!
test17RotateRightOneTimeFacingSouthLeftYouFacingWestAtTheSamePlace
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: South new afterExecuting: 'r'.
	
	self assert: marsRover placedAt: 0@0 facing: West new.! !

!MarsRoversTests methodsFor: 'tests' stamp: 'TAO 10/8/2023 20:47:35'!
test18RotateRightOneTimeFacingEastLeftYouFacingSouthAtTheSamePlace
	
	| marsRover |
	
	marsRover:= self marsRoverInitiallyPlacedAt: 0@0 facingAt: East new afterExecuting: 'r'.
	
	self assert: marsRover placedAt: 0@0 facing: South new.! !


!classDefinition: #CardinalPoint category: 'Mars Rover'!
Object subclass: #CardinalPoint
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!CardinalPoint methodsFor: 'testing' stamp: 'TAO 10/8/2023 19:54:16'!
= anCardinalPointToCompare
	^self class = anCardinalPointToCompare class.! !


!CardinalPoint methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:34:03'!
anticlockwise90DegreeCardinalPoint
	self subclassResponsibility .! !

!CardinalPoint methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:44:58'!
clockwise90DegreeCardinalPoint
	^self subclassResponsibility .! !

!CardinalPoint methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:58:29'!
directionVector
	self subclassResponsibility .! !

!CardinalPoint methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:58:56'!
inverseDirectionVector
	^self directionVector negated.! !


!classDefinition: #East category: 'Mars Rover'!
CardinalPoint subclass: #East
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!East methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:35:15'!
anticlockwise90DegreeCardinalPoint

	^North new.! !

!East methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:47:47'!
clockwise90DegreeCardinalPoint

	^South new.! !

!East methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:58:29'!
directionVector
	^1@0.! !


!classDefinition: #North category: 'Mars Rover'!
CardinalPoint subclass: #North
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!North methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:34:03'!
anticlockwise90DegreeCardinalPoint
	^West new.! !

!North methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:45:38'!
clockwise90DegreeCardinalPoint
	^East new.! !

!North methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:58:29'!
directionVector
	^0@1.! !


!classDefinition: #South category: 'Mars Rover'!
CardinalPoint subclass: #South
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!South methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:34:03'!
anticlockwise90DegreeCardinalPoint
	^East new.! !

!South methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:47:10'!
clockwise90DegreeCardinalPoint
	^West new.! !

!South methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:58:29'!
directionVector
	 ^0@-1.! !


!classDefinition: #West category: 'Mars Rover'!
CardinalPoint subclass: #West
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!West methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:35:36'!
anticlockwise90DegreeCardinalPoint
	^South new.! !

!West methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:46:07'!
clockwise90DegreeCardinalPoint
	^North new.! !

!West methodsFor: 'accesing' stamp: 'TAO 10/8/2023 20:58:29'!
directionVector
	^-1@0.! !


!classDefinition: #MarsRover category: 'Mars Rover'!
Object subclass: #MarsRover
	instanceVariableNames: 'position initialPosition facingDirection commandProcedures'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Mars Rover'!

!MarsRover methodsFor: 'execute' stamp: 'TAO 10/8/2023 20:51:54'!
executeCommand: aCommandToExecute 

	aCommandToExecute do:[:command|( commandProcedures at:command) value.]
		
			
	
	

	
	! !


!MarsRover methodsFor: 'accesing' stamp: 'TAO 10/8/2023 19:57:50'!
direction
	^facingDirection! !

!MarsRover methodsFor: 'accesing' stamp: 'TAO 10/8/2023 19:27:11'!
position
	^position.! !


!MarsRover methodsFor: 'execute--private' stamp: 'TAO 10/8/2023 20:55:35'!
changeFacingDirectionTo: aCardinalPoint

	^facingDirection := aCardinalPoint! !

!MarsRover methodsFor: 'execute--private' stamp: 'TAO 10/8/2023 20:58:56'!
moveBackwardOneTime
	self moveInDirection: facingDirection inverseDirectionVector
	! !

!MarsRover methodsFor: 'execute--private' stamp: 'TAO 10/8/2023 20:58:29'!
moveFowardOneTime

	 self moveInDirection: facingDirection directionVector! !

!MarsRover methodsFor: 'execute--private' stamp: 'TAO 10/8/2023 20:56:32'!
moveInDirection: aDirectionToMove 
	 position := position +  aDirectionToMove! !

!MarsRover methodsFor: 'execute--private' stamp: 'TAO 10/8/2023 20:56:14'!
rotateLeft
	self changeFacingDirectionTo: facingDirection  anticlockwise90DegreeCardinalPoint .! !

!MarsRover methodsFor: 'execute--private' stamp: 'TAO 10/8/2023 20:56:04'!
rotateRight
	self changeFacingDirectionTo: facingDirection  clockwise90DegreeCardinalPoint .! !


!MarsRover methodsFor: 'initialize' stamp: 'TAO 10/8/2023 20:53:09'!
initializeCommandProcedures
	commandProcedures:= Dictionary new
	at:$f put: [self moveFowardOneTime];
	at:$b put: [self moveBackwardOneTime];
	at:$l put: [self rotateLeft];
	at:$r put: [self rotateRight]; yourself.! !

!MarsRover methodsFor: 'initialize' stamp: 'TAO 10/8/2023 20:52:26'!
initializePlacedAt: anInitialPosition facing: anInitialDirection
	position := anInitialPosition.
	facingDirection:= anInitialDirection.
	
	self initializeCommandProcedures.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'Mars Rover'!
MarsRover class
	instanceVariableNames: ''!

!MarsRover class methodsFor: 'instance creation' stamp: 'TAO 10/8/2023 19:43:57'!
placedAt: anInitialPosition facing: anInitialFacingDirection
	
	^self new initializePlacedAt: anInitialPosition facing: anInitialFacingDirection .! !

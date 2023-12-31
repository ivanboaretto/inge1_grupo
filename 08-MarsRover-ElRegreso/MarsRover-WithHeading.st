!classDefinition: #MarsRoverObserverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverObserverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 15:51:44'!
test01PositionLogWhenMoveNorth

	| marsRover log |
	
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := MarsRoverLog new.
	marsRover addPositionObserver: log.
	
	marsRover process: 'f'.
	
	self assert: '0@1', Character newLineCharacter asString equals: log logs.
	! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 15:51:52'!
test02PositionLogWhenMoveSouth

	| marsRover log |
	
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingSouth.
	log := MarsRoverLog new.
	marsRover addPositionObserver: log.
	
	marsRover process: 'f'.
	
	self assert: '0@ -1',Character newLineCharacter asString equals: log logs.
	! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 15:51:55'!
test03PositionLogWhenMoveEast

	| marsRover log |
	
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingEast.
	log := MarsRoverLog new.
	marsRover addPositionObserver: log.
	
	marsRover process: 'f'.
	
	self assert: '1@0',Character newLineCharacter asString equals: log logs.
	! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 15:52:01'!
test04PositionLogWhenMoveWest

	| marsRover log |
	
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingWest.
	log := MarsRoverLog new.
	marsRover addPositionObserver: log.
	
	marsRover process: 'f'.
	
	self assert: '-1@0',Character newLineCharacter asString equals: log logs.
	! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:49:13'!
test05HeadingLogWhenRotatingRightToEast

	| marsRover log |
	
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := MarsRoverLog new.
	marsRover addHeadingObserver: log.
	
	marsRover process: 'r'.
	
	self assert: 'East', Character newLineCharacter asString equals: log logs.
	! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:49:18'!
test06HeadingLogWhenRotatingRightToSouth

	| marsRover log |
	
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingEast.
	log := MarsRoverLog new.
	marsRover addHeadingObserver: log.
	
	marsRover process: 'r'.
	
	self assert: 'South', Character newLineCharacter asString equals: log logs.
	! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:49:22'!
test07HeadingLogWhenRotatingRightToNorth

	| marsRover log |
	
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingWest.
	log := MarsRoverLog new.
	marsRover addHeadingObserver: log.
	
	marsRover process: 'r'.
	
	self assert: 'North', Character newLineCharacter asString equals: log logs.
	! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:49:29'!
test08HeadingLogWhenRotatingRigthToWest

	| marsRover log |
	
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingSouth.
	log := MarsRoverLog new.
	marsRover addHeadingObserver: log.
	
	marsRover process: 'r'.
	
	self assert: 'West', Character newLineCharacter asString equals: log logs.
	! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:49:37'!
test09HeadingLogWhenRotatingLeft

	| marsRover log |
	
	marsRover := MarsRover at: 0@0 heading: MarsRoverHeadingNorth.
	log := MarsRoverLog new.
	marsRover addHeadingObserver: log.
	
	marsRover process: 'l'.
	
	self assert: 'West', Character newLineCharacter asString equals: log logs.
	! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:57:40'!
test10WindowWhenMoving

	| marsRover window |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth .
	window := MarsRoverWindow new.
	marsRover addObserver: window.
	
	marsRover process: 'ff'.
	
	self assert: '1@3' equals: window window! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:51:51'!
test11WindowWhenRotateRightToEast

	| marsRover window |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingNorth .
	window := MarsRoverWindow new.
	marsRover addObserver: window.
	
	marsRover process: 'r'.
	
	self assert: ' Apuntando al Este' equals: window window! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:52:29'!
test12WindowWhenRotateRightToWest

	| marsRover window |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingSouth.
	window := MarsRoverWindow new.
	marsRover addObserver: window.
	
	marsRover process: 'r'.
	
	self assert: ' Apuntando al Oeste' equals: window window! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:59:02'!
test13WindowWhenRotateRightToSouth

	| marsRover window |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingEast.
	window := MarsRoverWindow new.
	marsRover addObserver: window.
	
	marsRover process: 'r'.
	
	self assert: ' Apuntando al Sur' equals: window window! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:59:54'!
test14WindowWhenRotateLeft

	| marsRover window |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingSouth.
	window := MarsRoverWindow new.
	marsRover addObserver: window.
	
	marsRover process: 'l'.
	
	self assert: ' Apuntando al Este' equals: window window! !

!MarsRoverObserverTest methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 17:00:00'!
test15WindowWhenRotateRightToNorth

	| marsRover window |
	
	marsRover := MarsRover at: 1@1 heading: MarsRoverHeadingWest.
	window := MarsRoverWindow new.
	marsRover addObserver: window.
	
	marsRover process: 'r'.
	
	self assert: ' Apuntando al Norte' equals: window window! !


!classDefinition: #MarsRoverTest category: 'MarsRover-WithHeading'!
TestCase subclass: #MarsRoverTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:21:23'!
test01DoesNotMoveWhenNoCommand

	self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: '' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:12'!
test02IsAtFailsForDifferentPosition

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@2 heading: self north)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:31'!
test03IsAtFailsForDifferentHeading

	| marsRover |
	
	marsRover := MarsRover at: 1@1 heading: self north . 
	
	self deny: (marsRover isAt: 1@1 heading: self south)! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:17'!
test04IncrementsYAfterMovingForwardWhenHeadingNorth

	self 
		assertIsAt: 1@3 
		heading: self north 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:30:11'!
test06DecrementsYAfterMovingBackwardsWhenHeadingNorth

	self 
		assertIsAt: 1@1 
		heading: self north 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:59'!
test07PointToEashAfterRotatingRightWhenHeadingNorth

	self 
		assertIsAt: 1@2 
		heading: self east 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:51'!
test08PointsToWestAfterRotatingLeftWhenPointingNorth

	self 
		assertIsAt: 1@2 
		heading: self west 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:45'!
test09DoesNotProcessInvalidCommand

	| marsRover |
	
	marsRover := MarsRover at: 1@2 heading: self north.
	
	self 
		should: [ marsRover process: 'x' ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText equals: marsRover invalidCommandErrorDescription.
			self assert: (marsRover isAt: 1@2 heading: self north) ]! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:39'!
test10CanProcessMoreThanOneCommand

	self 
		assertIsAt: 1@4 
		heading: self north 
		afterProcessing: 'ff' 
		whenStartingAt: 1@2 
		heading: self north 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:31'!
test11IncrementsXAfterMovingForwareWhenHeadingEast

	self 
		assertIsAt: 2@2 
		heading: self east 
		afterProcessing: 'f' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:19'!
test12DecrementsXAfterMovingBackwardWhenHeadingEast

	self 
		assertIsAt: 0@2 
		heading: self east 
		afterProcessing: 'b' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:14'!
test13PointsToSouthAfterRotatingRightWhenHeadingEast

		self 
		assertIsAt: 1@2 
		heading: self south 
		afterProcessing: 'r' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:05'!
test14PointsToNorthAfterRotatingLeftWhenPointingEast

		self 
		assertIsAt: 1@2 
		heading: self north 
		afterProcessing: 'l' 
		whenStartingAt: 1@2 
		heading: self east 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:29:00'!
test15ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingSouth

	self 
		assertIsAt: 1@1 
		heading: self west 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self south 
! !

!MarsRoverTest methodsFor: 'tests' stamp: 'HAW 10/7/2021 20:28:52'!
test16ForwardBackwardsAndRotateRightWorkAsExpectedWhenPointingWest

	self 
		assertIsAt: 0@2 
		heading: self north 
		afterProcessing: 'ffblrr' 
		whenStartingAt: 1@2 
		heading: self west 
! !


!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:31'!
east

	^ MarsRoverHeadingEast ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:38'!
north

	^ MarsRoverHeadingNorth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:45'!
south

	^ MarsRoverHeadingSouth ! !

!MarsRoverTest methodsFor: 'headings' stamp: 'HAW 10/7/2021 20:09:54'!
west

	^ MarsRoverHeadingWest ! !


!MarsRoverTest methodsFor: 'assertions' stamp: 'HAW 10/7/2021 20:20:47'!
assertIsAt: newPosition heading: newHeadingType afterProcessing: commands whenStartingAt: startPosition heading: startHeadingType

	| marsRover |
	
	marsRover := MarsRover at: startPosition heading: startHeadingType. 
	
	marsRover process: commands.
	
	self assert: (marsRover isAt: newPosition heading: newHeadingType)! !


!classDefinition: #ChagingVariable category: 'MarsRover-WithHeading'!
Object subclass: #ChagingVariable
	instanceVariableNames: 'variable observers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!ChagingVariable methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 15:10:00'!
addObserver:observer
	observers add: observer.! !

!ChagingVariable methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 15:10:06'!
changeTo: aNewVariable 
	variable := aNewVariable.
	self notifyVariable: variable.! !

!ChagingVariable methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:27:13'!
doesNotUnderstand: aMessage
	
	
	^aMessage sendTo: variable.
	
	! !

!ChagingVariable methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 15:10:13'!
initializeWith: aPosition 
	variable := aPosition.
	observers := OrderedCollection new.! !

!ChagingVariable methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:04:15'!
notifyVariable: aValue 

	observers do:[:observer| observer value: aValue].! !

!ChagingVariable methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 15:10:27'!
variable
	^variable! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'ChagingVariable class' category: 'MarsRover-WithHeading'!
ChagingVariable class
	instanceVariableNames: ''!

!ChagingVariable class methodsFor: 'instance creation' stamp: 'toto 10/30/2023 15:11:34'!
with: aPosition 
	
	^self new initializeWith: aPosition ! !


!classDefinition: #MarsRover category: 'MarsRover-WithHeading'!
Object subclass: #MarsRover
	instanceVariableNames: 'position heading observers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:48:45'!
invalidCommandErrorDescription
	
	^'Invalid command'! !

!MarsRover methodsFor: 'exceptions' stamp: 'HAW 6/30/2018 19:50:26'!
signalInvalidCommand
	
	self error: self invalidCommandErrorDescription ! !


!MarsRover methodsFor: 'initialization' stamp: 'toto 10/30/2023 16:03:30'!
initializeAt: aPosition heading: aHeadingType

	position := ChagingVariable with: aPosition.
	heading := ChagingVariable with:( aHeadingType for: self).
	observers:= OrderedCollection new.! !


!MarsRover methodsFor: 'heading' stamp: 'toto 10/30/2023 16:25:49'!
headEast
	
	heading changeTo:( MarsRoverHeadingEast for: self).! !

!MarsRover methodsFor: 'heading' stamp: 'toto 10/30/2023 16:25:53'!
headNorth
	
	heading changeTo:( MarsRoverHeadingNorth for: self).
	! !

!MarsRover methodsFor: 'heading' stamp: 'toto 10/30/2023 16:25:58'!
headSouth
	
	heading changeTo:(MarsRoverHeadingSouth for: self).
	! !

!MarsRover methodsFor: 'heading' stamp: 'toto 10/30/2023 16:26:01'!
headWest
	
	heading changeTo:( MarsRoverHeadingWest for: self).
	! !

!MarsRover methodsFor: 'heading' stamp: 'toto 10/30/2023 16:25:20'!
rotateLeft
	
	 heading rotateLeft .! !

!MarsRover methodsFor: 'heading' stamp: 'toto 10/30/2023 16:25:26'!
rotateRight
	
	 heading rotateRight .! !


!MarsRover methodsFor: 'testing' stamp: 'toto 10/30/2023 16:29:14'!
isAt: aPosition heading: aHeadingType

	^(position variable = aPosition) and: [ heading isHeading: aHeadingType ]! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:51'!
isBackwardCommand: aCommand

	^aCommand = $b! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:16:19'!
isForwardCommand: aCommand

	^aCommand = $f ! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:51'!
isRotateLeftCommand: aCommand

	^aCommand = $l! !

!MarsRover methodsFor: 'testing' stamp: 'HAW 7/6/2018 18:17:21'!
isRotateRightCommand: aCommand

	^aCommand = $r! !


!MarsRover methodsFor: 'moving' stamp: 'toto 10/30/2023 16:31:22'!
addToPosition: aVectorOfMovement
	position changeTo: position + aVectorOfMovement .
	
	! !

!MarsRover methodsFor: 'moving' stamp: 'toto 10/30/2023 16:03:30'!
moveBackward
	
	heading moveBackward! !

!MarsRover methodsFor: 'moving' stamp: 'toto 10/30/2023 16:30:05'!
moveEast
	self addToPosition:(1@0).
	
	! !

!MarsRover methodsFor: 'moving' stamp: 'toto 10/30/2023 16:03:30'!
moveForward
	
	heading moveForward! !

!MarsRover methodsFor: 'moving' stamp: 'toto 10/30/2023 16:31:51'!
moveNorth
	self addToPosition:(0@1).
	! !

!MarsRover methodsFor: 'moving' stamp: 'toto 10/30/2023 16:31:58'!
moveSouth
	self addToPosition:(0@-1).! !

!MarsRover methodsFor: 'moving' stamp: 'toto 10/30/2023 16:32:04'!
moveWest
	
	self addToPosition:(-1@0).! !


!MarsRover methodsFor: 'command processing' stamp: 'HAW 6/30/2018 19:48:26'!
process: aSequenceOfCommands

	aSequenceOfCommands do: [:aCommand | self processCommand: aCommand ]
! !

!MarsRover methodsFor: 'command processing' stamp: 'HAW 8/22/2019 12:08:50'!
processCommand: aCommand

	(self isForwardCommand: aCommand) ifTrue: [ ^ self moveForward ].
	(self isBackwardCommand: aCommand) ifTrue: [ ^ self moveBackward ].
	(self isRotateRightCommand: aCommand) ifTrue: [ ^ self rotateRight ].
	(self isRotateLeftCommand: aCommand) ifTrue: [ ^ self rotateLeft ].

	self signalInvalidCommand.! !


!MarsRover methodsFor: 'observer' stamp: 'toto 10/30/2023 16:03:30'!
addHeadingObserver: anObserver 
	heading addObserver: [:newHeading| anObserver notifyHeadingChangeTo: newHeading ].! !

!MarsRover methodsFor: 'observer' stamp: 'toto 10/30/2023 16:10:31'!
addObserver: window 
	self 
		addHeadingObserver: window; 
		addPositionObserver: window.
	
	! !

!MarsRover methodsFor: 'observer' stamp: 'toto 10/30/2023 16:32:38'!
addPositionObserver: anObserver 
	position addObserver: [:newPosition| anObserver notifyPositionChangeTo: newPosition ].! !


"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRover class' category: 'MarsRover-WithHeading'!
MarsRover class
	instanceVariableNames: 'headings'!

!MarsRover class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:10:30'!
at: aPosition heading: aHeadingType
	
	^self new initializeAt: aPosition heading: aHeadingType! !


!classDefinition: #MarsRoverHeading category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverHeading
	instanceVariableNames: 'marsRover'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeading methodsFor: 'heading' stamp: 'toto 10/30/2023 15:18:41'!
asString
	^self typeDescription.! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'heading' stamp: 'toto 10/30/2023 15:18:52'!
typeDescription

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'testing' stamp: 'HAW 10/7/2021 20:15:38'!
isHeading: aHeadingType

	^self isKindOf: aHeadingType ! !


!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	self subclassResponsibility ! !

!MarsRoverHeading methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward

	self subclassResponsibility ! !


!MarsRoverHeading methodsFor: 'initialization' stamp: 'toto 10/30/2023 15:24:11'!
initializeFor: aMarsRover 
	
	marsRover := aMarsRover.
! !

!MarsRoverHeading methodsFor: 'initialization' stamp: 'toto 10/30/2023 14:48:35'!
marsRover 
	
	^marsRover .! !


!MarsRoverHeading methodsFor: 'x' stamp: 'toto 10/30/2023 15:24:44'!
messagesToLog
	^{#rotateRight. #rotateLeft}.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MarsRoverHeading class' category: 'MarsRover-WithHeading'!
MarsRoverHeading class
	instanceVariableNames: ''!

!MarsRoverHeading class methodsFor: 'instance creation' stamp: 'HAW 10/7/2021 20:11:35'!
for: aMarsRover 
	
	^self new initializeFor: aMarsRover ! !


!classDefinition: #MarsRoverHeadingEast category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingEast
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveWest! !

!MarsRoverHeadingEast methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveEast! !


!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'toto 10/30/2023 15:05:14'!
rotateLeft
	
	^marsRover headNorth ! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'toto 10/30/2023 15:07:49'!
rotateRight
	
	^marsRover headSouth ! !

!MarsRoverHeadingEast methodsFor: 'heading' stamp: 'toto 10/30/2023 15:03:24'!
typeDescription
	^'East'! !


!MarsRoverHeadingEast methodsFor: 'accepting' stamp: 'toto 10/30/2023 16:15:38'!
accept: aVisitor 
	^aVisitor visitMarsRoverHeadingEast: self.! !


!classDefinition: #MarsRoverHeadingNorth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingNorth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveSouth! !

!MarsRoverHeadingNorth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveNorth! !


!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headWest! !

!MarsRoverHeadingNorth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headEast! !


!MarsRoverHeadingNorth methodsFor: 'accesing' stamp: 'toto 10/30/2023 15:02:31'!
typeDescription
	^'North'! !


!MarsRoverHeadingNorth methodsFor: 'accept' stamp: 'toto 10/30/2023 16:58:33'!
accept: aMarsRoverLog 
	^aMarsRoverLog visitMarsRoverHeadingNorth: self.! !


!classDefinition: #MarsRoverHeadingSouth category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingSouth
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward
	
	^marsRover moveNorth! !

!MarsRoverHeadingSouth methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveSouth! !


!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headEast! !

!MarsRoverHeadingSouth methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headWest! !


!MarsRoverHeadingSouth methodsFor: 'accept' stamp: 'toto 10/30/2023 16:58:38'!
accept: aMarsRoverLog 
	^aMarsRoverLog visitMarsRoverHeadingSouth: self.! !


!classDefinition: #MarsRoverHeadingWest category: 'MarsRover-WithHeading'!
MarsRoverHeading subclass: #MarsRoverHeadingWest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:24'!
moveBackward

	^marsRover moveEast! !

!MarsRoverHeadingWest methodsFor: 'moving' stamp: 'HAW 10/7/2021 20:13:53'!
moveForward
	
	^marsRover moveWest! !


!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:20'!
rotateLeft
	
	^marsRover headSouth! !

!MarsRoverHeadingWest methodsFor: 'heading' stamp: 'HAW 10/7/2021 20:14:44'!
rotateRight
	
	^marsRover headNorth! !


!MarsRoverHeadingWest methodsFor: 'accept' stamp: 'toto 10/30/2023 16:58:43'!
accept: aMarsRoverLog 
	^aMarsRoverLog visitMarsRoverHeadingWest: self.! !


!classDefinition: #MarsRoverLog category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverLog
	instanceVariableNames: 'variable'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverLog methodsFor: 'update' stamp: 'toto 10/30/2023 15:53:19'!
initialize 
	variable := WriteStream with: ''.! !

!MarsRoverLog methodsFor: 'update' stamp: 'toto 10/30/2023 16:36:35'!
notifyHeadingChangeTo: newHeading 
	newHeading accept:self.
	variable newLine.
	! !

!MarsRoverLog methodsFor: 'update' stamp: 'toto 10/30/2023 16:35:05'!
notifyPositionChangeTo: newPosition 
	variable nextPutAll: newPosition asString.
	variable newLine.! !


!MarsRoverLog methodsFor: 'log' stamp: 'toto 10/30/2023 15:44:30'!
logs
	^variable contents.! !


!MarsRoverLog methodsFor: 'visit' stamp: 'toto 10/30/2023 16:36:20'!
visitMarsRoverHeadingEast: aMarsRoverHeadingEast 
	variable nextPutAll: 'East'.
	! !

!MarsRoverLog methodsFor: 'visit' stamp: 'toto 10/30/2023 16:37:41'!
visitMarsRoverHeadingNorth: aMarsRoverHeadingNorth 
	variable nextPutAll: 'North'.
	! !

!MarsRoverLog methodsFor: 'visit' stamp: 'toto 10/30/2023 16:37:30'!
visitMarsRoverHeadingSouth: aMarsRoverHeadingSouth 
	variable nextPutAll: 'South'.
	! !

!MarsRoverLog methodsFor: 'visit' stamp: 'toto 10/30/2023 16:37:25'!
visitMarsRoverHeadingWest: aMarsRoverHeadingWest 
	variable nextPutAll: 'West'.
	! !


!classDefinition: #MarsRoverWindow category: 'MarsRover-WithHeading'!
Object subclass: #MarsRoverWindow
	instanceVariableNames: 'position heading'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'MarsRover-WithHeading'!

!MarsRoverWindow methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 15:56:38'!
initialize
	position:= ''.
	heading:= ''.! !

!MarsRoverWindow methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:56:59'!
visitMarsRoverHeadingEast: aMarsRoverHeadingEast 
	^' Apuntando al Este'! !

!MarsRoverWindow methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:56:56'!
visitMarsRoverHeadingNorth: aMarsRoverHeadingNorth
	^' Apuntando al Norte'! !

!MarsRoverWindow methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:56:53'!
visitMarsRoverHeadingSouth: aMarsRoverHeadingSouth
	^' Apuntando al Sur'! !

!MarsRoverWindow methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:56:50'!
visitMarsRoverHeadingWest: aMarsRoverHeadingWest
	^' Apuntando al Oeste'! !

!MarsRoverWindow methodsFor: 'as yet unclassified' stamp: 'toto 10/30/2023 16:57:15'!
window
	^position asString,heading.! !


!MarsRoverWindow methodsFor: 'update' stamp: 'toto 10/30/2023 16:14:39'!
notifyHeadingChangeTo: newHeading 
	heading:= newHeading accept: self.
	! !

!MarsRoverWindow methodsFor: 'update' stamp: 'toto 10/30/2023 16:12:30'!
notifyPositionChangeTo: newPosition 
	position := newPosition.
	
	! !

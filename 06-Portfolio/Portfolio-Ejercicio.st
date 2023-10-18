!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/16/2023 18:48:32'!
test02PortfolioWithSingleReceptiveAccountHasSameBalanceAndTransactions

	| aReceptiveAccount portfolio aDeposit |
	
	aReceptiveAccount := ReceptiveAccount new.
	aDeposit:= (Deposit for: 1).
	aReceptiveAccount register: aDeposit.
	portfolio := Portfolio from: {aReceptiveAccount}.
	
	self assert: portfolio balance equals: 1.
	self assert: (portfolio transactions difference: aReceptiveAccount transactions ) isEmpty .
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/16/2023 23:02:43'!
test03PortfolioWithMoreThanOneReceptiveAccount

	| aReceptiveAccount portfolio anotherReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	aReceptiveAccount register:( Deposit for: 1).
	
	anotherReceptiveAccount := ReceptiveAccount new.
	anotherReceptiveAccount register: (Deposit for:2).
	
	portfolio := Portfolio from: {aReceptiveAccount. anotherReceptiveAccount }.
	
	self assert: portfolio balance equals: 3.
	self assert: (portfolio transactions difference: aReceptiveAccount transactions, anotherReceptiveAccount transactions ) isEmpty .
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/16/2023 23:03:04'!
test04CanNotCreatePortfolioWithDuplicatedReceptiveAccounts

	| aReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	self should:[Portfolio from: {aReceptiveAccount. aReceptiveAccount }] raise: Error withMessageText: 'No se puede crear portfolio con cuentas duplicadas'.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/16/2023 23:03:19'!
test05CanNotCreateEmptyPortfolio

	self should:[Portfolio from: {}] raise: Error withMessageText: 'No se puede crear portfolio sin cuentas'.! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/17/2023 15:06:18'!
test06CanNotCreatePortofolioWithReceptiveAccountAndPortfolioWithTheSameReceptiveAccount
	
	| aReceptiveAccount portfolio |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	portfolio := Portfolio from: {aReceptiveAccount}.
	
	self should: [ Portfolio from: {portfolio. aReceptiveAccount} ]raise: Error - MessageNotUnderstood withMessageText: 'No se puede crear portfolio con cuentas duplicadas'! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/17/2023 16:03:32'!
test07CanNotCreatePortofolioWithDuplicatedReceptiveAccountsInAnyDeepLevel
	
	| aReceptiveAccount aPortfolio anotherPortfolio |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	aPortfolio := Portfolio from: {aReceptiveAccount}.
	
	anotherPortfolio := Portfolio from:{aPortfolio}.
	
	self should: [ Portfolio from: {anotherPortfolio. aReceptiveAccount } ]raise: Error withMessageText: 'No se puede crear portfolio con cuentas duplicadas'! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/17/2023 04:11:39'!
test08PortfolioCanAddReceptiveAccount
	
	| aReceptiveAccount aPortfolio anotherReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	anotherReceptiveAccount := ReceptiveAccount  new.
	
	aReceptiveAccount register: (Deposit  for:1).
	anotherReceptiveAccount register: (Deposit for:2).
	
	aPortfolio := Portfolio from: {aReceptiveAccount}.
	aPortfolio associateWith: anotherReceptiveAccount.
	
	self assert: aPortfolio balance equals: 3.
	self assert: (aPortfolio transactions difference: (aReceptiveAccount transactions, anotherReceptiveAccount transactions)) isEmpty .
! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/16/2023 23:06:45'!
test09PortfolioCanNotAddReceptiveAccountAlreadyAsociated
	
	| aReceptiveAccount portfolio |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	portfolio := Portfolio from: {aReceptiveAccount}.
	
	self should: [ portfolio associateWith: aReceptiveAccount ]raise: Error - MessageNotUnderstood withMessageText: 'No se puede crear portfolio con cuentas duplicadas'! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/17/2023 04:20:08'!
test10PortfolioCanAddPortfolio
	"Cambiar nombre SI O SI"
	| aReceptiveAccount portfolio anotherPortfolio |
	
	
	aReceptiveAccount := ReceptiveAccount new.
	aReceptiveAccount register: (Deposit for: 1).
	anotherPortfolio := Portfolio from: {aReceptiveAccount}.
	
	portfolio := Portfolio from:{anotherPortfolio}.
	
	
	self assert: portfolio balance equals: 1.
	self assert: (portfolio transactions difference: (anotherPortfolio transactions))isEmpty .
	
	! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/17/2023 16:26:22'!
test11PortfolioCanNotAddPortfolioIfBothHaveOneSameReceptiveAccountAssociated
	
	| aReceptiveAccount portfolio anotherPortfolio |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	portfolio := Portfolio from: {aReceptiveAccount}.
	anotherPortfolio:= Portfolio from:{aReceptiveAccount}.
	
	self should: [ portfolio associateWith: anotherPortfolio ]raise: Error - MessageNotUnderstood withMessageText: 'No se puede crear portfolio con cuentas duplicadas'! !

!PortfolioTest methodsFor: 'as yet unclassified' stamp: 'toto 10/17/2023 20:04:10'!
test12CanRemoveAccountFromPortfolio
	"No lo pide la consigna pero lo agregamos igual"
	
	| aReceptiveAccount portfolio  anotherReceptiveAccount oldPortfolio |
	
	aReceptiveAccount := ReceptiveAccount new.
	aReceptiveAccount register: (Deposit for: 1).
	
	anotherReceptiveAccount:= ReceptiveAccount new.
	anotherReceptiveAccount register: (Deposit for: 2).
	
	portfolio := Portfolio from:{aReceptiveAccount. anotherReceptiveAccount}.
	portfolio dissociateWith: anotherReceptiveAccount.
	
	oldPortfolio := Portfolio from:{aReceptiveAccount. anotherReceptiveAccount}.
	
	
	"self assert: portfolio balance equals: 1.
	self assert: (portfolio transactions difference: oldPortfolio transactions) equals: aReceptiveAccount transactions .
	"
	! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:44'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:48'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:13:52'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance.
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:46'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 5/17/2021 17:29:53'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| deposit withdraw account |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 200.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'NR 11/2/2020 17:14:01'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 50 on: account1.
		
	self assert: 1 equals: account1 transactions size.
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #Account category: 'Portfolio-Ejercicio'!
Object subclass: #Account
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Account methodsFor: 'asociatedAccounts' stamp: 'toto 10/16/2023 22:59:56'!
associatedAccounts

	self subclassResponsibility! !


!Account methodsFor: 'balance' stamp: 'toto 10/16/2023 23:00:06'!
balance

	self subclassResponsibility! !


!Account methodsFor: 'transactions' stamp: 'toto 10/16/2023 23:00:11'!
transactions

	self subclassResponsibility! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Account subclass: #Portfolio
	instanceVariableNames: 'receptiveAccountCollection'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'transactions' stamp: 'toto 10/17/2023 20:19:01'!
transactions

	^(receptiveAccountCollection collect:[:receptiveAccount | receptiveAccount transactions ]) asOrderedCollection flatten.
	! !


!Portfolio methodsFor: 'balance' stamp: 'toto 10/16/2023 18:35:52'!
balance 
	^receptiveAccountCollection sum:[:receptiveAccount | receptiveAccount balance].
	

	! !


!Portfolio methodsFor: 'initialize' stamp: 'toto 10/17/2023 16:43:00'!
initializeFrom: anAccountCollection
	
	anAccountCollection ifEmpty: [self raiseEmptyReceptiveAccountCollectionError].
	
	receptiveAccountCollection:= Set new.
	
	anAccountCollection do:[:account| self associateWith: account].
		
! !


!Portfolio methodsFor: 'asociatedAccounts' stamp: 'toto 10/17/2023 22:45:39'!
associateWith: anAccount 

	| associatedAccounts |
	
	associatedAccounts := self associatedAccounts.
	
	((anAccount associatedAccounts intersection: associatedAccounts) isEmpty) 
		ifTrue:[^receptiveAccountCollection add: anAccount]
		ifFalse:[self raiseDuplicatedReceptiveAccount].
	
	! !

!Portfolio methodsFor: 'asociatedAccounts' stamp: 'toto 10/17/2023 16:53:07'!
associatedAccounts 

	^(receptiveAccountCollection collect:[:account| account associatedAccounts ] ) asOrderedCollection flatten asSet.
	
	

	! !


!Portfolio methodsFor: 'exceptions' stamp: 'toto 10/17/2023 16:37:59'!
raiseDuplicatedReceptiveAccount

	^ self error:'No se puede crear portfolio con cuentas duplicadas'! !

!Portfolio methodsFor: 'exceptions' stamp: 'toto 10/17/2023 16:38:03'!
raiseEmptyReceptiveAccountCollectionError

	^ self error: 'No se puede crear portfolio sin cuentas'! !


!Portfolio methodsFor: 'remove' stamp: 'toto 10/17/2023 20:18:16'!
dissociateWith: anAccount 

	receptiveAccountCollection remove: anAccount.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'instance creation' stamp: 'toto 10/17/2023 16:36:16'!
from: anAccountCollection 
	
	^self new initializeFrom: anAccountCollection ! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'NR 10/17/2019 15:06:56'!
initialize

	transactions := OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'toto 10/17/2023 20:17:58'!
balance

	^transactions sum: [ :aTransaction | aTransaction valueAsSeenFromParty ] ifEmpty: [0]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !


!ReceptiveAccount methodsFor: 'accesing' stamp: 'toto 10/17/2023 16:52:39'!
associatedAccounts

	^Set with: self. ! !


!classDefinition: #AccountTransaction category: 'Portfolio-Ejercicio'!
Object subclass: #AccountTransaction
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!AccountTransaction methodsFor: 'value' stamp: 'toto 10/17/2023 20:18:05'!
value

	^value! !

!AccountTransaction methodsFor: 'value' stamp: 'toto 10/16/2023 18:00:16'!
valueAsSeenFromParty 

	self subclassResponsibility ! !


!AccountTransaction methodsFor: 'initialization' stamp: 'toto 10/17/2023 04:22:26'!
initializeFor: aValue

	value:= aValue.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Ejercicio'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'toto 10/17/2023 04:23:40'!
for: aValue

	^ self new initializeFor: aValue ! !

!AccountTransaction class methodsFor: 'instance creation' stamp: 'NR 10/17/2019 03:22:00'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Deposit methodsFor: 'value' stamp: 'toto 10/16/2023 18:00:20'!
valueAsSeenFromParty
	^value! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'value' stamp: 'toto 10/16/2023 18:00:40'!
valueAsSeenFromParty
	^value negated.! !

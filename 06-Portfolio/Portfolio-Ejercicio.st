!classDefinition: #PortfolioTest category: 'Portfolio-Ejercicio'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!PortfolioTest methodsFor: 'asserting' stamp: 'IB 10/19/2023 13:27:06'!
assertBalanceOf: aPortfolio equalsTo: aBalance andHasOnlyTransactionsIn: aTransactionCollection

	self 
		assert: aPortfolio balance equals: aBalance;
		assert: (aPortfolio transactions difference: aTransactionCollection) isEmpty
	
	! !

!PortfolioTest methodsFor: 'asserting' stamp: 'IB 10/19/2023 13:18:34'!
assertDuplicatedAccountsErrorRaiseWhenCreatingPortfolioAssociatingAllIn: anAccountCollection
	
	self 
		should: [Portfolio from: anAccountCollection] 
		raise: Error - MessageNotUnderstood  
		withMessageText: 'No se puede crear portfolio con cuentas duplicadas'.! !


!PortfolioTest methodsFor: 'tests - fails' stamp: 'IB 10/19/2023 13:19:22'!
test04CantCreatePortfolioWithDuplicatedReceptiveAccounts

	| aReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	self assertDuplicatedAccountsErrorRaiseWhenCreatingPortfolioAssociatingAllIn: {aReceptiveAccount. aReceptiveAccount }! !

!PortfolioTest methodsFor: 'tests - fails' stamp: 'IB 10/19/2023 13:19:39'!
test05CantCreatePortfolioWithoutAssociatedAccounts

	self 
		should: [Portfolio from: {}] 
		raise: Error 
		withMessageText: 'No se puede crear portfolio sin cuentas'! !

!PortfolioTest methodsFor: 'tests - fails' stamp: 'IB 10/19/2023 13:20:03'!
test06CantCreatePortofolioWithReceptiveAccountAndPortfolioWithTheSameReceptiveAccount
	
	| receptiveAccount portfolio |
	
	receptiveAccount := ReceptiveAccount new.
	portfolio := Portfolio from: {receptiveAccount}.
	
	self assertDuplicatedAccountsErrorRaiseWhenCreatingPortfolioAssociatingAllIn:{portfolio. receptiveAccount}! !

!PortfolioTest methodsFor: 'tests - fails' stamp: 'IB 10/19/2023 13:20:11'!
test07CantCreatePortofolioWithDuplicatedReceptiveAccountsInAnyDeepLevel
	
	| receptiveAccount portfolio anotherPortfolio |
	
	receptiveAccount := ReceptiveAccount new.
	portfolio := Portfolio from: {receptiveAccount}.
	anotherPortfolio := Portfolio from:{portfolio}.
	
	self assertDuplicatedAccountsErrorRaiseWhenCreatingPortfolioAssociatingAllIn:{anotherPortfolio. receptiveAccount}! !

!PortfolioTest methodsFor: 'tests - fails' stamp: 'IB 10/19/2023 13:21:54'!
test09CantAssociateReceptiveAccountAlreadyAsociated
	
	| aReceptiveAccount portfolio |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	portfolio := Portfolio from: {aReceptiveAccount}.
	
	self 
		should: [ portfolio associateWith: aReceptiveAccount ]
		raise: Error - MessageNotUnderstood 
		withMessageText: 'No se puede crear portfolio con cuentas duplicadas'! !

!PortfolioTest methodsFor: 'tests - fails' stamp: 'IB 10/19/2023 13:21:44'!
test11CantAssociatePortfolioIfBothHaveTheSameReceptiveAccountAssociated
	
	| aReceptiveAccount portfolio anotherPortfolio |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	portfolio := Portfolio from: {aReceptiveAccount}.
	anotherPortfolio:= Portfolio from:{aReceptiveAccount}.
	
	self should: [ portfolio associateWith: anotherPortfolio ]raise: Error - MessageNotUnderstood withMessageText: 'No se puede crear portfolio con cuentas duplicadas'! !


!PortfolioTest methodsFor: 'tests' stamp: 'IB 10/19/2023 13:29:17'!
test02PortfolioWithSingleReceptiveAccountHasSameBalanceAndTransactions

	| receptiveAccount portfolio |
	
	receptiveAccount := 
		ReceptiveAccount new
			register: (Deposit for: 1); 
			yourself.
			
	portfolio := Portfolio from: {receptiveAccount}.
	
	self assertBalanceOf: portfolio equalsTo: 1 andHasOnlyTransactionsIn: receptiveAccount transactions
	! !

!PortfolioTest methodsFor: 'tests' stamp: 'IB 10/19/2023 13:29:13'!
test03PortfolioWithMoreThanOneReceptiveAccount

	| aReceptiveAccount portfolio anotherReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	aReceptiveAccount register:( Deposit for: 1).
	anotherReceptiveAccount := ReceptiveAccount new.
	anotherReceptiveAccount register: (Deposit for:2).
	
	portfolio := Portfolio from: {aReceptiveAccount. anotherReceptiveAccount }.
	
	self 
		assertBalanceOf: portfolio 
		equalsTo: 3 
		andHasOnlyTransactionsIn: (aReceptiveAccount transactions, anotherReceptiveAccount transactions)
	! !

!PortfolioTest methodsFor: 'tests' stamp: 'IB 10/19/2023 13:29:09'!
test08AssociateReceptiveAccount
	
	| aReceptiveAccount portfolio anotherReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	anotherReceptiveAccount := ReceptiveAccount  new.
	aReceptiveAccount register: (Deposit  for:1).
	anotherReceptiveAccount register: (Deposit for:2).
	portfolio := Portfolio from: {aReceptiveAccount}.
	
	portfolio associateWith: anotherReceptiveAccount.
	
	self 
		assertBalanceOf: portfolio 
		equalsTo: 3 
		andHasOnlyTransactionsIn: (aReceptiveAccount transactions, anotherReceptiveAccount transactions)
! !

!PortfolioTest methodsFor: 'tests' stamp: 'IB 10/19/2023 13:28:38'!
test10CanAssociateWithPortfolio
	
	| aReceptiveAccount portfolio anotherPortfolio |
	
	aReceptiveAccount := ReceptiveAccount new.
	aReceptiveAccount register: (Deposit for: 1).
	anotherPortfolio := Portfolio from: {aReceptiveAccount}.
	
	portfolio := Portfolio from:{anotherPortfolio}.
	
	self 
		assertBalanceOf: portfolio 
		equalsTo: 1
		andHasOnlyTransactionsIn: anotherPortfolio transactions
	
	! !

!PortfolioTest methodsFor: 'tests' stamp: 'IB 10/19/2023 13:29:02'!
test12CanRemoveAccountFromPortfolio
	"No lo pide la consigna pero lo agregamos igual"
	
	| aReceptiveAccount portfolio  anotherReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	aReceptiveAccount register: (Deposit for: 1).
	anotherReceptiveAccount:= ReceptiveAccount new.
	anotherReceptiveAccount register: (Deposit for: 2).
	portfolio := Portfolio from:{aReceptiveAccount. anotherReceptiveAccount}.
	
	portfolio dissociateWith: anotherReceptiveAccount.
	
	self 
		assertBalanceOf: portfolio 
		equalsTo: 1
		andHasOnlyTransactionsIn: aReceptiveAccount transactions
	
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

!Account methodsFor: 'asociatedAccounts' stamp: 'IB 10/19/2023 13:04:15'!
associatedReceptiveAccounts

	self subclassResponsibility! !


!Account methodsFor: 'balance' stamp: 'toto 10/16/2023 23:00:06'!
balance

	self subclassResponsibility! !


!Account methodsFor: 'transactions' stamp: 'toto 10/16/2023 23:00:11'!
transactions

	self subclassResponsibility! !


!classDefinition: #Portfolio category: 'Portfolio-Ejercicio'!
Account subclass: #Portfolio
	instanceVariableNames: 'associatedAccounts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Portfolio methodsFor: 'accesing' stamp: 'IB 10/19/2023 13:05:05'!
associatedAccounts 

	^associatedAccounts
	
	

	! !

!Portfolio methodsFor: 'accesing' stamp: 'IB 10/19/2023 13:06:06'!
associatedReceptiveAccounts 

	^(self associatedAccounts collect: #associatedReceptiveAccounts) asOrderedCollection flatten asSet.
	
	

	! !

!Portfolio methodsFor: 'accesing' stamp: 'IB 10/19/2023 13:04:44'!
associatedReceptiveAccountsAlsoIn: anAccount

	^ self associatedReceptiveAccounts intersection: anAccount associatedReceptiveAccounts! !

!Portfolio methodsFor: 'accesing' stamp: 'IB 10/19/2023 13:05:27'!
balance

	^self associatedAccounts sum: #balance
	

	! !

!Portfolio methodsFor: 'accesing' stamp: 'IB 10/19/2023 13:06:40'!
transactions

	^(self associatedAccounts collect: #transactions) asOrderedCollection flatten
	! !


!Portfolio methodsFor: 'initialize' stamp: 'IB 10/19/2023 13:03:53'!
initializeFrom: anAccountCollection

	associatedAccounts := anAccountCollection asSet! !


!Portfolio methodsFor: 'register' stamp: 'IB 10/19/2023 13:08:18'!
associateAfterValidityChecksWith: anAccount

	^ self associatedAccounts add: anAccount! !

!Portfolio methodsFor: 'register' stamp: 'IB 10/19/2023 13:08:28'!
associateWith: anAccount 
	
	self assertCanAssociate: anAccount.
	
	^self associateAfterValidityChecksWith: anAccount
		
	
	! !

!Portfolio methodsFor: 'register' stamp: 'IB 10/19/2023 13:08:33'!
dissociateWith: anAccount 

	^self associatedAccounts remove: anAccount! !


!Portfolio methodsFor: 'assert' stamp: 'IB 10/19/2023 13:04:44'!
assertCanAssociate: anAccount 
	
	(self associatedReceptiveAccountsAlsoIn: anAccount) ifNotEmpty: [self class raiseDuplicatedAccountError].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Ejercicio'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'support' stamp: 'IB 10/19/2023 13:04:15'!
receptiveAccountsIn: anAccountCollection

	^ (anAccountCollection collect: [:account | account associatedReceptiveAccounts]) flatten! !


!Portfolio class methodsFor: 'instance creation' stamp: 'IB 10/19/2023 12:59:56'!
from: anAccountCollection 

	self assertValidAccountsToAssociate: anAccountCollection.
	
	^self new initializeFrom: anAccountCollection
	
	
	! !


!Portfolio class methodsFor: 'exceptions' stamp: 'IB 10/19/2023 12:54:07'!
raiseDuplicatedAccountError

	^ self error: 'No se puede crear portfolio con cuentas duplicadas'! !

!Portfolio class methodsFor: 'exceptions' stamp: 'IB 10/19/2023 12:53:45'!
raiseEmptyAccountCollectionError

	^ self error: 'No se puede crear portfolio sin cuentas'! !


!Portfolio class methodsFor: 'testing--private' stamp: 'IB 10/19/2023 12:54:35'!
containsDuplicatedAccount: anAccountCollection

	^ anAccountCollection asSet size ~=  anAccountCollection size! !


!Portfolio class methodsFor: 'asserting' stamp: 'IB 10/19/2023 12:57:58'!
assertNoDuplicatedAccountsIn: associatedAccounts

	^ (self containsDuplicatedAccount: associatedAccounts) ifTrue: [ self raiseDuplicatedAccountError ]! !

!Portfolio class methodsFor: 'asserting' stamp: 'IB 10/19/2023 12:53:45'!
assertNotEmptyAccountCollection: anAccountCollection

	^ anAccountCollection ifEmpty: [self raiseEmptyAccountCollectionError]! !

!Portfolio class methodsFor: 'asserting' stamp: 'IB 10/19/2023 12:59:56'!
assertValidAccountsToAssociate: anAccountCollection

	| associatedAccounts |
	
	associatedAccounts := self receptiveAccountsIn: anAccountCollection.
	
	self assertNotEmptyAccountCollection: associatedAccounts.
	self assertNoDuplicatedAccountsIn: associatedAccounts! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Ejercicio'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'IB 10/19/2023 13:09:22'!
initialize

	transactions := OrderedCollection new! !


!ReceptiveAccount methodsFor: 'register' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/17/2019 03:28:43'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !


!ReceptiveAccount methodsFor: 'accesing' stamp: 'IB 10/19/2023 13:04:15'!
associatedReceptiveAccounts

	^Set with: self! !

!ReceptiveAccount methodsFor: 'accesing' stamp: 'IB 10/19/2023 13:09:08'!
balance

	^transactions sum: #valueAsSeenFromParty ifEmpty: [0]! !

!ReceptiveAccount methodsFor: 'accesing' stamp: 'IB 10/19/2023 13:08:49'!
transactions

	^ transactions copy! !


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


!AccountTransaction methodsFor: 'initialization' stamp: 'IB 10/19/2023 13:09:57'!
initializeFor: aValue

	value := aValue! !

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

!Deposit methodsFor: 'value' stamp: 'IB 10/19/2023 13:10:09'!
valueAsSeenFromParty

	^ self value! !


!classDefinition: #Withdraw category: 'Portfolio-Ejercicio'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Ejercicio'!

!Withdraw methodsFor: 'value' stamp: 'IB 10/19/2023 13:10:16'!
valueAsSeenFromParty

	^ self value negated! !

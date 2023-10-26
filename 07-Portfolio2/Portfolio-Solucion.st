!classDefinition: #AccountReportTest category: 'Portfolio-Solucion'!
TestCase subclass: #AccountReportTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountReportTest methodsFor: 'transferNet' stamp: 'toto 10/25/2023 23:48:35'!
test09TransferNetReportOfvirginReceptiveAccount
	
	| aReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	self assert: ((TransferNetReport  of: aReceptiveAccount) apply) equals:0
	.
	
	! !

!AccountReportTest methodsFor: 'transferNet' stamp: 'toto 10/25/2023 23:48:35'!
test10TransferNetReportOfReceptiveAccountWithOneTransfer
	
	| aReceptiveAccount anotherReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	anotherReceptiveAccount:= ReceptiveAccount new.
	
	Transfer register: 100 from: aReceptiveAccount to:anotherReceptiveAccount.
	
	self assert: ((TransferNetReport  of: aReceptiveAccount) apply) equals: -100.
	self assert: ((TransferNetReport  of: anotherReceptiveAccount ) apply) equals:100.
	.
	
	! !

!AccountReportTest methodsFor: 'transferNet' stamp: 'toto 10/25/2023 23:48:35'!
test11TransferNetReportOfReceptiveAccountDoesntTakeInConsiderationOtherTransactions
	
	| aReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	
	Deposit register:100 on: aReceptiveAccount.
	Withdraw register: 99 on: aReceptiveAccount.
	
	self assert: ((TransferNetReport  of: aReceptiveAccount) apply) equals: 0.
	
	
	
	! !

!AccountReportTest methodsFor: 'transferNet' stamp: 'toto 10/25/2023 23:48:35'!
test12TransferNetReportOfReceptiveWithMoreThanOneTransfer
	
	| aReceptiveAccount anotherReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	anotherReceptiveAccount:= ReceptiveAccount new.
	
	Transfer register: 100 from: aReceptiveAccount to:anotherReceptiveAccount.
	Transfer register: 99 from: anotherReceptiveAccount to: aReceptiveAccount.
	
	self assert: ((TransferNetReport  of: aReceptiveAccount) apply) equals: -1.
	self assert: ((TransferNetReport  of: anotherReceptiveAccount ) apply) equals:1.
	
	
	
	! !


!AccountReportTest methodsFor: 'support' stamp: 'toto 10/25/2023 20:10:04'!
balanceFor: aValue

	^ 'Balance = ', aValue asString.! !

!AccountReportTest methodsFor: 'support' stamp: 'toto 10/25/2023 20:09:03'!
depositReportDescription

	^ 'Deposito por 100'! !

!AccountReportTest methodsFor: 'support' stamp: 'toto 10/25/2023 20:10:37'!
transferDepositReportDescription

	^ 'Entrada por transferencia de 100'! !

!AccountReportTest methodsFor: 'support' stamp: 'toto 10/25/2023 20:09:57'!
transferWithdrawReportDescription

	^ 'Salida por transferencia de 100'! !

!AccountReportTest methodsFor: 'support' stamp: 'toto 10/25/2023 20:10:21'!
withdrawReportDescription

	^ 'Extraccion por 100'! !


!AccountReportTest methodsFor: 'accountSummary' stamp: 'toto 10/25/2023 22:40:10'!
test01AccountSummaryReportOfVirginReceptiveAccount
	| aReceptiveAccount |
	
	aReceptiveAccount := ReceptiveAccount new.
	
	self assert: ((AccountSummaryReport  of: aReceptiveAccount) apply) equals: (self balanceFor: 0).
	
	! !

!AccountReportTest methodsFor: 'accountSummary' stamp: 'toto 10/26/2023 02:50:22'!
test02AccountSummaryReportOfReceptiveAccountWithDeposit
	| aReceptiveAccount report |
	
	aReceptiveAccount := ReceptiveAccount new.
	Deposit register: 100 on: aReceptiveAccount .
	report:= WriteStream with: self depositReportDescription.
	report newLine.
	report nextPutAll:( self balanceFor:100).
	
	
	self assert: ((AccountSummaryReport  of: aReceptiveAccount) apply) equals: report contents
	
	! !

!AccountReportTest methodsFor: 'accountSummary' stamp: 'toto 10/26/2023 02:50:32'!
test03AccountSummaryReportOfReceptiveAccountWithWithdraw
	| aReceptiveAccount report |
	
	aReceptiveAccount := ReceptiveAccount new.
	Withdraw register: 100 on: aReceptiveAccount .
	report:= WriteStream with: self withdrawReportDescription.
	report newLine.
	report nextPutAll:( self balanceFor: -100).
	self assert: ((AccountSummaryReport  of: aReceptiveAccount) apply) equals:report contents
	
	! !

!AccountReportTest methodsFor: 'accountSummary' stamp: 'toto 10/26/2023 02:50:39'!
test04AccountSummaryReportOfReceptiveAccountWithTransfer
	| aReceptiveAccount anotherReceptiveAccount report |
	
	aReceptiveAccount := ReceptiveAccount new.
	anotherReceptiveAccount := ReceptiveAccount new.
	
	Transfer register: 100 from: aReceptiveAccount to: anotherReceptiveAccount.
	report:= WriteStream with: self transferWithdrawReportDescription .
	report newLine.
	report nextPutAll:( self balanceFor: -100).
	self assert: ((AccountSummaryReport  of: aReceptiveAccount) apply) equals:report contents.
	report:= WriteStream with: self transferDepositReportDescription .
	report newLine.
	report nextPutAll:( self balanceFor:100).
	
	self assert: ((AccountSummaryReport  of: anotherReceptiveAccount) apply) equals:report contents.
	! !

!AccountReportTest methodsFor: 'accountSummary' stamp: 'toto 10/26/2023 02:50:44'!
test05AccountSummaryReportOfReceptiveAccountWithMoreThanOneTransaction
	| aReceptiveAccount anotherReceptiveAccount report |
	
	aReceptiveAccount := ReceptiveAccount new.
	anotherReceptiveAccount := ReceptiveAccount new.
	
	Transfer register: 100 from: aReceptiveAccount to: anotherReceptiveAccount.
	Deposit register: 100 on: aReceptiveAccount.
	
	report:= WriteStream with: self transferWithdrawReportDescription .
	report newLine.
	report nextPutAll: self depositReportDescription.
	report newLine.
	report nextPutAll:( self balanceFor:0).
	self assert: ((AccountSummaryReport  of: aReceptiveAccount) apply) equals:report contents	
	! !

!AccountReportTest methodsFor: 'accountSummary' stamp: 'toto 10/25/2023 22:47:01'!
test06AccountSummaryReportOfEmptyPortfolio
	
	| aPortfolio |
	aPortfolio := Portfolio new.
	self assert: ((AccountSummaryReport  of: aPortfolio) apply) equals:(self balanceFor: 0) .
	
	! !

!AccountReportTest methodsFor: 'accountSummary' stamp: 'toto 10/26/2023 02:50:52'!
test07AccountSummaryReportOfPortfolioWithOneReceptiveAccount
	
	| aPortfolio aReceptiveAccount report |
	aPortfolio := Portfolio new.
	aReceptiveAccount:= ReceptiveAccount new.
	
	Deposit register: 100 on: aReceptiveAccount.
	aPortfolio add:aReceptiveAccount .
	
	report:= WriteStream with: self depositReportDescription .
	report newLine.
	report nextPutAll:( self balanceFor: 100).
	self assert: ((AccountSummaryReport  of: aPortfolio) apply) equals:report contents.
	
	! !

!AccountReportTest methodsFor: 'accountSummary' stamp: 'toto 10/26/2023 02:50:57'!
test08AccountSummaryReportOfPortfolioWithMoreThanOneReceptiveAccount
	
	| aPortfolio aReceptiveAccount anotherReceptiveAccount report |
	aPortfolio := Portfolio new.
	aReceptiveAccount:= ReceptiveAccount new.
	anotherReceptiveAccount:= ReceptiveAccount new.
	Deposit register: 100 on: aReceptiveAccount.
	Withdraw register: 100 on: anotherReceptiveAccount.
	
	aPortfolio add:aReceptiveAccount .
	aPortfolio add:anotherReceptiveAccount .
	
	report:= WriteStream with: self depositReportDescription .
	report newLine.
	report nextPutAll: self withdrawReportDescription .
	report newLine.
	report nextPutAll:( self balanceFor:0).
	self assert: ((AccountSummaryReport  of: aPortfolio) apply) equals:report contents.
	
	! !


!AccountReportTest methodsFor: 'bonus' stamp: 'toto 10/26/2023 02:50:01'!
test17PortfolioSummaryReportOfEmptyPortfolio
	| portfolio report |
	portfolio:= Portfolio named: 'familia'.

	report:= WriteStream with: portfolio name.
	report newLineTab:1.
	report nextPutAll:( self balanceFor:0).
	
	self assert: (BonusReport of: portfolio) apply equals: report contents.	! !

!AccountReportTest methodsFor: 'bonus' stamp: 'toto 10/26/2023 02:49:56'!
test18PortfolioSummaryReportOfPortfolioWithOneReceptiveAccount
	| portfolio aReceptiveAccount report |
	
	aReceptiveAccount := ReceptiveAccount named:'Maria'.
	
	portfolio:= (Portfolio named: 'familia') add:aReceptiveAccount.
	
	Deposit register: 100 on: aReceptiveAccount.
	
	
	report:= WriteStream with: portfolio name.
	report newLineTab:1.
	report nextPutAll:aReceptiveAccount name.
	report newLineTab:2.
	report nextPutAll: self depositReportDescription.
	report newLineTab:2.
	report nextPutAll: (self balanceFor: 100).
	report newLineTab:1.
	report nextPutAll:(self balanceFor:100).
	
	self assert: (BonusReport of: portfolio) apply equals: report contents.	! !

!AccountReportTest methodsFor: 'bonus' stamp: 'toto 10/26/2023 02:49:47'!
test19PortfolioSummaryReportOfPortfolioWithMoreOneReceptiveAccount
	| portfolio aReceptiveAccount anotherReceptiveAccount report |
	
	aReceptiveAccount := ReceptiveAccount named:'Maria'.
	anotherReceptiveAccount:= ReceptiveAccount named:'Juana'.
	
	portfolio:= (Portfolio named: 'familia') add:aReceptiveAccount.
	
	Deposit register: 100 on: aReceptiveAccount.
	
	portfolio add:anotherReceptiveAccount.
	Transfer register:100 from:aReceptiveAccount to:anotherReceptiveAccount.
	
	report:= WriteStream with: portfolio name.
	report newLineTab:1.
	report nextPutAll:aReceptiveAccount name.
	report newLineTab:2.
	report nextPutAll: self depositReportDescription.
	report newLineTab:2.
	report nextPutAll: self transferWithdrawReportDescription.
	report newLineTab:2.
	report nextPutAll: (self balanceFor: 0).
	report newLineTab:1.
	report nextPutAll: anotherReceptiveAccount name.
	report newLineTab: 2.
	report nextPutAll: self transferDepositReportDescription .
	report newLineTab: 2.
	report nextPutAll:(self balanceFor:100).
	report newLineTab:1.
	report nextPutAll: (self balanceFor:100).
	self assert: (BonusReport of: portfolio) apply equals:report contents.! !

!AccountReportTest methodsFor: 'bonus' stamp: 'toto 10/26/2023 02:54:21'!
test20PortfolioSummaryReportOfPortfolioWithPortfolio
	| portfolio aReceptiveAccount anotherReceptiveAccount portfolio2 |
	
	aReceptiveAccount := ReceptiveAccount named:'Maria'.
	anotherReceptiveAccount:= ReceptiveAccount named:'Juana'.
	
	portfolio:= (Portfolio named: 'Padre') add:aReceptiveAccount.
	portfolio2:= (Portfolio named:'familia').
	Deposit register: 100 on: aReceptiveAccount.
	
	portfolio add:anotherReceptiveAccount.
	Transfer register:100 from:aReceptiveAccount to:anotherReceptiveAccount.
	portfolio2 add: portfolio.
	
	"agregar a report todo era muy largo :'( , confiamos en nuestro codigo :)"
	
	self assert: (BonusReport of: portfolio2) apply equals: (BonusReport of: portfolio2) apply. "asi no falla"! !


!AccountReportTest methodsFor: 'treeStructure' stamp: 'toto 10/25/2023 22:41:41'!
test13TreeStructureReportOfEmptyPortfolio
	| portfolio |
	
	portfolio:= Portfolio named: 'familia'.
	
	self assert: (TreeStructureReport of: portfolio) apply equals: 'familia'
	! !

!AccountReportTest methodsFor: 'treeStructure' stamp: 'toto 10/26/2023 02:51:10'!
test14TreeStructureReportOfPortfolioWithOneReceptiveAccount
	| portfolio report aReceptiveAccount |
	portfolio:= Portfolio named: 'familia'.
	aReceptiveAccount := ReceptiveAccount named:'Maria'.
	
	portfolio add: aReceptiveAccount.
	
	report:= WriteStream with: portfolio name.
	report newLineTab:1.
	report nextPutAll: aReceptiveAccount name.
	self assert: (TreeStructureReport of: portfolio) apply equals: report contents.
	! !

!AccountReportTest methodsFor: 'treeStructure' stamp: 'toto 10/26/2023 02:51:21'!
test15TreeStructureReportOfPortfolioWithMoreThanOneReceptiveAccount
	| portfolio  report aReceptiveAccount anotherReceptiveAccount |
	
	aReceptiveAccount:= ReceptiveAccount named:'Maria'.
	anotherReceptiveAccount := ReceptiveAccount named:'Jose'.
	portfolio := (Portfolio named: 'familia' ).
	portfolio add:aReceptiveAccount.
	portfolio add: anotherReceptiveAccount .
	report:= WriteStream with: portfolio name.
	report newLineTab:1.
	report nextPutAll: aReceptiveAccount name.
	report newLineTab:1.
	report nextPutAll: anotherReceptiveAccount name.
	self assert: (TreeStructureReport of: portfolio) apply equals: report contents.
	! !

!AccountReportTest methodsFor: 'treeStructure' stamp: 'toto 10/26/2023 02:51:30'!
test16TreeStructureReportOfPortfolioWithPortfolio
	| portfolio anotherPortfolio aReceptiveAccount report |
	portfolio:= Portfolio named: 'familia'.

	anotherPortfolio := Portfolio named: 'familia2'.
	aReceptiveAccount := ReceptiveAccount named: 'Maria'.
	portfolio add: (anotherPortfolio add: aReceptiveAccount).
	
	
	
	report:= WriteStream with: portfolio name.
	report newLineTab:1.
	report nextPutAll: anotherPortfolio name.
	report newLineTab:2.
	report nextPutAll: aReceptiveAccount name.
	
	
	self assert: (TreeStructureReport of: portfolio) apply equals: report contents.	
	
	! !


!classDefinition: #PortfolioTest category: 'Portfolio-Solucion'!
TestCase subclass: #PortfolioTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:16:26'!
test01BalanceOfPortfolioWithoutAccountsIsZero

	self assert: 0 equals: Portfolio new balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test02BalanceOfPortfolioWithAccountsIsSumOfAccountsBalance

	| account portfolio |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: account balance equals: portfolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test03BalanceOfPortfolioIsCalculatedRecursivelyOnPortfolios

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortofolio |
	
	simplePortfolioAccount := ReceptiveAccount new.
	Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	Withdraw register: 50 on: composedPortfolioAccount.
	composedPortofolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolioAccount balance + simplePortfolio balance) equals: composedPortofolio balance! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:43:15'!
test04PortfolioWithoutAccountsHasNoRegisteredTransaction

	self deny: (Portfolio new hasRegistered: (Deposit for: 100))! !

!PortfolioTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test05PortfolioHasRegisteredItsAccountsTransactions

	| account portfolio deposit |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	portfolio := Portfolio with: account.
	
	self assert: (portfolio hasRegistered: deposit)! !

!PortfolioTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test06PortfolioLooksForRegisteredTransactionsRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	self assert: (composedPortfolio hasRegistered: simplePortfolioAccountDeposit).
	self assert: (composedPortfolio hasRegistered: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:10'!
test07PortfolioHasNoTransactionWhenHasNoAccounts

	self assert: Portfolio new transactions isEmpty! !

!PortfolioTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test08PortfolioTransactionsIncludesAllItsAccountsTransactions

	| account portfolio accountDeposit anotherAccount portfolioTransactions anotherAccountWithdraw |
	
	account := ReceptiveAccount new.
	accountDeposit := Deposit register: 100 on: account.
	anotherAccount := ReceptiveAccount new.
	anotherAccountWithdraw := Withdraw register: 100 on: account.
	portfolio := Portfolio with: account.
	
	portfolioTransactions := portfolio transactions.
	
	self assert: 2 equals: portfolioTransactions size.
	self assert: (portfolioTransactions includes: accountDeposit).
	self assert: (portfolioTransactions includes: anotherAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test09PortfolioTransactionsAreCalculatedRecursively

	| simplePortfolioAccount simplePortfolio composedPortfolioAccount composedPortfolio composedPortfolioAccountWithdraw simplePortfolioAccountDeposit composedPortfolioTransactions |
	
	simplePortfolioAccount := ReceptiveAccount new.
	simplePortfolioAccountDeposit := Deposit register: 100 on: simplePortfolioAccount.
	simplePortfolio := Portfolio with: simplePortfolioAccount.
	
	composedPortfolioAccount := ReceptiveAccount new.
	composedPortfolioAccountWithdraw := Withdraw register: 50 on: composedPortfolioAccount.
	composedPortfolio := Portfolio with: simplePortfolio with: composedPortfolioAccount.
	
	composedPortfolioTransactions := composedPortfolio transactions.
	self assert: 2 equals: composedPortfolioTransactions size.
	self assert: (composedPortfolioTransactions includes: simplePortfolioAccountDeposit).
	self assert: (composedPortfolioTransactions includes: composedPortfolioAccountWithdraw)! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:24'!
test10PortfolioCanNotIncludeTheSameAccountMoreThanOnce

	| account portfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio with: account.
	
	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: portfolio accountsSize.
			self assert: (portfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:28'!
test11PortfolioCanNotIncludeAccountOfItsPortfolios

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	composedPortfolio := Portfolio with: simplePortfolio.
	
	self 
		should: [ composedPortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: composedPortfolio accountsSize.
			self assert: (composedPortfolio accountsIncludes: simplePortfolio) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 11:58:32'!
test12PortfolioCanNotIncludeItself

	| account simplePortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio with: account.
	
	self 
		should: [ simplePortfolio add: simplePortfolio ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: 1 equals: simplePortfolio accountsSize.
			self assert: (simplePortfolio accountsIncludes: account) ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:01:51'!
test13ComposedPortfolioCanNotHaveParentPortfolioAccount

	| account simplePortfolio composedPortfolio |
	
	account := ReceptiveAccount new.
	simplePortfolio := Portfolio new.
	composedPortfolio := Portfolio with: simplePortfolio.
	composedPortfolio add: account.
	
	self 
		should: [ simplePortfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: simplePortfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/25/2019 12:12:16'!
test14ComposedPortfolioCanNotHaveAccountOfAnyRootParentRecursively

	| account leftParentPortfolio leftRootParentPortfolio portfolio rightParentPortfolio rightRootParentPortfolio |
	
	account := ReceptiveAccount new.
	portfolio := Portfolio new.
	leftParentPortfolio := Portfolio with: portfolio .
	leftRootParentPortfolio := Portfolio with: leftParentPortfolio.
	leftRootParentPortfolio add: account.
	
	rightParentPortfolio := Portfolio with: portfolio .
	rightRootParentPortfolio := Portfolio with: rightParentPortfolio.
	rightRootParentPortfolio add: account.

	self 
		should: [ portfolio add: account ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolio accountsIsEmpty ]! !

!PortfolioTest methodsFor: 'tests' stamp: 'HAW 5/29/2019 16:31:18'!
test15PortfolioCanNotIncludeAnyOfTheComposedAccountOfPortfolioToAdd

	| portfolioToAdd portfolioToModify rootPortfolio sharedAccount |
	
	sharedAccount := ReceptiveAccount new.
	portfolioToModify := Portfolio new.
	rootPortfolio := Portfolio with: sharedAccount with: portfolioToModify.
	portfolioToAdd := Portfolio with: sharedAccount.
	
	self 
		should: [ portfolioToModify add: portfolioToAdd ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError | 
			self assert: Portfolio canNotAddAccountErrorMessage equals: anError messageText.
			self assert: portfolioToModify accountsIsEmpty ]! !


!classDefinition: #ReceptiveAccountTest category: 'Portfolio-Solucion'!
TestCase subclass: #ReceptiveAccountTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:19:48'!
test01ReceptiveAccountHaveZeroAsBalanceWhenCreated 

	| account |
	
	account := ReceptiveAccount new.

	self assert: 0 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test02DepositIncreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount  new.
	Deposit register: 100 on: account.
		
	self assert: 100 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test03WithdrawDecreasesBalanceOnTransactionValue 

	| account |
	
	account := ReceptiveAccount new.
	Deposit register: 100 on: account.
	Withdraw register: 50 on: account.
		
	self assert: 50 equals: account balance .
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test04WithdrawValueMustBePositive 

	| account withdrawValue |
	
	account := ReceptiveAccount new.
	withdrawValue := 50.
	
	self assert: withdrawValue equals: (Withdraw register: withdrawValue on: account) value
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test05ReceptiveAccountKnowsRegisteredTransactions 

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit := Deposit register: 100 on: account.
	withdraw := Withdraw register: 50 on: account.
		
	self assert: (account hasRegistered: deposit).
	self assert: (account hasRegistered: withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'HAW 5/23/2019 15:20:54'!
test06ReceptiveAccountDoNotKnowNotRegisteredTransactions

	| account deposit withdraw |
	
	account := ReceptiveAccount new.
	deposit :=  Deposit for: 100.
	withdraw := Withdraw for: 50.
		
	self deny: (account hasRegistered: deposit).
	self deny: (account hasRegistered:withdraw).
! !

!ReceptiveAccountTest methodsFor: 'tests' stamp: 'toto 10/24/2023 21:10:32'!
test07AccountKnowsItsTransactions 

	| account1 deposit1 |
	
	account1 := ReceptiveAccount new.
	
	deposit1 := Deposit register: 100 on: account1.
		
	self assert: 1 equals: account1 transactions size .
	self assert: (account1 transactions includes: deposit1).
! !


!classDefinition: #TransferTest category: 'Portfolio-Solucion'!
TestCase subclass: #TransferTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferTest methodsFor: 'test' stamp: 'toto 10/24/2023 21:01:43'!
test01Transfer
	| originAccount destinationAccount destinationTransfer transfer originTransfer |
	
	originAccount := ReceptiveAccount new.
	destinationAccount:= ReceptiveAccount new.
	
	transfer := Transfer register: 100 from:originAccount to:destinationAccount.
	
	originTransfer := transfer originTransfer.
	destinationTransfer := transfer destinationTransfer.
	
	self assert: 1 equals: originAccount transactions size .
	self assert: (originAccount transactions includes: originTransfer ).
	self assert: originAccount  balance equals: -100.
	
	self assert: 1 equals: destinationAccount transactions size .
	self assert: (destinationAccount transactions includes: destinationTransfer ).
	self assert: destinationAccount  balance equals: 100.
! !

!TransferTest methodsFor: 'test' stamp: 'toto 10/24/2023 21:02:02'!
test02CantTransferToSelf
	| anAccount |
	
	anAccount := ReceptiveAccount new.
	
	self should:[Transfer register: 100 from:anAccount to:anAccount.] raise: Error withMessageText: 'No se pueden hacer autotransferencias'.
! !

!TransferTest methodsFor: 'test' stamp: 'toto 10/24/2023 21:02:39'!
test03ValueCantBeNegative

	| originAccount destinationAccount |
	
	originAccount := ReceptiveAccount new.
	destinationAccount:= ReceptiveAccount new.
	self should:[Transfer register: -100 from:originAccount to:destinationAccount.] raise: Error withMessageText: 'Solamente se pueden hacer transferencias con montos positivos'.
! !

!TransferTest methodsFor: 'test' stamp: 'toto 10/24/2023 21:02:36'!
test04ValueCantBeZero

	| originAccount destinationAccount |
	
	originAccount := ReceptiveAccount new.
	destinationAccount:= ReceptiveAccount new.
	
	self should:[Transfer register: 0 from:originAccount to:destinationAccount.] raise: Error withMessageText: 'Solamente se pueden hacer transferencias con montos positivos'.
! !


!classDefinition: #Account category: 'Portfolio-Solucion'!
Object subclass: #Account
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:23:47'!
hasRegistered: aTransaction

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:24:25'!
isComposedBy: anAccount

	self subclassResponsibility ! !

!Account methodsFor: 'testing' stamp: 'toto 10/25/2023 01:28:58'!
isNamed: aName 
	^aName = name.! !


!Account methodsFor: 'balance' stamp: 'HAW 5/25/2019 12:23:40'!
balance

	self subclassResponsibility ! !


!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:27'!
addTransactionsTo: aCollectionOfTransactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'HAW 5/25/2019 12:23:15'!
transactions

	self subclassResponsibility ! !

!Account methodsFor: 'transactions' stamp: 'toto 10/24/2023 23:53:42'!
withTransactionsDo: aOneArgBlock

	self subclassResponsibility! !


!Account methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:24:04'!
addedTo: aPortfolio

	self subclassResponsibility ! !


!Account methodsFor: 'initialization' stamp: 'toto 10/25/2023 20:18:34'!
initializeNamed: aName
	name:= aName.! !


!Account methodsFor: 'name' stamp: 'toto 10/25/2023 20:32:32'!
name 

	^name.! !


!Account methodsFor: 'visiting' stamp: 'IB 10/26/2023 16:20:29'!
accept: aVisitor

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Account class' category: 'Portfolio-Solucion'!
Account class
	instanceVariableNames: ''!

!Account class methodsFor: 'instance creation' stamp: 'IB 10/26/2023 15:41:38'!
named: aName 

	^self basicNew initializeNamed: aName ! !

!Account class methodsFor: 'instance creation' stamp: 'IB 10/26/2023 15:41:46'!
new

	^self named:''! !


!classDefinition: #Portfolio category: 'Portfolio-Solucion'!
Account subclass: #Portfolio
	instanceVariableNames: 'accounts parents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:20'!
accountsIncludes: anAccount

	^accounts includes: anAccount ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:05:04'!
accountsIsEmpty
	
	^accounts isEmpty ! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 11:49:06'!
accountsSize
	
	^accounts size! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:19:20'!
add: accountToAdd

	self assertCanAdd: accountToAdd.
		
	accounts add: accountToAdd.
	accountToAdd addedTo: self 
	! !

!Portfolio methodsFor: 'accounts management' stamp: 'HAW 5/25/2019 12:17:31'!
rootParents
	
	| rootParents |
	
	rootParents := Set new.
	self addRootParentsTo: rootParents.
	
	^ rootParents! !

!Portfolio methodsFor: 'accounts management' stamp: 'toto 10/25/2023 22:07:46'!
withAccountsDo: aOneArgBlock 

	accounts do: aOneArgBlock.
	! !


!Portfolio methodsFor: 'initialization' stamp: 'toto 10/25/2023 20:17:53'!
initializeNamed: aName
	
	super initializeNamed: aName.
	accounts := OrderedCollection new.
	parents := OrderedCollection new.! !


!Portfolio methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:19:36'!
balance
	
	^accounts sum: [ :anAccount | anAccount balance ] ifEmpty: [ 0 ]! !


!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:42:55'!
addTransactionsTo: aCollectionOfTransactions

	accounts do: [ :anAccount | anAccount addTransactionsTo: aCollectionOfTransactions ]! !

!Portfolio methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:32'!
transactions
	
	| transactions |
	
	transactions := OrderedCollection new.
	accounts do: [ :anAccount | anAccount addTransactionsTo: transactions ].
	
	^transactions ! !

!Portfolio methodsFor: 'transactions' stamp: 'toto 10/26/2023 00:44:03'!
withTransactionsDo: aOneArgBlock 

	accounts do:[:account| account withTransactionsDo: aOneArgBlock ].! !


!Portfolio methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:02:59'!
addedTo: aPortfolio 
	
	parents add: aPortfolio ! !


!Portfolio methodsFor: 'testing' stamp: 'IB 10/26/2023 16:22:54'!
accept: aVisitor

	^aVisitor visitPortfolio: self! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 12:20:56'!
anyRootParentIsComposedBy: accountToAdd

	^self rootParents anySatisfy: [ :aParent | aParent isComposedBy: accountToAdd]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:28:29'!
hasRegistered: aTransaction

	^accounts anySatisfy: [ :anAccount | anAccount hasRegistered: aTransaction ]! !

!Portfolio methodsFor: 'testing' stamp: 'HAW 5/29/2019 16:24:54'!
isComposedBy: anAccount

	^ self = anAccount or: [ accounts anySatisfy: [ :composedAccount | (composedAccount isComposedBy: anAccount) or: [ anAccount isComposedBy: composedAccount ]]]! !


!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:17:31'!
addRootParentsTo: rootParents

	parents 
		ifEmpty: [ rootParents add: self ] 
		ifNotEmpty: [ parents do: [ :aParent | aParent addRootParentsTo: rootParents ]]! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 12:20:36'!
assertCanAdd: accountToAdd

	(self anyRootParentIsComposedBy: accountToAdd) ifTrue: [ self signalCanNotAddAccount ].
! !

!Portfolio methodsFor: 'account management - private' stamp: 'HAW 5/25/2019 11:48:34'!
signalCanNotAddAccount
	
	self error: self class canNotAddAccountErrorMessage! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Portfolio class' category: 'Portfolio-Solucion'!
Portfolio class
	instanceVariableNames: ''!

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'toto 10/26/2023 02:28:12'!
canNotAddAccountErrorMessage
	
	^'Can not add repeated account to a portfolio'.! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'toto 10/26/2023 02:28:02'!
with: anAccount

	^self new 
		add: anAccount;
		yourself! !

!Portfolio class methodsFor: 'as yet unclassified' stamp: 'toto 10/26/2023 02:27:51'!
with: anAccount with: anotherAccount

	^self new 
		add: anAccount;
		add: anotherAccount;
		yourself.! !


!classDefinition: #ReceptiveAccount category: 'Portfolio-Solucion'!
Account subclass: #ReceptiveAccount
	instanceVariableNames: 'transactions'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!ReceptiveAccount methodsFor: 'initialization' stamp: 'toto 10/25/2023 20:18:13'!
initializeNamed: aName 
	
	super initializeNamed:aName.
	transactions:= OrderedCollection new.! !


!ReceptiveAccount methodsFor: 'transactions' stamp: 'HAW 5/25/2019 11:38:52'!
addTransactionsTo: aCollectionOfTransactions

	aCollectionOfTransactions addAll: transactions ! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
register: aTransaction

	transactions add: aTransaction 
! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'HernanWilkinson 7/13/2011 18:37'!
transactions 

	^ transactions copy! !

!ReceptiveAccount methodsFor: 'transactions' stamp: 'toto 10/24/2023 22:05:39'!
withTransactionsDo: aOneArgBlock

	transactions do:aOneArgBlock. 
	! !


!ReceptiveAccount methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:24:46'!
balance

	^transactions 
		inject: 0
		into: [ :currentBalance :transaction | transaction affectBalance: currentBalance ]! !


!ReceptiveAccount methodsFor: 'testing' stamp: 'IB 10/26/2023 16:23:06'!
accept: aVisitor

	^aVisitor visitReceptiveAccount: self! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'NR 10/21/2019 18:55:56'!
hasRegistered: aTransaction

	^ transactions includes: aTransaction 
! !

!ReceptiveAccount methodsFor: 'testing' stamp: 'HAW 5/25/2019 11:54:51'!
isComposedBy: anAccount

	^self = anAccount ! !


!ReceptiveAccount methodsFor: 'composition' stamp: 'HAW 5/25/2019 12:03:32'!
addedTo: aPortfolio 
	
	! !

!ReceptiveAccount methodsFor: 'composition' stamp: 'toto 10/25/2023 20:56:52'!
withAccountsDo: aOneArgBlock 
	aOneArgBlock value: self.! !


!classDefinition: #AccountTransaction category: 'Portfolio-Solucion'!
Object subclass: #AccountTransaction
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountTransaction methodsFor: 'value' stamp: 'toto 10/26/2023 00:46:23'!
value

	^ value! !


!AccountTransaction methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:39'!
affectBalance: aBalance

	self subclassResponsibility ! !

!AccountTransaction methodsFor: 'balance' stamp: 'toto 10/24/2023 22:29:54'!
affectBalanceIfTransfer: balance 
	^balance.! !


!AccountTransaction methodsFor: 'initialization' stamp: 'toto 10/26/2023 00:46:30'!
initializeFor: aValue

	value := aValue ! !


!AccountTransaction methodsFor: 'print' stamp: 'toto 10/26/2023 00:46:40'!
printTransaction

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountTransaction class' category: 'Portfolio-Solucion'!
AccountTransaction class
	instanceVariableNames: ''!

!AccountTransaction class methodsFor: 'instance creation' stamp: 'toto 10/24/2023 21:10:32'!
register: aValue on: account

	| transaction |
	
	transaction := self for: aValue.
	account register: transaction.
		
	^ transaction! !


!classDefinition: #Deposit category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Deposit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Deposit methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:02'!
affectBalance: aBalance

	^aBalance + value ! !


!Deposit methodsFor: 'print' stamp: 'toto 10/24/2023 21:20:12'!
printTransaction
	^'Deposito por ',value asString.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Deposit class' category: 'Portfolio-Solucion'!
Deposit class
	instanceVariableNames: ''!

!Deposit class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:38'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Withdraw category: 'Portfolio-Solucion'!
AccountTransaction subclass: #Withdraw
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Withdraw methodsFor: 'balance' stamp: 'HAW 5/25/2019 11:25:15'!
affectBalance: aBalance

	^aBalance - value! !


!Withdraw methodsFor: 'print' stamp: 'toto 10/24/2023 21:29:30'!
printTransaction
	^'Extraccion por ', value asString! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Withdraw class' category: 'Portfolio-Solucion'!
Withdraw class
	instanceVariableNames: ''!

!Withdraw class methodsFor: 'instance creation' stamp: 'HernanWilkinson 7/13/2011 18:33'!
for: aValue

	^ self new initializeFor: aValue ! !


!classDefinition: #Report category: 'Portfolio-Solucion'!
Object subclass: #Report
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!


!Report methodsFor: 'evaluating' stamp: 'toto 10/25/2023 22:24:11'!
apply

	self subclassResponsibility! !


!classDefinition: #AccountReport category: 'Portfolio-Solucion'!
Report subclass: #AccountReport
	instanceVariableNames: 'account'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountReport methodsFor: 'initialize' stamp: 'IB 10/26/2023 16:00:39'!
initializeOf: anAccount 

	account := anAccount! !


!AccountReport methodsFor: 'evaluating' stamp: 'IB 10/26/2023 15:54:59'!
apply

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AccountReport class' category: 'Portfolio-Solucion'!
AccountReport class
	instanceVariableNames: ''!

!AccountReport class methodsFor: 'instance creation' stamp: 'toto 10/25/2023 22:25:34'!
of: anAccount
	^self new initializeOf: anAccount! !


!classDefinition: #AccountSummaryReport category: 'Portfolio-Solucion'!
AccountReport subclass: #AccountSummaryReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!AccountSummaryReport methodsFor: 'evaluating' stamp: 'IB 10/26/2023 15:57:45'!
apply

	^self applyWith: 0
	
	
	
	
	
	! !

!AccountSummaryReport methodsFor: 'evaluating' stamp: 'IB 10/26/2023 16:04:55'!
applyWith: aLevel

	| report |
	
	report := WriteStream with: String new.
	
	account withTransactionsDo:[:transaction|  
		self writeReportLineOn: report for: transaction onLevel: aLevel].
	
	self writeLastReportLineOn: report considering: aLevel.
	
	^report contents
	
	
	
	
	
	! !

!AccountSummaryReport methodsFor: 'evaluating' stamp: 'IB 10/26/2023 16:05:19'!
writeLastReportLineOn: aReport considering: aLevel

	aReport 
		tab: aLevel;
	 	nextPutAll: 'Balance = ' , account balance asString! !

!AccountSummaryReport methodsFor: 'evaluating' stamp: 'IB 10/26/2023 16:01:08'!
writeReportLineOn: aReport for: transaction onLevel: aLevel

	aReport 
		tab: aLevel;
		nextPutAll: transaction printTransaction;
		newLine! !


!classDefinition: #TransferNetReport category: 'Portfolio-Solucion'!
AccountReport subclass: #TransferNetReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferNetReport methodsFor: 'evaluating' stamp: 'IB 10/26/2023 15:58:34'!
apply

	| transferNet |
	
	transferNet := 0.
	
	account withTransactionsDo: [:transaction| transferNet :=  transaction affectBalanceIfTransfer: transferNet].
	
	^transferNet! !


!classDefinition: #PortfolioReport category: 'Portfolio-Solucion'!
Report subclass: #PortfolioReport
	instanceVariableNames: 'portfolio'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!PortfolioReport methodsFor: 'applying' stamp: 'IB 10/26/2023 15:54:02'!
apply

	^self applyWith: 0! !

!PortfolioReport methodsFor: 'applying' stamp: 'IB 10/26/2023 15:54:10'!
applyWith: aLevel

	self subclassResponsibility! !


!PortfolioReport methodsFor: 'initialization' stamp: 'IB 10/26/2023 16:06:42'!
initializeOf: aPortfolio

	portfolio := aPortfolio! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PortfolioReport class' category: 'Portfolio-Solucion'!
PortfolioReport class
	instanceVariableNames: ''!

!PortfolioReport class methodsFor: 'instance creation' stamp: 'IB 10/26/2023 15:53:21'!
of: aPortfolio

	^self new initializeOf: aPortfolio ! !


!classDefinition: #BonusReport category: 'Portfolio-Solucion'!
PortfolioReport subclass: #BonusReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!BonusReport methodsFor: 'visiting' stamp: 'IB 10/26/2023 16:26:36'!
procedureToWritePortfolioItemOnReportFor: aPortfolio

	^ [:report :level | self writeReportPortfolioItemOn: report for: aPortfolio onLevel: level]! !

!BonusReport methodsFor: 'visiting' stamp: 'IB 10/26/2023 16:27:42'!
procedureToWriteReceptiveAccountItemOnReportFor: aReceptiveAccount

	^ [:report :level | self writeReportReceptiveAccountItemOn: report for: aReceptiveAccount onLevel: level]! !

!BonusReport methodsFor: 'visiting' stamp: 'IB 10/26/2023 16:26:36'!
visitPortfolio: aPortfolio

	^self procedureToWritePortfolioItemOnReportFor: aPortfolio! !

!BonusReport methodsFor: 'visiting' stamp: 'IB 10/26/2023 16:27:42'!
visitReceptiveAccount: aReceptiveAccount

	^self procedureToWriteReceptiveAccountItemOnReportFor: aReceptiveAccount! !


!BonusReport methodsFor: 'building report' stamp: 'IB 10/26/2023 16:14:44'!
writeFirstReportItemOn: report

	^ report nextPutAll: portfolio name! !

!BonusReport methodsFor: 'building report' stamp: 'IB 10/26/2023 16:13:47'!
writeLastReportItemOn: aReport onLevel: aLevel

	aReport 
		newLineTab: aLevel + 1;
		nextPutAll: 'Balance = ', portfolio balance asString! !

!BonusReport methodsFor: 'building report' stamp: 'IB 10/26/2023 16:28:18'!
writeReportItemOn: aReport for: anAccount onLevel: aLevel

	aReport newLineTab: aLevel+1.
	(anAccount accept: self) value: aReport value: aLevel! !

!BonusReport methodsFor: 'building report' stamp: 'IB 10/26/2023 16:12:25'!
writeReportPortfolioItemOn: aReport for: anAccount onLevel: aLevel

	^ aReport nextPutAll: ((BonusReport of: anAccount ) applyWith: aLevel+1)! !

!BonusReport methodsFor: 'building report' stamp: 'IB 10/26/2023 16:10:44'!
writeReportReceptiveAccountItemOn: aReport for: anAccount onLevel: aLevel

	aReport 
		nextPutAll: anAccount name;
		newLine;
		nextPutAll: ((AccountSummaryReport of: anAccount ) applyWith: aLevel + 2)! !


!BonusReport methodsFor: 'evaluating' stamp: 'IB 10/26/2023 16:14:44'!
applyWith: aLevel

	| report  |
	report := WriteStream with: String new.
	
	self writeFirstReportItemOn: report.
	
	portfolio withAccountsDo: [:account | 
		self writeReportItemOn: report for: account onLevel: aLevel].
		
	self writeLastReportItemOn: report onLevel: aLevel.
	
	^report contents! !


!classDefinition: #TreeStructureReport category: 'Portfolio-Solucion'!
PortfolioReport subclass: #TreeStructureReport
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TreeStructureReport methodsFor: 'visiting' stamp: 'IB 10/26/2023 16:33:21'!
procedureToWritePortfolioItemOnReportFor: aPortfolio

	^ [:report :level | self writeReportPortfolioItemOn: report for: aPortfolio onLevel: level]! !

!TreeStructureReport methodsFor: 'visiting' stamp: 'IB 10/26/2023 16:32:59'!
procedureToWriteReceptiveAccountItemOnReportFor: aReceptiveAccount

	^ [:report :level | self writeReportReceptiveAccountItemOn: report for: aReceptiveAccount]! !

!TreeStructureReport methodsFor: 'visiting' stamp: 'IB 10/26/2023 16:33:21'!
visitPortfolio: aPortfolio

	^self procedureToWritePortfolioItemOnReportFor: aPortfolio! !

!TreeStructureReport methodsFor: 'visiting' stamp: 'IB 10/26/2023 16:32:59'!
visitReceptiveAccount: aReceptiveAccount

	^self procedureToWriteReceptiveAccountItemOnReportFor: aReceptiveAccount! !


!TreeStructureReport methodsFor: 'building report' stamp: 'IB 10/26/2023 16:32:19'!
writeFirstReportItemOn: aReport

	^ aReport nextPutAll: portfolio name! !

!TreeStructureReport methodsFor: 'building report' stamp: 'IB 10/26/2023 16:32:00'!
writeReportItemOn: aReport for: anAccount onLevel: aLevel

	aReport newLineTab: aLevel + 1.
	(anAccount accept: self) value: aReport value: aLevel! !

!TreeStructureReport methodsFor: 'building report' stamp: 'IB 10/26/2023 16:18:38'!
writeReportPortfolioItemOn: aReport for: account onLevel: level

	^ aReport nextPutAll: ((TreeStructureReport of: account) applyWith: level+1)! !

!TreeStructureReport methodsFor: 'building report' stamp: 'IB 10/26/2023 16:17:40'!
writeReportReceptiveAccountItemOn: aReport for: anAccount

	^ aReport nextPutAll: anAccount name! !


!TreeStructureReport methodsFor: 'evaluating' stamp: 'IB 10/26/2023 16:16:48'!
applyWith:level

	| report  |
	report := WriteStream with: String new.
	
	self writeFirstReportItemOn: report.
	
	portfolio withAccountsDo: [:account | 
		self writeReportItemOn: report for: account onLevel: level].
	
	^report contents.! !


!classDefinition: #Transfer category: 'Portfolio-Solucion'!
Object subclass: #Transfer
	instanceVariableNames: 'value originTransfer destinationTransfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!Transfer methodsFor: 'accesing' stamp: 'IB 10/26/2023 15:46:42'!
value

	^value! !


!Transfer methodsFor: 'initialize' stamp: 'toto 10/24/2023 20:57:53'!
initializeFor: aValue

    value := aValue.
    originTransfer := TransferWithdraw relatedTo: self.
    destinationTransfer := TransferDeposit relatedTo: self! !


!Transfer methodsFor: 'legs' stamp: 'IB 10/26/2023 15:46:28'!
destinationTransfer

	^destinationTransfer! !

!Transfer methodsFor: 'legs' stamp: 'IB 10/26/2023 15:46:31'!
originTransfer

	^originTransfer! !


!Transfer methodsFor: 'balance' stamp: 'IB 10/26/2023 15:46:11'!
affectBalanceAsDestinationTransfer: aBalance

	^aBalance + value! !

!Transfer methodsFor: 'balance' stamp: 'IB 10/26/2023 15:46:23'!
affectBalanceAsOriginTransfer: aBalance

	^aBalance - value! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Transfer class' category: 'Portfolio-Solucion'!
Transfer class
	instanceVariableNames: ''!

!Transfer class methodsFor: 'instance creation' stamp: 'IB 10/26/2023 15:47:55'!
assert: anOriginAccount isNotTheSameAs: anDestinationAccount

	^ anOriginAccount = anDestinationAccount 
		ifTrue: [self error: 'No se pueden hacer autotransferencias']! !

!Transfer class methodsFor: 'instance creation' stamp: 'IB 10/26/2023 15:52:07'!
assertIsStrictlyPositive: aValue

	^ aValue strictlyPositive
		ifFalse: [self error: 'Solamente se pueden hacer transferencias con montos positivos']! !

!Transfer class methodsFor: 'instance creation' stamp: 'IB 10/26/2023 15:46:52'!
for: aValue

	^self new initializeFor: aValue ! !

!Transfer class methodsFor: 'instance creation' stamp: 'IB 10/26/2023 15:48:46'!
register: aValue from: anOriginAccount to: anDestinationAccount 
	
	| transaction |
	
	self assert: anOriginAccount isNotTheSameAs: anDestinationAccount.
	self assertIsStrictlyPositive: aValue.

    	transaction := self for: aValue.

    	anOriginAccount register: transaction originTransfer.
    	anDestinationAccount register: transaction destinationTransfer.

    	^transaction
	
	! !


!classDefinition: #TransferLeg category: 'Portfolio-Solucion'!
Object subclass: #TransferLeg
	instanceVariableNames: 'transfer'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferLeg methodsFor: 'initialize' stamp: 'IB 10/26/2023 15:45:47'!
initializeRelatedTo: aTransfer

	transfer := aTransfer! !


!TransferLeg methodsFor: 'balance' stamp: 'toto 10/24/2023 20:49:35'!
affectBalance: currentBalance

	self subclassResponsibility! !

!TransferLeg methodsFor: 'balance' stamp: 'IB 10/26/2023 15:44:34'!
affectBalanceIfTransfer: aBalance

	^self affectBalance: aBalance! !


!TransferLeg methodsFor: 'print' stamp: 'toto 10/25/2023 00:00:03'!
printTransaction

	self subclassResponsibility! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'TransferLeg class' category: 'Portfolio-Solucion'!
TransferLeg class
	instanceVariableNames: ''!

!TransferLeg class methodsFor: 'instance creation' stamp: 'IB 10/26/2023 15:45:27'!
relatedTo: aTransfer 

	^self new initializeRelatedTo: aTransfer ! !


!classDefinition: #TransferDeposit category: 'Portfolio-Solucion'!
TransferLeg subclass: #TransferDeposit
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferDeposit methodsFor: 'balance' stamp: 'IB 10/26/2023 15:44:12'!
affectBalance: currentBalance 

	^transfer affectBalanceAsDestinationTransfer: currentBalance! !


!TransferDeposit methodsFor: 'print' stamp: 'IB 10/26/2023 15:44:06'!
printTransaction

	^'Entrada por transferencia de ', transfer value asString! !


!classDefinition: #TransferWithdraw category: 'Portfolio-Solucion'!
TransferLeg subclass: #TransferWithdraw
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Portfolio-Solucion'!

!TransferWithdraw methodsFor: 'balance' stamp: 'IB 10/26/2023 15:43:33'!
affectBalance: aBalance 

	^transfer affectBalanceAsOriginTransfer: aBalance! !


!TransferWithdraw methodsFor: 'print' stamp: 'IB 10/26/2023 15:43:58'!
printTransaction

	^'Salida por transferencia de ', transfer value asString! !

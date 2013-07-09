# Drop

Minimalistic, hybrid MVC / IoC micro-architecture framework for ActionScript and Apache Flex.

Drop derives from PureMVC and aims to minimize implementation approach discordance, forcing to write less boilerplate, less bug-prone and more consistent code, also introducing typed notification model and strong notion of Separation of Concerns concept.

Hybrid framework features:
* Inversion of Control micro-architecture based on ServiceLocator, called Context;
* Model / View / Controller tiers coded in Services / Mediators / BusinessController classes respectively;
* Strongly-typed notification & delegation model based on interfaces.


## Anatomy

Typical application / library written on drop framework has the following structure:

org.dropframework.*               included framework sources
appname                           application root    
 └ actors                           → root for internal communication interfaces (actors)
    └ singletones                     → actor interfaces with single implementation, i.e. executors, managers and commands: I<...>
	└ notifications                   → actor interfaces with multiple implementation, i.e. notification observers: IOn<...> 	
 └ commons                          → root for all shared generic classes
    └ components                      → shared generic components
    └ utils                           → shared generic utility classes
 └ controller                       → root for business logic controllers
 └ model                            → root for model classes
    └ proxies                         → proxies, services, data access objects
	└ vos                             → value objects, entities, data transfer objects
 └ view                             → views and mediators

 
### The appname/actors/ directory

Example directory content:
 └ actors                           
    └ singletones                 
       └ IScreensController.as
    └ notifications 
       └ IOnApplicationReady.as
       └ IOnRecordChanged.as       	   
    └ GlobalContext.as     

 
### The appname/commons/ directory


### The appname/controller directory

Example directory content:
 └ controller                       
    └ ScreensController.as

 
### The appname/modle directory

Example directory content:
 └ model         
    └ proxies
       └ RecordsEndpoint.as
    └ vos                             
       └ Record.as

	
### The appname/view directory
 
Example directory content:
 └ view                
    └ dialogs
	   └ RecordDialog.mxml
	   └ RecordDialogMediator.as
    └ screens
	   └ ChartScreen.mxml
	   └ TableScreen.mxml	   
	   └ ScreensView.mxml
	   └ ScreensViewMediator.as
    └ ExampleApplication.mxml
    └ ExampleApplicationMediator.as	

 

## Architecture


## How to use


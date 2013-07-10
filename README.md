# Drop

<img src="/docs/logo.png" align="right"></img>
> Minimalistic, hybrid MVC / IoC micro-architecture framework for ActionScript and Apache Flex.

Drop derives from PureMVC and aims to minimize implementation approach discordance, forcing to write less boilerplate, less bug-prone and more consistent code, also introducing typed notification model and strong notion of Separation of Concerns concept.

Hybrid framework features:
* Inversion of Control micro-architecture based on ServiceLocator, called `Context`;
* Model / View / Controller tiers coded in `Services` / `Mediators` / `LogicController` classes respectively;
* Strongly-typed notification & delegation model based on Actor Interfaces.


## Anatomy

Typical application / library written on drop framework has the following structure:
```
org.dropframework.*           → included framework sources
appname                       → application root
 └ actors                       → root for internal communication interfaces (actors)
    └ singletones                 → actor interfaces with single implementation: I<...>
    └ notifications               → actor interfaces with multiple implementation: IOn<...>
 └ commons                      → root for all shared generic classes
    └ components                  → shared generic components
    └ utils                       → shared generic utility classes
 └ controller                   → root for business logic controllers
 └ model                        → root for model classes
    └ proxies                     → proxies, services, data access objects
    └ vos                         → value objects, entities, data transfer objects
 └ view                         → root for views and mediators
```
 
### The appname/actors directory

The `appname/actors` directory contains a Context class which serves as a ServiceLocator for resolving Controllers, and the Controller interfaces themselves. Controller interfaces are split into two groups:
* **singletones** - interfaces that start with `I<...>` name prefix and define API for managers, commands, workers, services of which there is a single implementation within the system. Example:

```actionscript
public interface ISignInController
{
	function signIn (name : String, password : String) : AuthStatus;
	
	function signOut () : void;
}
```

* **notifications** - interfaces that start with `IOn<...>` name prefix and defined API for controllers that listen on specific events or actions happening within the system. Example:

```actionscript
public interface IOnAuthStatusChanged
{
	function onSignedIn (status : AuthStatus) : void;
	
	function onSignedOut () : void;
}
```

Central idea of the Drop framework is:
> Controllers do not communicate directly.

Instead they resolve each other via Context by specific interface defined in `appname/actors` package using `Context.instanceOf`, `Context.arrayOf` and `Context.process` methods. This approach aims to decouple the system components for better maintainability.

This way, `appname/actors` directory serves as a collection of interfaces specifying the internal system mechanics.

> **tip:** Generally it is adviced to use notification interfaces versus singletone ones if possible as those improve Controllers loose coupling.

 
### The appname/commons directory


### The appname/controller directory
```
Example directory content:
 └ controller                       
    └ ScreensController.as
```
 
### The appname/model directory
```
Example directory content:
 └ model         
    └ proxies
       └ RecordsEndpoint.as
    └ vos                             
       └ Record.as
```
	
### The appname/view directory
```
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
```
 

## Architecture


## How to use


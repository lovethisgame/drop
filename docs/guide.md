# Documentation

<img src="../docs/logo.png" align="right"></img>
Minimalistic, hybrid MVC / IoC micro-architecture framework for ActionScript on Apache Flex and AIR platforms.

Drop derives from **PureMVC** in an attempt to minimize implementation approach discordance, forcing to write a strict, consistent and thus more safe code. Framework is designed to be brutally minimal and requires no boilerplate code to apply. Drop also introduces typed notification model and strong notion of *Separation of Concerns* concept.

Hybrid microarchitecture incorporates following approaches:
* **Inversion of Control** based on ServiceLocator, called `Context`;
* **Model / View / Controller** tiers coded in `Services` / `Mediators` / `Controller` classes respectively;
* **Strongly-typed Notification** & **Call Forwarding** model based on native interfaces.

Core framework design aspects:
* **Simplicity** - it takes very little effort to understand and start using the framework in real project;
* **Enforced Consistency** - architecture rules are very strict resulting in a more consistent and safe code produced by development teams. It is also naturally hard to misuse or misinterpret framework ideas;
* **Decoupling and Transparency** - framework improves code clarity, transparency and maintainability by exposing internal system API into a set of interfaces used to reduce modules coupling and keep the big picture in one place, easily and quickly accessible;
* **Minute Setup Time** - speaks for itself.

Free, Opensource, Apache license.

## Architecture

In essence framework breaks down a system into independable classes called Actors, split across logical tiers (Model, View, Controller), each concerned with specific system aspect. Actors communicate with each other via well-defined interfaces. All Actor instanes are stored in a single IoC service locator object, called Context. Context allows to resolve Actors by their interfaces.

Actors come in three types:
* Services (and Proxies) that represent Model layer: call remote network interfaces, fetch local files, etc.
* Mediators that represent View layer, handle UI Components.
* Controllers that represent Controller layer: handle decoupled application business logic.

Actors are coded in independent, robust manner, following specific rules explained below.


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
    └ services                    → proxies, services, data access objects
    └ vos                         → value objects, entities, data transfer objects
 └ view                         → root for views and mediators
```
 
As mentioned above, application consists of logic processing classes called Actors that control specific system aspects, domain and components, communicating with each other via well-defined Interfaces.

 
### The appname/actors directory

The **appname/actors** directory contains at least one Context class, usually named as **GlobalContext** or **<ApplicationName>Context** which represents as a ServiceLocator for resolving Actors; and in subpackages the Actor communication interfaces themselves. Actor interfaces are split into two groups:
* **singletones** - interfaces that start with `I<...>` name prefix and define API for managers, commands, workers, services of which there is strictly a single implementation within the system.
* **notifications** - interfaces that start with `IOn<...>` name prefix and defined API for actors that listen for specific events or actions happening within the system.

Native language interfaces are used to define singletones and notifications, for example:
```actionscript
/* Singletone communication interface */
public class IPoolManager
{
    function managePool(size : uint) : void;
    function destroyPool() : void;
}

/* Notification communication interface */
public class IOnSomethingHappened
{
   function onSomethingHappened(something : String) : void;
}
```

When created, Actor instances are bound to a single `Context` where they reside and can be resolved for communication.


#### Actors communication

Actors never communicate directly, *except for the single case explained below for Mediators*. Instead they resolve each other via `Context` supplying specific Actor interface defined in `appname/actors` package they want to find and then invoke required methods on returned instance(s).

This approach decoulpes Actors and facades implementation complexity behind the contracts defined by communication interfaces. Following `Context` methods can be used to resolve the Actors:
* `.call (type : Class) : void` - executes every method on actors of a given type supplying no arguments.
* `.call (type : Class, args : Array) : void` - executes every function of a given arguments size found within every Actor of the specified interface supplying the specified arguments.
* `.call (type : Class, callback : Function) : void` - executes supplied callback function, consequently passing every Actor of the specified interface as an argument. 
* `.instanceOf (type : Class) : IConcernedActor` - finds one and only one Actor instance of the specified interface, fails with Error if more than 1 Actors found. Singletone communication interface should be supplied as an argument.
* `.arrayOf (type : Class) : Array<IConcernedActor>` - returns an array of Actors of specified type.

Methods explained above are also available on Actors themselves, so you will normally never call a Context directly, but invoke code similar to:

```actionscript
// some code within an Actor...
IPoolManager(instanceOf(IPoolManager)).managePool(3);
call(IOnSomethingHappened, function (a : IOnSomethingHappened) : void
        { a.onSomethingHappened("Pool Manager was asked to manage a pool of 3 items"); });                
call(IOnPoolUpdated, function (a : IOnPoolUpdated) : void
        { a.onPoolUpdated(); });                
```

Given there is a single method per Notification interface, a shortcut syntax can be used:

```actionscript
IPoolManager(instanceOf(IPoolManager)).managePool(3);
call(IOnSomethingHappened, ["Pool Manager was asked to manage a pool of 3 items"]);                
call(IOnPoolUpdated);
```
 
 
### The appname/commons directory

The **appname/commons** directory contains all components, abstractions, utilities and support modules that are:
* generic enough to be reused or means to be extended for the use;
* do not handle any application business logic directly.

Directory content is rather custom, but in case of Apache Flex application it is adviced to have a `components` sub package to contain all the shared and reusable components and containers, and `utils` directory for various utilities.

Drop framework does not bundle any 3rd party utilities and components library. For utilities, such as those working with Objects, Strings, ByteArrays, Logging system etc. there are few good free options available, such as as3commons library that can found here: http://www.as3commons.org. Also mind reviewing this list http://www.adrianparr.com/?p=83.


### The appname/controller directory

Controllers decouple the complex business logic and facade that behind Actor interfaces and may orchestrate other Actors such as Services and Mediators. Controllers are stored in **appname/controller** directory and can form executable commands triggered via singletone or notification interfaces, various system managers, complex execution sequences or aspect controllers.

Here is a simple Controller carcass:
```actionscript
public class ControllerName
    extends Controller
    /* implements <communication-interface-1>,
                  <communication-interface-2>,
                  ... */
{
    public function ControllerName ()
    {
        super(GlobalContext.instance);
    }

    /* communication interface methods */
}
```


### The appname/model directory

Model layer defines Domain Objects and Domain API and located within **appname/model** directory. Framework allows to follow various practices to define the Model, such as Domain Driven Development approach, but in core restricts model classes present on a system to two meta-types:
* **data access objects** - found in **appname/model/services**, these are services, proxies, data stubs, endpoint invokers etc. that provide a data feed or means to control and modify the domain data. Drop provides `Service` and `Proxy` Actor supertypes to incorporate those.
* **data transfer objects** - found in **appname/model/vos**, these are value objects and entities that represent the domain itself.

Here is a simple Service carcass:
```actionscript
public class ServiceName
    extends Service
    /* implements <communication-interface-1>,
                  <communication-interface-2>,
                  ... */
{
    public function ServiceName ()
    {
        super(GlobalContext.instance);
    }

    /* communication interface methods */
}
```

No application business or presentation logic handled within the Model layer. Controllers and Mediators should be used instead. However it is allowed for model Actors to perform CRUD, data normalization, caching, call redirection operations and so on.


### The appname/view directory

The **appname/view** directory is where the hierarchy of visual elements and containers defined. It may contain 3 following types of classes:
* **Views** - all visual display objects, controls and custom ui components that shown on a screen. Coded in MXML in case of targetting Flex / AIR or AS3 for pure Flash. Naming example: `MessagePanel.mxml`.
* **Skins** - Flex 4 skin classes used for applying layout and skinning parameters to the View components. Use `Skin` suffix, for instance `MessagePanelSkin.as`.
* **Mediators** - Actors that listen to View Events dispatched by Views. Mediators control Views by modifying properties and data providers on them; communicate to other system Actors via Singletone or Notification interfaces. Use `Mediator` suffix: `MessagePanelMediator.as`.

When deciding on where a particular code should go, View or Mediator, keep in mind:
* Every View should be as logic unaware and thin as possible, delegating all the business to Mediators. 
* Views should know nothing on Mediators they're assigned to, be totally separate from the system, and may only:
 - include other views;
 - define signals caught by Mediators;
 - expose public methods to set properties or apply data providers.
* In turn, every Mediator must:
 - perform a business logic only of a single View it has been assigned to;
 - delegate non-View specific logic to other Mediators, Services or Controllers better responsible for it, separating the concerns properly in a loosely coupled manner.


#### View to Mediator communication

View may expose a set of public methods available for Mediator to call, such as `set dataProvider`, thus defining it's outter interface. Mediator call these methods to set View properties, state, data provider, etc.

View also generates events converted into signals, such as on creation complete, mouse clicks, scroll position change, and so on. Framework uses as3-signals v0.8 library to handle signals.

Here is an example of a HelloGroup View that defines `set message` method and a signal dispatched on Button click:

```actionscript
<s:VGroup xmlns:fx="http://ns.adobe.com/mxml/2009"
          xmlns:s="library://ns.adobe.com/flex/spark">
    <fx:Script><![CDATA[
        import org.dropframework.mvc.commons.signals.simple.Signal;
        
        public const sayHelloButton_clicked : Signal = new Signal();
    
        public function set message (value : String) : void
        {
            messageLabel.text = value;
        }
    ]]></fx:Script>
    <s:Label id="messageLabel"/>
    <s:Button id="sayHelloButton" label="Say Hello"
              click="sayHelloButton_clicked.dispatch()"/>
</s:VGroup>
```

Below is a Mediator that manages HelloView:

```actionscript
public class HelloGroupMediator
        extends Mediator
{
    public function HelloGroupMediator(view : HelloGroup)
    {
        super(GlobalContext.instance, view);
        view.sayHelloButton_clicked.add
                function () : void
                {
                    helloView.message = "Hello!"
                    wakeUpController.wakeUp();
                });
    }

    private function get wakeUpController() : IWakeUpController
    {
        return instanceOf(IWakeUpController) as IWakeUpController;
    }
    
    private function get helloView() : HelloView
    {
        return adapter.view as HelloView;
    }
}
```

Refer to http://www.developria.com/2010/10/an-introduction-to-as3-signals.html for more infomration on signals.


## App Initialization

Framework initialization usually happens within the single Application Mediator that is constructed by Application view once it's creation complete. For instance:

```actionscript
<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:s="library://ns.adobe.com/flex/spark"
               xmlns:fx="http://ns.adobe.com/mxml/2009"
               xmlns:dash="example.view.dash"
               xmlns:admin="example.view.admin"
               creationComplete="creationCompleteHandler(event)">
    <fx:Script><![CDATA[
        import mx.events.FlexEvent;
        private function creationCompleteHandler (event : FlexEvent) : void
        {
            new ExampleApplicationMediator(this);
        }
    ]]></fx:Script>
    <dash:Dashboard id="dashboard"/>
    <admin:AdminPanel id="adminPanel"/>
</s:Application>
```

Application Mediator then initializes Services, Controllers and Mediators for child components. Child Mediators may initialize Mediators for their children and so on. This way a hierarchy of Mediators created. For example:

```actionscript
public class ExampleApplicationMediator
    extends Mediator
{
    public function ExampleApplicationMediator(view : ExampleApplication)
    {
        super(GlobalContext.instance, view);

        /* initializing model layer */
        new SsoService();
        new DashboardService();

        /* initializing controller layer */
        new PortletsPool();

        /* initializing mediators for child components */
        new DashboardMediator(view.dashboard);
        new AdminPanelMediator(view.adminPanel);

        /* once actors initialized, sending the ready notification */
        call(IOnApplicationReady);
    }
}
```

Notice an `IOnApplicationReady` is dispatched at the end, notifying all concerned Actors that application framework is technically initialized, so every Actor can proceed with tweaking the views, stubs, domain it controls and call other Actors that created and available on Context.


## Framework Usage

Steps to start using the framework:

* Include the framework sources into your (new) project;
* Create a single GlobalContext class;
* Design and define Singletone and Notification interfaces
* Define Mediators to handle views, Services and Value Objects for domain, Controllers for business logic;
* Wire actors together via Interfaces.

Whatever architecture is followed, it must be made sure:

* every Actor is only concerned with the aspect it's type designed to handle,
* actors communicate in decoupled manner via well-defined communication interfaces.


## Tips and Best Practices

**Divide and Isolate everything**

Care should be taken to make sure these rules are followed:
* Boundaries (i.e. non-Actors) do not call Actors directly: Views only dispatch ViewEvents, others (if ever any) may return result directly, via asynch callbacks or rely on Observer pattern.
* Boundaries do not call other Boundaries: communication should always happen through the Actors controlling particular Boundaries.
* Actor never calls Boundaries it's not concerned with: for example, AdminPanelMediator should never call Dashboard view, but only invoke a method on DashboardMediator instead.
 
Proper logic separation within isolated Actors is a key to keep system maintanable. When it feels like an Actor has overgrown in size and manages to much on it's own, consider dividing and extracting responsibility across other Actors, specifically creating new Controllers isolated behind well-defined interfaces.

**Use proxy getters**

When coding an Actor that deals with other Interfaces or a Mediator that modifies a View, it comes handy to define proxy getters that return typed objects. So instead of casting the return object every time:

```actionscript
HelloView(adapter.view).message = "Hello!"
IWakeUpController(instanceOf(IWakeUpController)).wakeUp();
```

define two getters:

```actionscript
private function get wakeUpController() : IWakeUpController
{
    return instanceOf(IWakeUpController) as IWakeUpController;
}
 
private function get helloView() : HelloView
{
    return adapter.view as HelloView;
}
```

and call more readable and concise instructions:

```actionscript
helloView.message = "Hello!"
wakeUpController.wakeUp();
```


**Define context-aware Actor types**

Avoid passing the same GlobalContext instance to the parent Actor type within constructor over again for every Actor like in here:

```actionscript
public function ServiceName ()
{
    super(GlobalContext.instance);
}
```

by defining <AppName>Mediator, <AppName>Controller, <AppName>Service and <AppName>Proxy:

```actionscript
public class MyAppService
    extends Service    
{
    public function MyAppService ()
    {
        super(GlobalContext.instance);
    }
}
```

and extending those directly:

```actionscript
public class SomeService
    extends MyAppService    
{
    // code goes here
}
```


**Group Notification methods**

Notification methods can be grouped within a single Notification interface if logically connected, for example: 

```actionscript
public class IOnNetworkStatusChanged
{
   function onNetworkFound (networkName : String) : void;
   function onNetworkLost () : void;
}
```

Use full call syntax here to specify which method to execute:

```actionscript
call(IOnNetworkStatusChanged,
        function (a : IOnNetworkStatusChanged) : void { a.onNetworkLost(); });
```


**Writing multicore Apps**

A difference between a single core and multicore applications in Drop is in a number of Contexts and Interface sets. Every Application Module should simply define and use it's own Context (optional) and Communication Interfaces package (adviced).

Should Modules package into separate SWC libraries, it comes handy to have one shared cross library with Communication Interfaces (Singletones and Notifications) shared across Modules.


**Group Services together**

Quite often an Application fetches most of it's data from the remote server objects such as HTTP URLs, Java Endpoints, Servlets, and so on. In that case Model layer becomes rather thin, redirecting requests either to local stubs or remote objects.

For simplicity reasons it is adviced to use one common class with static Services / Proxies instances, called Model. For example:

```actionscript
public class Model
{
    public static const sso : SsoService = new SsoService();
    public static const dashboard : DashboardService = new DashboardService();
    
    public function Model (lock : Lock) { }
}

class InstanceLock { }
```

Service and Proxy interfaces are not necessary as Actors called directly:

```actionscript
Model.sso.signIn(username, passwordHash, callback);
Model.dashboard.dropAllPortlets(callback);
```

This is only applicable if Model layer is thin and completely isolated from the business logic, serving only as a gateway to Domain hosted separately.

Also, Services and Proxies may use direct response mechanics (as shown above) or indirect Notification broadcasting via IOn interface, whichever preferred and consistent with an approach chosen by development team. It is adviced though to rely on a simplest direct responce while possible thus reducing amount of requried Notification interfaces.


**Rely on Notification interfaces where possible**

Generally it is adviced to rely on Notification interfaces versus Singletone ones where possible as they allow for better loose coupling.


**Use sophisticated IDE**

Modern IDEs with embedded Flex and ActionScript support allow to quickly navigate between Communication Interfaces, Actors that implement them and Actors that call them. This common feature is very handy and saves great amount of time.


**Perform Actors initialization on IOnApplicationReady**

It is a good idea to dispatch IOnApplicationReady Notification once all Actors created within main Application Mediator. Initial data retrieving, View preparing and kicking off internal processes is then safely handled within listeners, as all necessary Actors created at a time of invocation.


**General tips**

There is no framework or technology that will ensure full code stability, maintainability and bug-safety. Thus it is important to dicuss, agree and stick with the choosen strict consistent approach and practices within the team on a particular project and follow it as much as possible.

Regularly maintaining and sharing the responsibility for code readability, simplicity and safety is a strong requirement regardless of a framework choosen on a mid to long term projects.

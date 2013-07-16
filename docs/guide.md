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

Free, Opensource, Apache license. All the code samples below are taken from the [drop-as3-example](../drop-as3-example/src/main/flex) module accessible within the GitHub repository.

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

The [appname/actors](../drop-as3-example/src/main/flex/example/actors) directory contains at least one Context class, usually named as [GlobalContext or <ApplicationName>Context](../drop-as3-example/src/main/flex/example/actors/GlobalContext.as) which represents as a ServiceLocator for resolving Actors; and in subpackages the Actor communication interfaces themselves. Actor interfaces are split into two groups:
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

Example of Singletone interfaces:
* [ISheepHerdController.as](../drop-as3-example/src/main/flex/example/actors/singletones/ISheepHerdController.as) 
* [IWeatherService.as](../drop-as3-example/src/main/flex/example/actors/singletones/IWeatherService.as) 

And Notification interfaces:
* [IOnSheepCountChanged.as](../drop-as3-example/src/main/flex/example/actors/notifications/IOnSheepCountChanged.as)
* [IOnWeatherChanged.as](../drop-as3-example/src/main/flex/example/actors/notifications/IOnWeatherChanged.as)

When created, Actor instances are bound to a single `Context` where they reside and can be resolved for communication.


#### Actors communication

Actors never communicate directly, *except for the single case explained below for Mediators*. Instead they resolve each other via `Context` supplying specific Actor interface defined in `appname/actors` package they want to find and then invoke required methods on returned instance(s).

This approach decoulpes Actors and facades implementation complexity behind the contracts defined by communication interfaces. Following `Context` methods can be used to resolve the Actors:
* `.instanceOf (type : Class) : IConcernedActor` - finds one and only one Actor instance of the specified interface, fails with Error if more than 1 Actors found. Singletone communication interface should be supplied as an argument.
* `.arrayOf (type : Class) : Array` - finds an array of Actors for specified interface.
* `.invoke (type : Class, callback : Function) : void` - executes supplied callback function, consequently passing every Actor of the specified interface as an argument. Very similar to calling `arrayOf(type).every(callback)`. Handy for notifying multiple Actors.

Methods explained above are also available on Actors themselves, so you will normally never call a Context directly, but invoke code similar to:

```actionscript
    // some code within an Actor...
    IPoolManager(super.instanceOf(IPoolManager)).managePool(3);
    super.invoke(IOnSomethingHappened, function (a : IOnSomethingHappened) : void
            { a.onSomethingHappened("Pool Manager was asked to manage a pool of 3 items"); });                
```

Keyword `super` above is normally dropped, and included here for clarity.
 
 
### The appname/commons directory

The [appname/commons](../drop-as3-example/src/main/flex/example/commons) directory contains all components, abstractions, utilities and support modules that are:
* generic enough to be reused or means to be extended for the use;
* do not handle any application business logic directly.

Directory content is rather custom, but in case of Apache Flex application it is adviced to have a `components` sub package to contain all the shared and reusable components and containers, and `utils` directory for various utilities.

Drop framework does not bundle any 3rd party utilities and components library. For utilities, such as those working with Objects, Strings, ByteArrays, Logging system etc. there are few good free options available, such as as3commons library that can found here: http://www.as3commons.org. Also mind reviewing this list http://www.adrianparr.com/?p=83.


### The appname/controller directory

Controllers decouple the complex business logic and facade that behind Actor interfaces and may orchestrate other Actors such as Services and Mediators. Controllers are stored in [appname/controller](../drop-as3-example/src/main/flex/example/controller) directory and can form executable commands triggered via singletone or notification interfaces, various system managers, complex execution sequences or aspect controllers.

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

See the [Shepherd.as](../drop-as3-example/src/main/flex/example/controller/Shepherd.as) as a controller example.


### The appname/model directory

Model layer defines Domain Objects and Domain API and located within [appname/model](../drop-as3-example/src/main/flex/example/model) directory. Framework allows to follow various practices to define the Model, such as Domain Driven Development approach, but in core restricts model classes present on a system to two meta-types:
* **data access objects** - found in [appname/model/services](../drop-as3-example/src/main/flex/example/model/services), these are services, proxies, data stubs, endpoint invokers etc. that provide a data feed or means to control and modify the domain data. Drop provides `Service` and `Proxy` Actor supertypes to incorporate those.
* **data transfer objects** - found in [appname/model/vos](../drop-as3-example/src/main/flex/example/model/vos), these are value objects and entities that represent the domain itself.

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

See the [WeatherService.as](../drop-as3-example/src/main/flex/example/model/services/WeatherService.as) as a Service example, and [Weather.as](../drop-as3-example/src/main/flex/example/model/vos/Weather.as) as a Value Object.


### The appname/view directory

todo: update the text below this point:

The [appname/view](../drop-as3-example/src/main/flex/example/view) directory is where the hierarchy of visual elements and containers defined. Classes there can be of 3 following types:
* **views** - all visual display objects, controls and custom ui components that shown on a screen, usually coded in MXML, for example `MessagePanel.mxml`;
* **skins** - flex 4 skin classes used for applying layout and skinning parameters to the View components, for instance `MessagePanelSkin.as`;
* **mediators** - actors that listen to View Events dispatched by Views; control Views by modifying properties and data providers on them; serving as gateways to the rest of a system, including controllers, services and other Mediators. For example, `MessagePanelMediator.as`.

General rule in defining Views is **to keep each View as logic unaware and thin as possible, delegating all the business to Mediators**. Views should know nothing on Mediators they're assigned to, be totally separate from the system, and may only:
* include other views;
* broadcast events of special type `ViewEvent` caught by Mediators;
* expose public methods to set properties or apply data providers.

In turn, every Mediator must:
* perform a business logic only of a single View it is assigned to;
* delegate non-View specific logic to other mediators, services or controllers responsible for it.


#### ViewEvent dispatching

View Event dispatching can be seen in a [HerdPanel.mxml](../drop-as3-example/src/main/flex/example/view/herd/HerdPanel.mxml):

```actionscript
<s:Panel xmlns:fx="http://ns.adobe.com/mxml/2009"
         xmlns:s="library://ns.adobe.com/flex/spark">
    <fx:Script><![CDATA[
        public static const A_ADD_SHEEP_CLICKED : String
               = ViewEvent.uniqueName("A_ADD_SHEEP_CLICKED");
              
        private function addSheepButton_clickHandler(event:MouseEvent):void
        {
            dispatchEvent(ViewEvent.of(A_ADD_SHEEP_CLICKED, event));
        }
    ]]></fx:Script>
    <s:Button id="addSheepButton" label="Add Sheep"
              verticalCenter="0" horizontalCenter="0"
              click="addSheepButton_clickHandler(event)"/>
</s:Panel>
```

And listening in a [HerdPanelMediator.mxml](../drop-as3-example/src/main/flex/example/view/herd/HerdPanelMediator.as):

```actionscript
public class HerdPanelMediator
        extends Mediator
{
    public function HerdPanelMediator(view : HerdPanel)
    {
        super(GlobalContext.instance, view);
        adapter.onActions(
                [HerdPanel.A_ADD_SHEEP_CLICKED],
                function (event : ViewEvent) : void
                {
                    sheepHerdController.addSheep();
                });
    }

    private function get sheepHerdController() : ISheepHerdController
    {
        return instanceOf(ISheepHerdController) as ISheepHerdController;
    }
}
```


#### Listening for external notifications

[MessagePanel.mxml](../drop-as3-example/src/main/flex/example/view/message/MessagePanel.mxml) exposes `dataProvider` setter that applies message text to the label control:

```actionscript
<?xml version="1.0"?>
<s:Panel xmlns:fx="http://ns.adobe.com/mxml/2009"
         xmlns:s="library://ns.adobe.com/flex/spark">
    <fx:Script>
        <![CDATA[
        public function set dataProvider (label : String) : void
        {
            statusLabel.text = label;
        }
        ]]>
    </fx:Script>
    <s:Label id="statusLabel"
             verticalCenter="0" horizontalCenter="0"/>
</s:Panel>
```

[MessagePanelMediator.as](../drop-as3-example/src/main/flex/example/view/message/MessagePanelMediator.as) listens for `IOnSheepCountChanged` notification and applies `dataProvider` to the `MessagePanel` View:

```actionscript
public class MessagePanelMediator
    extends Mediator
    implements IOnSheepCountChanged
{
    public function MessagePanelMediator(view : MessagePanel)
    {
        super(GlobalContext.instance, view);
    }

    public function onSheepCountChanged(sheepCount : uint) : void
    {
        messagePanel.dataProvider = (sheepCount != 0) ?
                "Sheep herd has " + sheepCount + " sheeps" :
                "Sheep herd is empty";
    }

    public function onDisasterHappened(sheepCount : uint, description : String) : void
    {
        messagePanel.dataProvider = description;
    }

    private function get messagePanel() : MessagePanel
    {
        return adapter.view as MessagePanel;
    }
}
```


## App Initialization

Once [ApplicationView](../drop-as3-example/src/main/flex/example/view/ExampleApplication.mxml) created, an [ApplicationMediator](../drop-as3-example/src/main/flex/example/view/ExampleApplicationMediator.as) is initialized, which in turn creates all the system actors.

```actionscript
<?xml version="1.0" encoding="utf-8"?>
<s:Application xmlns:s="library://ns.adobe.com/flex/spark"
               xmlns:fx="http://ns.adobe.com/mxml/2009"
               creationComplete="creationCompleteHandler(event)">
    <fx:Script><![CDATA[
        import mx.events.FlexEvent;
        private function creationCompleteHandler (event : FlexEvent) : void
        {
            new ExampleApplicationMediator(this);
        }
    ]]></fx:Script>
    <!-- view components here ... -->
</s:Application>
```

And Application Mediator: 

```actionscript
public class ExampleApplicationMediator
    extends Mediator
{
    public function ExampleApplicationMediator(view : ExampleApplication)
    {
        super(GlobalContext.instance, view);

        /* initializing model layer */
        new WeatherService();

        /* initializing controller layer */
        new Shepherd();

        /* initializing mediators for included components */
        new HerdPanelMediator(view.herdPanel);
        new MessagePanelMediator(view.messagePanel);

        /* once actors initialized, sending the ready notification */
        invoke(IOnApplicationReady, function (a : IOnApplicationReady) : void
                { a.onApplicationReady(); });
    }
}
```

Mediators initialization happens hierarchically with parent Mediators initializing Mediators for the child views.

> **tip:** Generally it is a good idea to dispatch IOnApplicationReady notification in a way shown above once all Actors created and execute all initial data retrieving, view preparing and internal processes launch within listeners in a safe manner, rather than in Actor contstructors.


## How to use

- Get familiar with the framework structure by going through the simple drop-as3-example project.
- Checkout and include the sources of a drop-as3 project.
- Have fun playing, changing and creating!

Drop is designed for modification and extension. For a particular project it might be decided to introduce additional or modified Actor types structure.

Whatever architecture is followed, it must be made sure every Actor is only concerned with the aspect it's type designed to handle, and the actors communicate in decoupled manner via well-defined communication interfaces.

## Best Practices

todo: group methods in communication interfaces; define AppMediator, AppController, AppService and AppProxy; do not call Actors from Boundaries; do not call Boundaries from Boundaries; do not call Boundaries that do not belong to an Actor from that Actor; use sophisticated IDE; write proxy-getters; Multicore projects.

> **tip:** Generally it is adviced to rely on notification interfaces versus singletone ones where possible as they allow for better loose coupling.

> **tip:** Strictly, Controllers are not always required as Mediators and Services (see below) can and should contain application logic related to presentation and model layers. Use Controllers to decouple and manage the non-presentation and non-model related logic, control a system aspect or orchestrate other Actors via their interfaces.

> **tip:** Services and Proxies may use direct response mechanics via IOn interface or indirect notification broadcasting via IOn interface, whichever preferred and consistent with an approach chosen by development team.

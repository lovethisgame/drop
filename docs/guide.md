# Drop Development Guide

All the code samples below are taken from the [drop-as3-example](../drop-as3-example/src/main/flex) subproject found within the repository.

## Architecture

In essence framework breaks down a system into independable classes called Actors, split into logical tiers (Model, View, Controller), each concerned with specific system aspect and communicating with other Actors via well-defined interfaces. All Actor instanes are stored in a single Service Locator object, called Context, that allows to resolve Actors by their interface.

Actors come in three types:
* Services (and Proxies) that represent Model layer,
* Mediators that represent View layer,
* Controllers that represent Controller layer.

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
 
As explained below, application written on Drop consists of logic processing classes called Actors that control specific system aspects and communicate with each other via well-defined Interfaces.

 
### The appname/actors directory

The [appname/actors](../drop-as3-example/src/main/flex/example/actors) directory usually contains a single [GlobalContext](../drop-as3-example/src/main/flex/example/actors/GlobalContext.as) class which serves as a ServiceLocator for resolving Actors, and the Actor communication interfaces themselves. Actor interfaces are split into two groups:
* **singletones** - interfaces that start with `I<...>` name prefix and define API for managers, commands, workers, services of which there is a single implementation within the system.
* **notifications** - interfaces that start with `IOn<...>` name prefix and defined API for actors that listen for specific events or actions happening within the system.

Example of Singletone interfaces:
* [ISheepHerdController.as](../drop-as3-example/src/main/flex/example/actors/singletones/ISheepHerdController.as) 
* [IWeatherService.as](../drop-as3-example/src/main/flex/example/actors/singletones/IWeatherService.as) 

And Notification interfaces:
* [IOnSheepCountChanged.as](../drop-as3-example/src/main/flex/example/actors/notifications/IOnSheepCountChanged.as)
* [IOnWeatherChanged.as](../drop-as3-example/src/main/flex/example/actors/notifications/IOnWeatherChanged.as)


#### Actors communication

Core idea is that **Actors do not communicate directly**, instead they resolve each other via [GlobalContext](../drop-as3-example/src/main/flex/example/actors/GlobalContext.as) by specific Actor interface defined in `appname/actors` package and then invoke required methods. Following `Context` methods can be used to resolve the Actors:
* `.instanceOf (type : Class) : IConcernedActor` - finds one and only one Actor instance of the specified interface, fails with Error if more than 1 Actors found;
* `.arrayOf (type : Class) : Array` - finds an array of Actors for specified interface;
* `.invoke (type : Class, callback : Function) : void` - executes supplied callback function with every Actor of the specified interface as an argument. Handy for notifying multiple Actors.

This approach aims to decouple the system components for better maintainability. This way, `appname/actors` directory serves as a collection of interfaces specifying the internal system mechanics.

> **tip:** Generally it is adviced to rely on notification interfaces versus singletone ones where possible as they allow for better loose coupling.

 
### The appname/commons directory

The [appname/commons](../drop-as3-example/src/main/flex/example/commons) directory contains all components, abstractions, utilities and support modules that are:
* generic enough to be reused or means to be extended for the use;
* do not handle any application business logic directrly.

Directory content is rather custom, in case of Apache Flex application it is adviced to have a `components` sub package to contain all the shared and reusable components, and `utils` directory for various utilities.

Framework does not bundle any 3rd party utilities and components library. For utilities, such as those working with Objects, Strings, ByteArrays, Logging system etc. there are few good free options available, such as as3commons library that can found here: http://www.as3commons.org.


### The appname/controller directory

Controllers are Actors that contain business logic and / or orchestrate other Actors such as Services and Mediators are stored in [appname/controller](../drop-as3-example/src/main/flex/example/controller) directory. Controllers include executable commands triggered directly or by notification, various system managers, complex execution sequences or aspect controllers.

Controllers decouple the complex business logic and facade that behind Actor interfaces, see the [Shepherd.as](../drop-as3-example/src/main/flex/example/controller/Shepherd.as).

Notice the way notification broadcasted to every Actor implementing the `IOnSheepCountChanged` and `IOnDisasterHappened` interface using the `invoke` method:
```actionscript
invoke(IOnSheepCountChanged, function (a : IOnSheepCountChanged) : void
        { a.onSheepCountChanged(_sheepCount); });
```

Every Controller automatically registers itself within the GlobalContext upon initialization.

> **tip:** Strictly, Controllers are not always required as Mediators and Services (see below) can and should contain application logic related to presentation and model layers. Use Controllers to decouple and manage the non-presentation and non-model related logic, control a system aspect or orchestrate other Actors via their interfaces.


### The appname/model directory

Model layer is at heart of every application as it defines Domain Objects and Domain API and can be found in [appname/model](../drop-as3-example/src/main/flex/example/model) directory. Framework allows to follow various practices to define the Model, for instance applying a Domain Driven Development approach, but in core manages the two types of classes:
* **data access objects** - found in [appname/model/services](../drop-as3-example/src/main/flex/example/model/services), these are services, proxies, data stubs, remote endpoints etc. that provide a data feed for the application to present or means to control and modify the application data. Drop provides `Service` and `Proxy` basic Actor classes to represent those.
* **data transfer objects** - found in [appname/model/vos](../drop-as3-example/src/main/flex/example/model/vos), these are value objects and entities that represent the Domain.

No application business or presentation logic should be handled within the Model layer. Controllers and Mediators should be used instead.

[WeatherService.as](../drop-as3-example/src/main/flex/example/model/services/WeatherService.as) is a Service example, and [Weather.as](../drop-as3-example/src/main/flex/example/model/vos/Weather.as) is a Value Object.

> **tip:** Services and Proxies may use direct response mechanics via IOn interface or indirect notification broadcasting via IOn interface, whichever preferred and consistent with an approach chosen by development team.


### The appname/view directory

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


## Initialization

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


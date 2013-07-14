# Drop

<img src="/docs/logo.png" align="right"></img>
Minimalistic, hybrid MVC / IoC micro-architecture framework for ActionScript on Apache Flex and AIR platforms.

Drop derives from PureMVC and aims to minimize implementation approach discordance, forcing to write bug-safe and consistent solutions with less boilerplate code, also introducing typed notification model and strong notion of *Separation of Concerns* concept.

Hybrid framework features:
* Inversion of Control micro-architecture based on ServiceLocator, called `Context`;
* Model / View / Controller tiers coded in `Services` / `Mediators` / `Controller` classes respectively;
* Strongly-typed notification & delegation model based on Actor Interfaces.

All the code samples below are taken from the drop-as3-example subproject found within the repository.


## Architecture

In essence framework breaks down a system into independable classes called Actors, split into logical tiers (Model, View, Controller), each concerned with specific system aspect and communicating with other Actors via well-defined interfaces. All Actor instanes are stored in a single Service Locator object, called Context, that allows to resolve Actors by their interface.

Actors come in three types:
* Services that represent Model layer,
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

The `appname/actors` directory usually contains a single `GlobalContext` class which serves as a ServiceLocator for resolving Actors, and the Actor communication interfaces themselves. Actor interfaces are split into two groups:
* **singletones** - interfaces that start with `I<...>` name prefix and define API for managers, commands, workers, services of which there is a single implementation within the system.
* **notifications** - interfaces that start with `IOn<...>` name prefix and defined API for actors that listen for specific events or actions happening within the system.

Example of Singletone and Notification interfaces:
```actionscript
public interface ISheepHerdController
{
    function addSheep () : void;
}

public interface IOnWeatherChanged
{
    function onWeatherChanged (weather : Weather) : void;
}
```

Central Drop framework idea is that **Actors do not communicate directly**. Instead they resolve each other via Context by specific Actor interface defined in `appname/actors` package and then invoke required methods. Following `Context` methods are used to resolve the Actors:
* `.instanceOf (type : Class) : IConcernedActor` - finds one and only one Actor instance of the specified interface, fails if more than 1 Actors found;
* `.arrayOf (type : Class) : Array` - finds an array of Actors for specified interface;
* `.invoke (type : Class, callback : Function) : void` - executes supplied callback function with every Actor of the specified interface as an argument. Handy for notifying multiple Actors.

This approach aims to decouple the system components for better maintainability. This way, `appname/actors` directory serves as a collection of interfaces specifying the internal system mechanics.

> **tip:** Generally it is adviced to rely on notification interfaces versus singletone ones where possible as they allow for better loose coupling.

 
### The appname/commons directory

The `appname/commons` directory contains all components, abstractions, utilities and support modules that are:
* generic enough to be reused or means to be extended for the use;
* do not handle any application business logic directrly.

Directory content is rather custom, in case of Apache Flex application it is adviced to have a `components` sub package to contain all the shared and reusable components, and `utils` directory for various utilities.

Framework does not bundle any 3rd party utilities and components library. For utilities, such as those working with Objects, Strings, ByteArrays, Logging system etc. there are few good free options available, such as as3commons library that can found here: http://www.as3commons.org.


### The appname/controller directory

Controllers are Actors that contain business logic and / or orchestrate other Actors such as Services and Mediators. Examples include executable commands triggered directly or by notification, various managers, complex execution sequences or aspect controllers.

Controllers decouple the complex business logic and facade that behind Actor interfaces, for example:
```actionscript
public class Shepherd
    extends Controller
    implements ISheepHerdController,
               IOnWeatherChanged,
               IOnApplicationReady
{
    private var _sheepCount : int = 0;


    public function Shepherd ()
    {
        super(GlobalContext.instance);
    }


    public function addSheep () : void
    {
        _sheepCount++;
        invoke(IOnSheepCountChanged, function (a : IOnSheepCountChanged) : void
                { a.onSheepCountChanged(_sheepCount); });
    }

    public function onApplicationReady() : void
    {
        invoke(IOnSheepCountChanged, function (a : IOnSheepCountChanged) : void
                { a.onSheepCountChanged(_sheepCount); });
    }

    public function onWeatherChanged (weather : Weather) : void
    {
        if (weather.isStorm)
        {
            _sheepCount = 0;
            invoke(IOnSheepCountChanged, function (a : IOnSheepCountChanged) : void
                    { a.onDisasterHappened(_sheepCount, "Herd was killed by a Sudden Storm!"); });
        }
    }
}
```

Notice the way notification broadcasted to every Actor implementing the `IOnSheepCountChanged` and `IOnDisasterHappened` interface using the `invoke` method.

Notice also, Controller automatically registers itself within the GlobalContext upon initialization.

> **tip:** Strictly, Controllers are not always required as Mediators and Services (see below) can and should contain application logic related to presentation and model layers. Use Controllers to decouple and manage the non-presentation and non-model related logic, control a system aspect or orchestrate other Actors via their interfaces.


### The appname/model directory

Model layer is at heart of every application as it defines Domain Objects and Domain API. Framework allows to follow various practices to define the Model, for instance applying a Domain Driven Development approach, but in core manages the two types of classes:
* **data access objects** - these are services, proxies, data stubs, remote endpoints etc. that provide a data feed for the application to present or means to control and modify the application data. Drop provides `Service` and `Proxy` basic Actor classes to represent those.
* **data transfer objects** - these are value objects and entities that represent the Domain.

Data access objects are stored in `appname/model/services` package, whereas data transfer objects are kept in `appname/model/vos`, i.e. Value Objects package.

Example of a Service:

```actionscript
public class WeatherService
    extends Service
    implements IWeatherService
{
    private static const storm : Weather = Weather.of(15.4, 28.1);


    public function WeatherService ()
    {
        super(GlobalContext.instance);
    }


    public function measureWeather (callback : Function /* (Weather) */) : void
    {
        // offline stub
        if (!AsyncConnector.networkAvailable)
        {
            callback(storm);
            return;
        }
        // invoking remote endpoint method
        AsyncConnector.invoke("endpoint.weather", "measureWeather",
                function (response : Response) : void
                {
                    if (response.hasError())
                    {
                        invoke(IOnNetworkError, function (a : IOnNetworkError) : void
                                { a.onNetworkError(response.error); });
                        callback(null);
                    }
                    else
                    {
                        callback(Weather(response.content));
                    }
                });
    }
}
```

And a Value Object:

```actionscript
public class Weather
{
    public var temperature : Number /* in C */;
    public var windspeed : Number /* in m/s */;

    public function get isStorm () : Boolean
    {
        return windspeed >= 24.5;
    }

    public static function of (temperature : Number, windspeed : Number) : Weather
    {
        var result : Weather = new Weather();
        result.temperature = temperature;
        result.windspeed = windspeed;
        return result;
    }
}
```

Rule of a thumb is to do not handle any application business or presentation logic within the Model layer. Controllers and Mediators should be used instead.

> **tip:** Services and Proxies may use direct response mechanics as shown in the example above (notice the callback is invoked once response received) or indirect Notification broadcasting via IOn interface, whichever preferred and consistent with an approach chosen by development team.


### The appname/view directory

The `appname/view` directory is where the hierarchy of visual elements and containers defined. Classes here can be of the 3 following types:
* **views** - all visual display objects, controls and custom ui components that shown on a screen, usually coded in MXML, for example `MessagePanel`;
* **skins** - flex 4 skin classes used for applying layout and skinning parameters to the View components, for instance `MessagePanelSkin`;
* **mediators** - actors that listen to View Events dispatched by Views; control Views by modifying properties and data providers on them; serving as gateways to the rest of a system, including controllers, services and other Mediators. For example, `MessagePanelMediator`.

General rule in defining Views is **to keep each View as logic unaware and thin as possible, delegating all the business to Mediators**. Views should know nothing about Mediators they're assigned to, be totally separate from the system, and may only:
* include other views;
* broadcast events of special type `ViewEvent` caught by Mediators;
* expose public methods to set properties or apply data providers.

In turn, every Mediator must:
* perform a business logic only of a single View it is assigned to;
* delegate non-View specific logic to other mediators, services or controllers responsible for it.


#### ViewEvent dispatching

Following View-Mediator pair shows the ViewEvent dispatching / intercepting mechanics:

```actionscript
<?xml version="1.0"?>
<s:Panel xmlns:fx="http://ns.adobe.com/mxml/2009"
         xmlns:s="library://ns.adobe.com/flex/spark"
         width="100%" height="100%"
         title="Sheep God control panel">

    <fx:Script>
        <![CDATA[
        import org.dropframework.mvc.view.ViewEvent;

        /* public view event names listing dispatched by this view component */
        public static const A_ADD_SHEEP_CLICKED : String
               = ViewEvent.uniqueName("A_ADD_SHEEP_CLICKED");
        public static const A_CHANGE_WEATHER_CLICKED : String
                = ViewEvent.uniqueName("A_CHANGE_WEATHER_CLICKED");

        /* local event listeners that trigger dispatching the view events to mediator */
        private function addSheepButton_clickHandler(event:MouseEvent):void
        {
            dispatchEvent(ViewEvent.of(A_ADD_SHEEP_CLICKED, event));
        }

        private function changeWeatherButton_clickHandler(event:MouseEvent):void
        {
            dispatchEvent(ViewEvent.of(A_CHANGE_WEATHER_CLICKED, event));
        }
        ]]>
    </fx:Script>

    <s:HGroup verticalCenter="0" horizontalCenter="0">
        <s:Button id="addSheepButton" label="Add Sheep"
                  verticalCenter="0" horizontalCenter="0"
                  click="addSheepButton_clickHandler(event)"/>
        <s:Button id="changeWeatherButton" label="Change Weather"
                  verticalCenter="0" horizontalCenter="0"
                  click="changeWeatherButton_clickHandler(event)"/>
    </s:HGroup>

</s:Panel>



public class HerdPanelMediator
    extends Mediator
{
    public function HerdPanelMediator(view : HerdPanel)
    {
        super(GlobalContext.instance, view);

        /* handles the add sheep button click from the view,
           and delegates execution to sheep herd controller */
        adapter.onActions(
                [HerdPanel.A_ADD_SHEEP_CLICKED],
                function (event : ViewEvent) : void
                {
                    sheepHerdController.addSheep();
                });

        /* handles the weather change button click from the view,
           invokes remote measureWeather method and notifies actors on weather change */
        adapter.onActions(
                [HerdPanel.A_CHANGE_WEATHER_CLICKED],
                function (event : ViewEvent) : void
                {
                    weatherService.measureWeather(
                            function (weather : Weather) : void
                            {
                                invoke(IOnWeatherChanged, function (a : IOnWeatherChanged) : void
                                    { a.onWeatherChanged(weather); });
                            });
                });
    }

    private function get sheepHerdController() : ISheepHerdController
    {
        return instanceOf(ISheepHerdController) as ISheepHerdController;
    }

    private function get weatherService() : IWeatherService
    {
        return instanceOf(IWeatherService) as IWeatherService;
    }
}
```


#### Listening for external notifications

Following pair shows simple View that is controlled by Mediator also listening for specific system notifications:

```actionscript
<?xml version="1.0"?>
<s:Panel xmlns:fx="http://ns.adobe.com/mxml/2009"
         xmlns:s="library://ns.adobe.com/flex/spark"
         width="100%" height="100%"
         title="Herd status panel">

    <fx:Script>
        <![CDATA[
        /* public method exposed to the mediator, allows for setting the message text */
        public function set dataProvider (label : String) : void
        {
            statusLabel.text = label;
        }
        ]]>
    </fx:Script>

    <s:Label id="statusLabel"
             verticalCenter="0" horizontalCenter="0"/>

</s:Panel>



public class MessagePanelMediator
    extends Mediator
    implements IOnSheepCountChanged
{
    public function MessagePanelMediator(view : MessagePanel)
    {
        super(GlobalContext.instance, view);
    }


    /* listen for the sheep count change to update the sheep count */
    public function onSheepCountChanged(sheepCount : uint) : void
    {
        messagePanel.dataProvider = (sheepCount != 0) ?
                "Sheep herd has " + sheepCount + " sheeps" :
                "Sheep herd is empty";
    }

    /* listen for the disaster event to print that out */
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


#### Initializing application

Application initializaiton is usually done by the Application Mediator, instanciated by the main Application View, like shown here:

```actionscript
<?xml version="1.0" encoding="utf-8"?>
<!-- Base application file -->
<s:Application xmlns:s="library://ns.adobe.com/flex/spark"
               xmlns:fx="http://ns.adobe.com/mxml/2009"
               xmlns:herd="example.view.herd.*"
               xmlns:message="example.view.message.*"
               creationComplete="creationCompleteHandler(event)">


    <fx:Script>
        <![CDATA[
        import mx.events.FlexEvent;

        /* creates main application mediator once the view is created */
        private function creationCompleteHandler (event : FlexEvent) : void
        {
            new ExampleApplicationMediator(this);
        }
        ]]>
    </fx:Script>

    <s:VGroup verticalCenter="0" horizontalCenter="0" width="300" height="200">
        <herd:HerdPanel id="herdPanel"/>
        <message:MessagePanel id="messagePanel"/>
    </s:VGroup>

</s:Application>



/** Mediator for the main Application, best place to create model, controller and view actors. */
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

Notice Mediators initialization happens in a hierarchy with parent view Mediators initializing Mediators for the children view.


## How to use

- Get familiar with the framework structure by going through the simple drop-as3-example project.
- Checkout and include the sources of a drop-as3 project.
- Have fun playing, changing and creating!

> **tip:** Drop is designed for modification and extension. For a particular project it might be decided to introduce additional or modified Actor types structure.

> **tip:** Whatever architecture is followed, it must be made sure every Actor is only concerned with the aspect it's type designed to handle, and the actors communicate in decoupled manner via well-defined communication interfaces.

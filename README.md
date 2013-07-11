# Drop

<img src="/docs/logo.png" align="right"></img>
Minimalistic, hybrid MVC / IoC micro-architecture framework for ActionScript on Apache Flex and AIR platforms.

Drop derives from PureMVC and aims to minimize implementation approach discordance, forcing to write less boilerplate, less bug-prone and more consistent code, also introducing typed notification model and strong notion of Separation of Concerns concept.

Hybrid framework features:
* Inversion of Control micro-architecture based on ServiceLocator, called `Context`;
* Model / View / Controller tiers coded in `Services` / `Mediators` / `Controller` classes respectively;
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
    └ services                    → proxies, services, data access objects
    └ vos                         → value objects, entities, data transfer objects
 └ view                         → root for views and mediators
```
 
### The appname/actors directory

The `appname/actors` directory contains a Context class which serves as a ServiceLocator for resolving Actors, and the Actor interfaces themselves. Actor interfaces are split into two groups:
* **singletones** - interfaces that start with `I<...>` name prefix and define API for managers, commands, workers, services of which there is a single implementation within the system.
* **notifications** - interfaces that start with `IOn<...>` name prefix and defined API for actors that listen for specific events or actions happening within the system.

Example of Singletone and Notification interfaces:
```actionscript
public interface ISheepHerdController
{
	function addSheep (sheep : Sheep) : void;	
	function get sheepCount () : uint;
}

public interface IOnWeatherChanged
{
	function onWeatherChanged (weather : Weather) : void;
}
```

Central Drop framework idea is that **Actors do not communicate directly**. Instead they resolve each other via Context by specific Actor interface defined in `appname/actors` package and then invoke required methods. Following `Context` methods are used to resolve the Actors:
* `.instanceOf (type : Class) : IConcernedActor` - find one Actor instance of the specified interface;
* `.arrayOf (type : Class) : Array` - finds an array of Actors for specified interface;
* `.invoke (type : Class, callback : Function) : void` - executes supplied callback function over every Actor of the specified interface.

This approach aims to decouple the system components for better maintainability. This way, `appname/actors` directory serves as a collection of interfaces specifying the internal system mechanics.

> **tip:** Generally it is adviced to rely on notification interfaces versus singletone ones where possible as they allow for improved loose coupling.

 
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
	implements ISheepHerdController, IOnWeatherChanged
{
	private var _sheeps : Vector.<Sheep> = new Vector.<Sheep>();

	public function addSheep (sheep : Sheep) : void
	{
		_sheeps.push(sheep);
	}
	
	public function get sheepCount () : uint
	{
		return _sheeps.length;
	}
	
	public function onWeatherChanged (weather : Weather) : void
	{
		if (weather.isStorm)
		{
			_sheeps = new Vector.<Sheep>();
			process(IOnDisasterHappened, function (a : IOnDisasterHappened) : void
					{ a.onDisasterHappened("Every Sheeps has died because of a Sudden Storm!"); });
		}
	}
}
```

Notice the way notification broadcasted to every Actor implementing the `IOnDisasterHappened` interface using the `process` method.

> **tip:** Strictly, Controllers are not always required as Mediators and Services (see below) can and should contain application logic related to presentation and model layers. Use Controllers to decouple and manage the non-presentation and non-model related logic, control a system aspect or orchestrate other Actors via their interfaces.


### The appname/model directory

Model layer is at heart of every application as it defines Domain Objects and Domain API. Framework allows to follow various practices to define the Model, for instance applying a Domain Driven Development approach, but in core manages the two types of aspects:
* **data access objects** - these are services, proxies, data stubs, remote endpoints etc. that provide a data feed for the application to present or means to control and modify the application data. Drop provides `Service` and `Proxy` Actor classes to represent those.
* **data transfer objects** - these are value objects and entities that represent the Domain.

Data access objects are stored in `appname/model/services` package, whereas data transfer objects are kept in `appname/model/vos`, i.e. Value Objects package.

Example of a Service:

```actionscript
public class WeatherService
	extends Service
	implements IWeatherService
{
	public function measureWeather (callback : Function /* (Weather) */) : void
	{
		if (!AsyncConnector.networkAvailable)
		{
			callback(Weather.of(17.2, 3.2)); 
			return;
		}	
		AsyncConnector.invoke("endpoint.weather", "measureWeather",
			function (response : Response) : void
			{
				if (response.hasError())
				{
					process(IOnNetworkError, function (a : IOnNetworkError) : void
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

Rule of a thumb here is to do not handle any application business or presentation logic within the Model layer. Controllers and Mediators should be used instead.

> **tip:** Services and Proxies may use direct response mechanics as shown in the example above (notice the callback is invoked once response received) or indirect Notification broadcasting via IOn interface, whichever preferred and consistent with an approach chosen by development team.


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


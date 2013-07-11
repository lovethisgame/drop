package example.model.services
{
    import example.actors.GlobalContext;
    import example.actors.notifications.IOnNetworkError;
    import example.actors.singletones.IWeatherService;
    import example.model.vos.Response;
    import example.model.vos.Weather;

    import org.dropframework.mvc.model.Service;


    public class WeatherService
        extends Service
        implements IWeatherService
    {

        public function WeatherService ()
        {
            super(GlobalContext.instance);
        }


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
}

package example.model.services
{
    import example.actors.GlobalContext;
    import example.actors.notifications.IOnNetworkError;
    import example.actors.singletones.IWeatherService;
    import example.commons.utils.AsyncConnector;
    import example.model.vos.Response;
    import example.model.vos.Weather;

    import org.dropframework.mvc.model.Service;


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
                            call(IOnNetworkError, function (a : IOnNetworkError) : void
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

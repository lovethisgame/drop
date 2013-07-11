package example.actors.singletones
{
    public interface IWeatherService
    {
        function measureWeather (callback : Function /* (Weather) */) : void;
    }
}

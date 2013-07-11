package example.actors.notifications
{
    import example.model.vos.Weather;


    public interface IOnWeatherChanged
    {
        function onWeatherChanged (weather : Weather) : void;
    }
}

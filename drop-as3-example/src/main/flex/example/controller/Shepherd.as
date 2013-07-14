package example.controller
{
    import example.actors.GlobalContext;
    import example.actors.notifications.IOnApplicationReady;
    import example.actors.notifications.IOnSheepCountChanged;
    import example.actors.notifications.IOnWeatherChanged;
    import example.actors.singletones.ISheepHerdController;
    import example.model.vos.Weather;

    import org.dropframework.mvc.controller.Controller;


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
                        { a.onDisasterHappened(_sheepCount, "Herd was destroyed by a Sudden Storm!"); });
            }
        }
    }
}

package example.controller
{
    import example.actors.GlobalContext;
    import example.actors.notifications.IOnDisasterHappened;
    import example.actors.notifications.IOnWeatherChanged;
    import example.actors.singletones.ISheepHerdController;
    import example.model.vos.Weather;

    import org.dropframework.mvc.controller.Controller;


    public class Shepherd
        extends Controller
        implements ISheepHerdController, IOnWeatherChanged
    {
        private var sheepsCount : int = 0;


        public function Shepherd ()
        {
            super(GlobalContext.instance);
        }


        public function addSheep () : void
        {
            sheepsCount++;
        }

        public function get sheepCount () : uint
        {
            return sheepsCount;
        }

        public function onWeatherChanged (weather : Weather) : void
        {
            if (weather.isStorm)
            {
                sheepsCount = 0;
                invoke(IOnDisasterHappened, function (a : IOnDisasterHappened) : void
                        { a.onDisasterHappened("Every Sheep has died because of a Sudden Storm!"); });
            }
        }
    }
}

package example.view.herd
{
    import example.actors.GlobalContext;
    import example.actors.notifications.IOnWeatherChanged;
    import example.actors.singletones.ISheepHerdController;
    import example.actors.singletones.IWeatherService;
    import example.model.vos.Weather;

    import org.dropframework.mvc.view.Mediator;
    import org.dropframework.mvc.commons.events.ViewEvent;

    public class HerdPanelMediator
        extends Mediator
    {
        public function HerdPanelMediator(view : HerdPanel)
        {
            super(GlobalContext.instance, view);

            /* handles the add sheep button click from the view,
               and delegates execution to sheep herd controller */
            adapter.on(
                    HerdPanel.A_ADD_SHEEP_CLICKED,
                    function (event : ViewEvent) : void
                    {
                        sheepHerdController.addSheep();
                    });

            /* handles the weather change button click from the view,
               invokes remote measureWeather method and notifies actors on weather change */
            adapter.on(
                    HerdPanel.A_CHANGE_WEATHER_CLICKED,
                    function (event : ViewEvent) : void
                    {
                        weatherService.measureWeather(
                                function (weather : Weather) : void
                                {
                                    call(IOnWeatherChanged, [weather]);
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
}

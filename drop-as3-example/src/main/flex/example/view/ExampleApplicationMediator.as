package example.view
{
    import example.actors.GlobalContext;
    import example.actors.notifications.IOnApplicationReady;
    import example.controller.Shepherd;
    import example.model.services.WeatherService;
    import example.view.herd.HerdPanelMediator;
    import example.view.message.MessagePanelMediator;

    import org.dropframework.mvc.view.Mediator;

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
}

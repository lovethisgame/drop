package example.view
{
    import example.actors.GlobalContext;
    import example.actors.notifications.IOnApplicationReady;
    import example.controller.Shepherd;
    import example.model.services.WeatherService;
    import example.view.herd.HerdPanelMediator;
    import example.view.message.MessagePanelMediator;

    import org.dropframework.mvc.view.Mediator;

    public class ExampleApplicationMediator
        extends Mediator
    {
        public function ExampleApplicationMediator(view : ExampleApplication)
        {
            super(GlobalContext.instance, view);

            new WeatherService();
            new Shepherd();

            new HerdPanelMediator(view.herdPanel);
            new MessagePanelMediator(view.messagePanel);

            invoke(IOnApplicationReady, function (a : IOnApplicationReady) : void
                    { a.onApplicationReady(); });
        }
    }
}

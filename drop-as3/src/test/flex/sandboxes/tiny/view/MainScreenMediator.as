package sandboxes.tiny.view
{
    import org.dropframework.core.contexts.IContext;
    import org.dropframework.mvc.view.Mediator;

    public class MainScreenMediator
        extends Mediator
    {
        public function MainScreenMediator
                (context : IContext, screen : MainScreen)
        {
            super(context, screen);

            screen.mainButton_clicked.add(
                    function () : void
                    {
                        screen.responseLabel.text = "Thank you!";
                    });
        }

        public function get screen() : MainScreen
        {
            return view as MainScreen;
        }
    }
}

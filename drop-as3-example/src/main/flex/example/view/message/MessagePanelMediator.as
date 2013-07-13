package example.view.message
{
    import example.actors.GlobalContext;
    import example.actors.notifications.IOnApplicationReady;
    import example.actors.notifications.IOnSheepCountChanged;
    import example.actors.singletones.ISheepHerdController;

    import org.dropframework.mvc.view.Mediator;

    public class MessagePanelMediator
        extends Mediator
        implements IOnApplicationReady,
                   IOnSheepCountChanged
    {
        public function MessagePanelMediator(view : MessagePanel)
        {
            super(GlobalContext.instance, view);
        }


        public function onApplicationReady() : void
        {
            refreshSheepCount();
        }

        public function onSheepCountChanged() : void
        {
            refreshSheepCount();
        }

        public function onDisasterHappened(description : String) : void
        {
            messagePanel.dataProvider = description;
        }


        private function refreshSheepCount() : void
        {
            messagePanel.dataProvider = (sheepHerdController.sheepCount != 0) ?
                    "Sheep herd has " + sheepHerdController.sheepCount + " sheeps" :
                    "Sheep herd is empty";
        }


        private function get sheepHerdController() : ISheepHerdController
        {
            return instanceOf(ISheepHerdController) as ISheepHerdController;
        }

        private function get messagePanel() : MessagePanel
        {
            return adapter.view as MessagePanel;
        }
    }
}

package example.view.message
{
    import example.actors.GlobalContext;
    import example.actors.notifications.IOnSheepCountChanged;
    import org.dropframework.mvc.view.Mediator;

    public class MessagePanelMediator
        extends Mediator
        implements IOnSheepCountChanged
    {
        public function MessagePanelMediator(view : MessagePanel)
        {
            super(GlobalContext.instance, view);
        }


        /* listen for the sheep count change to update the sheep count */
        public function onSheepCountChanged(sheepCount : uint) : void
        {
            messagePanel.dataProvider = (sheepCount != 0) ?
                    "Sheep herd has " + sheepCount + " sheeps" :
                    "Sheep herd is empty";
        }

        /* listen for the disaster event to print that out */
        public function onDisasterHappened(sheepCount : uint, description : String) : void
        {
            messagePanel.dataProvider = description;
        }


        private function get messagePanel() : MessagePanel
        {
            return adapter.view as MessagePanel;
        }
    }
}

package sandboxes.tiny.controller
{
    import org.dropframework.core.contexts.IContext;
    import org.dropframework.mvc.controller.Controller;

    import sandboxes.tiny.actors.notifications.IOnExtendedEvent;
    import sandboxes.tiny.actors.notifications.IOnParameterizedEvent;

    import sandboxes.tiny.actors.notifications.IOnSimpleEvent;

    public class EventListener
        extends Controller
        implements IOnSimpleEvent,
                   IOnExtendedEvent,
                   IOnParameterizedEvent
    {
        private var _eventCount : int = 0;



        public function EventListener(context : IContext)
        {
            super(context);
        }


        public function get eventCount():int
        {
            return _eventCount;
        }


        public function onSimpleEvent():void
        {
            _eventCount++;
        }


        public function onExtendedEvent():void
        {
            _eventCount++;
        }


        public function onParameterizedEvent1(param:String):void
        {
            _eventCount++;
        }


        public function onParameterizedEvent2(param:String):void
        {
            _eventCount++;
        }


        public function onParameterizedEvent3(param:String, additionalParam:String):void
        {
            _eventCount++;
        }
    }
}

package sandboxes.tiny.controller
{
    import org.dropframework.core.contexts.IContext;
    import org.dropframework.mvc.controller.Controller;

    import sandboxes.tiny.actors.notifications.IOnExtendedEvent;
    import sandboxes.tiny.actors.notifications.IOnParameterizedEvent;

    import sandboxes.tiny.actors.notifications.IOnSimpleEvent;

    import sandboxes.tiny.actors.singletones.IEventCounter;

    import sandboxes.tiny.actors.singletones.ISomeController;

    public class SomeController
        extends Controller
        implements ISomeController,
                   IOnSimpleEvent,
                   IOnExtendedEvent,
                   IOnParameterizedEvent,
                   IEventCounter
    {
        private static var _instances : int = 0;
        public static function get instances () : int
        {
            return _instances;
        }

        public static function resetInstances () : void
        {
            _instances = 0;
        }



        private var _eventCount : int = 0;


        public function SomeController(context : IContext)
        {
            super(context);
            _instances++;
        }


        public function doSomething(name:String):String
        {
            return "Hello " + name + "!";
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
    }
}

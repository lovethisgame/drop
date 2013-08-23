package sandboxes.tiny.controller
{
    import org.dropframework.core.contexts.IContext;
    import org.dropframework.mvc.controller.Controller;

    import sandboxes.tiny.actors.singletones.ISomeController;

    public class SomeController
        extends Controller
        implements ISomeController
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


        public function SomeController(context : IContext)
        {
            super(context);
            _instances++;
        }


        public function doSomething(name:String):String
        {
            return "Hello " + name + "!";
        }
    }
}

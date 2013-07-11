package example.actors
{
    import org.dropframework.core.contexts.Context;


    public class GlobalContext
        extends Context
    {
        private static const _instance : GlobalContext = new GlobalContext();
        public static function get instance () : GlobalContext
        {
            return _instance;
        }
    }
}

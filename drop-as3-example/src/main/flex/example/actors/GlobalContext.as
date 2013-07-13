package example.actors
{
    import org.dropframework.core.contexts.Context;


    /* Core application context where all actors are registered */
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

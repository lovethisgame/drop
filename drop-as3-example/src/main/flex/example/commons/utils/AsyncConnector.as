package example.commons.utils
{
    import example.model.vos.Response;

    /* for simplicity reasons, this utility class is only a stub */
    public class AsyncConnector
    {
        public static function get networkAvailable () : Boolean
        {
            return false;
        }

        public static function invoke
                (endpoint : String, method : String, callback : Function) : void
        {
            callback(Response.ofError("Method .invoke is not implemented on AsyncConnector"));
        }
    }
}

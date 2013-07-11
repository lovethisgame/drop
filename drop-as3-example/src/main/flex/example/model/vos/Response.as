package example.model.vos
{
    public class Response
    {
        public var error : String;
        public var content : Object;

        public function hasError () : Boolean
        {
            return error != null;
        }


        public static function of (error : String, content : Object) : Response
        {
            var result : Response = new Response();
            result.error = error;
            result.content = content;
            return result;
        }

        public static function ofError (error : String) : Response
        {
            var result : Response = new Response();
            result.error = error;
            return result;
        }

        public static function ofContent (content : Object) : Response
        {
            var result : Response = new Response();
            result.content = content;
            return result;
        }
    }
}

package sandboxes.tiny.actors.notifications
{
    public interface IOnParameterizedEvent
    {
        function onParameterizedEvent1(param : String) : void;

        function onParameterizedEvent2(param : String) : void;

        function onParameterizedEvent3(param : String, additionalParam : String) : void;
    }
}

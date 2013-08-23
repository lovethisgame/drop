package sandboxes.tiny.actors.notifications
{
    public interface IOnExtendedEvent
        extends IOnSimpleEvent
    {
        function onExtendedEvent() : void;
    }
}

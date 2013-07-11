package example.actors.notifications
{
    public interface IOnSheepCountChanged
    {
        function onSheepCountChanged() : void;

        function onDisasterHappened (description : String) : void;
    }
}

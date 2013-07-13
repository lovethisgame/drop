package example.actors.notifications
{
    public interface IOnSheepCountChanged
    {
        function onSheepCountChanged (sheepCount : uint) : void;
        function onDisasterHappened (sheepCount : uint, description : String) : void;
    }
}

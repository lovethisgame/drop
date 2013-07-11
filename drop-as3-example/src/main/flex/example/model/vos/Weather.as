package example.model.vos
{
    public class Weather
    {
        public var temperature : Number /* in C */;
        public var windspeed : Number /* in m/s */;

        public function get isStorm () : Boolean
        {
            return windspeed >= 24.5;
        }

        public static function of (temperature : Number, windspeed : Number) : Weather
        {
            var result : Weather = new Weather();
            result.temperature = temperature;
            result.windspeed = windspeed;
            return result;
        }
    }
}

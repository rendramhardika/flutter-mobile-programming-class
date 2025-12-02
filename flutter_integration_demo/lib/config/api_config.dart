/// API Configuration
/// 
/// IMPORTANT: Paste your API keys here
class ApiConfig {
  // OpenWeatherMap API Key
  // Get your free API key from: https://openweathermap.org/api
  // static const String openWeatherMapApiKey = 'PASTE_YOUR_OPENWEATHERMAP_API_KEY_HERE';
  static const String openWeatherMapApiKey = '587bd8dc2f4641b7365d23008d4f8725';
  
  // WAQI (World Air Quality Index) API Key
  // Get your free API key from: https://aqicn.org/data-platform/token/
  // static const String waqiApiKey = 'PASTE_YOUR_WAQI_API_KEY_HERE';
  static const String waqiApiKey = '6b7fa7ffb03735797cf08b3a98d1900da54f281b';
  
  // NewsAPI.org API Key
  // Get your free API key from: https://newsapi.org/register
  // static const String newsApiKey = 'PASTE_YOUR_NEWSAPI_API_KEY_HERE';
    static const String newsApiKey = '4fc2e823d4e640f7b0281e8dfec9a525';
  
  // API Base URLs
  static const String openWeatherMapBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String waqiBaseUrl = 'https://api.waqi.info';
  static const String newsApiBaseUrl = 'https://newsapi.org/v2';
  
  // Default location (Medan, Indonesia)
  static const double defaultLatitude = 3.5952;
  static const double defaultLongitude = 98.6722;
  static const String defaultCityName = 'Medan';
}

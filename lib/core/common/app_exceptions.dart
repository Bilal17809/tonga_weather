class AppExceptions {
  final String deniedPermission =
      'Location services are disabled. Please enable location services.';
  final String timeoutException = 'Failed to get current location';
  final String errorAppInit = 'Error during app initialization';
  // final String successCityChange = 'Current location is now the main city';
  final String failToSave = 'Failed to save selected cities to storage';
  final String failToLoad = 'Failed to load selected cities from storage';
  final String failToLoadWeather = 'Failed to load weather data';
  final String failToSelect = 'Error selecting city';
  final String locationFetchError = 'Failed to fetch current location:';
  final String failedApiCall = 'Failed to call API';
  // final String noCityFound = 'No cities found matching';
  final String noCityInApi = 'City name not found in the response';
  final String firstLaunch = 'Error checking first launch';
  // final String failedLoadingWeather = 'Failed to load weather data';
  final String noInternet = 'No internet at startup – retry dialog shown';
  // final String failedLocation =
  //     'Failed to detect your current location. Try again later.';
}

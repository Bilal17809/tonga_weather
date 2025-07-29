class AppExceptions {
  final String deniedPermission =
      'Location permission not granted or failed to fetch.';
  final String timeoutException = 'Failed to get current location';
  final String errorAppInit = 'Error during app initialization';
  final String failToSave = 'Failed to save selected cities to storage';
  final String failToLoad = 'Failed to load selected cities from storage';
  final String failToLoadWeather = 'Failed to load weather data';
  final String failToSelect = 'Error selecting city';
  final String locationFetchError = 'Failed to fetch current location:';
  final String failedApiCall = 'Failed to call API';
  final String noCityInApi = 'City name not found in the response';
  final String firstLaunch = 'Error checking first launch';
  final String noInternet = 'No internet';
}

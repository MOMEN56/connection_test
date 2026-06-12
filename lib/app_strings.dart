/// Centralizes user-facing text to avoid hardcoded strings across screens.
class AppStrings {
  const AppStrings._();

  static const appTitle = 'Connection Test';
  static const checkingConnection = 'Checking your connection...';

  static const noNetworkTitle = 'No network connection';
  static const noNetworkMessage =
      'Your device is not connected to Wi-Fi or mobile data.';

  static const noInternetTitle = 'Connected, but no internet';
  static const noInternetMessage =
      'Your device is connected to a network, but this network has no '
      'internet access.';

  static const homeTitle = 'Flutter Demo Home Page';
  static const counterMessage = 'You have pushed the button this many times:';
  static const incrementTooltip = 'Increment';
}

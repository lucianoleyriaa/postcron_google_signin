import '../models/configurations.dart';

class Config {

  static const env = String.fromEnvironment('ENV', defaultValue: 'prod');

  static Configuration environment() {
    final Configuration config;

    switch (env) {
      case 'prod':
      default:
        config = const Configuration(
          env: 'prod', 
          apiUrl: 'https://postcron.com/api/v2.0', 
          webViewUrl: 'https://postcron.com/'
        );
        break;
    }

    return config;
  }
}
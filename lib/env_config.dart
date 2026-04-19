import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

/// Part 4: Environment Configuration
class EnvConfig {
  static Future<void> loadEnv() async {
    // If in release mode (production), load prod config, else dev config
    const envFile = kReleaseMode ? '.env.prod' : '.env.dev';
    try {
      await dotenv.load(fileName: envFile);
    } catch (e) {
      debugPrint(
        '⚠️ Warning: Could not load $envFile file. Using fallback values.',
      );
    }
  }

  static String get apiUrl {
    return dotenv.env['API_URL'] ?? 'https://localhost:8080';
  }

  static String get environmentName {
    return dotenv.env['APP_ENV'] ?? 'development';
  }
}

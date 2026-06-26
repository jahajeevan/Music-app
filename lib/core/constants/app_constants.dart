class AppConstants {
  AppConstants._();

  // Supabase — replace with real project values
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://your-project.supabase.co',
  );
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'your-anon-key',
  );

  // App
  static const appName = 'Wavelength';
  static const appVersion = '1.0.0';

  // Audio quality bitrates
  static const qualityNormal = 128;
  static const qualityHigh = 256;
  static const qualityVeryHigh = 320;

  // Playback
  static const defaultCrossfadeDuration = 5; // seconds
  static const maxDownloadTracks = 10000;
  static const progressReportInterval = 30; // seconds

  // Search
  static const searchDebounceMs = 300;
  static const searchResultsLimit = 50;

  // Pagination
  static const pageSize = 30;

  // Cache
  static const imageCacheMaxAge = Duration(days: 7);
  static const recommendationCacheAge = Duration(hours: 6);

  // Sleep timer options (minutes)
  static const sleepTimerOptions = [15, 30, 45, 60];
}

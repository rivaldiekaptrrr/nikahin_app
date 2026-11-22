import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nikahin_app/data/local/preferences_manager.dart';
import 'package:nikahin_app/features/dashboard/presentation/hero_cover_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Hero Cover Photo & Preferences Unit Tests', () {
    test('getHeroCoverPhoto returns null when empty', () async {
      final photo = await AppPreferences.getHeroCoverPhoto('profile_123');
      expect(photo, isNull);
    });

    test('setHeroCoverPhoto saves and retrieves path correctly', () async {
      await AppPreferences.setHeroCoverPhoto('profile_123', '/data/user/hero.jpg');
      final photo = await AppPreferences.getHeroCoverPhoto('profile_123');
      expect(photo, equals('/data/user/hero.jpg'));

      // Remove photo
      await AppPreferences.setHeroCoverPhoto('profile_123', null);
      final photoAfterRemove = await AppPreferences.getHeroCoverPhoto('profile_123');
      expect(photoAfterRemove, isNull);
    });

    test('heroCoverNotifierProvider initializes and updates state', () async {
      await AppPreferences.setHeroCoverPhoto('profile_abc', '/data/custom_photo.jpg');

      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Listen to the provider
      final initialVal = await container.read(heroCoverNotifierProvider('profile_abc').future);
      expect(initialVal, equals('/data/custom_photo.jpg'));

      // Remove photo via notifier
      await container.read(heroCoverNotifierProvider('profile_abc').notifier).removePhoto();
      final afterRemove = container.read(heroCoverNotifierProvider('profile_abc')).value;
      expect(afterRemove, isNull);

      final prefsValue = await AppPreferences.getHeroCoverPhoto('profile_abc');
      expect(prefsValue, isNull);
    });

    test('heroCoverNotifierProvider supports Base64 Data URL for web persistence', () async {
      const base64DataUri = 'data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEASABIAAD...';
      await AppPreferences.setHeroCoverPhoto('profile_web', base64DataUri);

      final container = ProviderContainer();
      addTearDown(container.dispose);

      final initialVal = await container.read(heroCoverNotifierProvider('profile_web').future);
      expect(initialVal, equals(base64DataUri));

      // Remove photo
      await container.read(heroCoverNotifierProvider('profile_web').notifier).removePhoto();
      expect(container.read(heroCoverNotifierProvider('profile_web')).value, isNull);
      expect(await AppPreferences.getHeroCoverPhoto('profile_web'), isNull);
    });
  });
}

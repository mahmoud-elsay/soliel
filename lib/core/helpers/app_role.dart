import 'package:soliel/core/helpers/shared_pref_helper.dart';

import 'package:soliel/core/routing/routes.dart';

sealed class AppRole {
  const AppRole();

  String get displayNameArabic;
  String get storageKey;
  String get initialRouteAfterLogin;
}

class DoctorRole extends AppRole {
  const DoctorRole();

  @override
  String get displayNameArabic => 'دكتور';

  @override
  String get storageKey => 'doctor';

  @override
  String get initialRouteAfterLogin => Routes.doctorProfileScreen;
}

class ParentRole extends AppRole {
  const ParentRole();

  @override
  String get displayNameArabic => 'ولي الأمر';

  @override
  String get storageKey => 'parent';

  @override
  String get initialRouteAfterLogin => Routes.parentLayout;
}

class WebsiteRole extends AppRole {
  const WebsiteRole();

  @override
  String get displayNameArabic => 'الموقع الإلكتروني';

  @override
  String get storageKey => 'website';

  @override
  String get initialRouteAfterLogin => Routes.homeScreen;
}

// ────────────────────────────────────────────────
// Factory & Helpers
// ────────────────────────────────────────────────

class AppRoleFactory {
  AppRoleFactory._();

  static AppRole? fromStorageKey(String? key) {
    if (key == null) return null;
    return switch (key.toLowerCase()) {
      'doctor' => const DoctorRole(),
      'parent' => const ParentRole(),
      'website' => const WebsiteRole(),
      _ => null,
    };
  }

  static Future<AppRole?> getCurrentRole() async {
    final key = await StorageHelper.getString('selected_role');
    return fromStorageKey(key);
  }

  static Future<void> saveRole(AppRole role) async {
    await StorageHelper.setValue('selected_role', role.storageKey);
  }

  static Future<void> clearRole() async {
    await StorageHelper.remove('selected_role');
  }
}

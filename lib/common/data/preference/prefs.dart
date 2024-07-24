import 'package:planZ/common/data/preference/item/nullable_preference_item.dart';
import 'package:planZ/common/theme/custom_theme.dart';

class Prefs {
  static final appTheme = NullablePreferenceItem<CustomTheme>('appTheme');
}

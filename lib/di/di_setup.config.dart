// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:project1/presentation/viewmodel/diet_view_model.dart' as _i562;
import 'package:project1/presentation/viewmodel/favorite_food_drawer_view_model.dart'
    as _i739;
import 'package:project1/presentation/viewmodel/favorite_food_view_model.dart'
    as _i929;
import 'package:project1/presentation/viewmodel/home_view_model.dart' as _i876;
import 'package:project1/presentation/viewmodel/login_view_model.dart' as _i29;
import 'package:project1/presentation/viewmodel/profile_setting_view_model.dart'
    as _i954;
import 'package:project1/presentation/viewmodel/profile_view_model.dart'
    as _i168;
import 'package:project1/presentation/viewmodel/splash_view_model.dart'
    as _i977;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.factory<_i562.DietViewModel>(() => _i562.DietViewModel());
    gh.factory<_i739.FavoriteFoodDrawerViewModel>(
        () => _i739.FavoriteFoodDrawerViewModel());
    gh.factory<_i929.FavoriteFoodViewModel>(
        () => _i929.FavoriteFoodViewModel());
    gh.factory<_i876.HomeViewModel>(() => _i876.HomeViewModel());
    gh.factory<_i29.LoginViewModel>(() => _i29.LoginViewModel());
    gh.factory<_i168.ProfileViewModel>(() => _i168.ProfileViewModel());
    gh.factory<_i977.SplashViewModel>(() => _i977.SplashViewModel());
    gh.factory<_i954.ProfileSettingViewModel>(
        () => _i954.ProfileSettingViewModel());
    return this;
  }
}

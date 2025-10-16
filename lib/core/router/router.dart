import 'package:go_router/go_router.dart';
import 'package:project1/core/constant/app_route_path.dart';
import 'package:project1/di/di_setup.dart';
import 'package:project1/core/enum/meal_type.dart';
import 'package:project1/presentation/view/add_diet_view.dart';
import 'package:project1/presentation/view/favorite_food_view.dart';
import 'package:project1/presentation/view/food_search_view.dart';
import 'package:project1/presentation/view/home_view.dart';
import 'package:project1/presentation/view/login_view.dart';
import 'package:project1/presentation/view/proflie_set_view.dart';
import 'package:project1/presentation/view/splash_view.dart';
import 'package:project1/presentation/viewmodel/diet_view_model.dart';
import 'package:project1/presentation/viewmodel/favorite_food_view_model.dart';
import 'package:project1/presentation/viewmodel/home_view_model.dart';
import 'package:project1/presentation/viewmodel/login_view_model.dart';
import 'package:project1/presentation/viewmodel/profile_set_view_model.dart';
import 'package:project1/presentation/viewmodel/splash_view_model.dart';
import 'package:provider/provider.dart';

// GoRouter configuration
final router = GoRouter(
  initialLocation: AppRoutePath.splash,
  routes: [
    _splash,
    _login,
    _home,
    _foodSearch,
    _addDiet,
    _favoriteFood,
    _profileSetting,
  ],
);

// 스플래시
final _splash = GoRoute(
  path: AppRoutePath.splash,
  builder: (context, state) => ChangeNotifierProvider(
      create: (context) => getIt<SplashViewModel>(),
      builder: (context, child) {
        return SplashView();
      }),
);

// 로그인
final _login = GoRoute(
  path: AppRoutePath.login,
  builder: (context, state) => ChangeNotifierProvider(
      create: (context) => getIt<LoginViewModel>(),
      builder: (context, child) {
        return LoginView();
      }),
);

// 홈
final _home = GoRoute(
  path: AppRoutePath.home,
  builder: (context, state) => ChangeNotifierProvider(
      create: (context) => getIt<HomeViewModel>(),
      builder: (context, child) {
        return HomeView();
      }),
);

// 음식검색
final _foodSearch = GoRoute(
  path: AppRoutePath.foodSearch,
  builder: (context, state) => ChangeNotifierProvider.value(
      value: (state.extra! as Map)["dietVM"] as DietViewModel,
      builder: (context, child) {
        return FoodSearchView((state.extra! as Map)["mealType"] as MealType);
      }),
);

// 식단추가
final _addDiet = GoRoute(
  path: AppRoutePath.addDiet,
  builder: (context, state) => MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: (state.extra! as Map)["homeVM"] as HomeViewModel),
        ChangeNotifierProvider.value(
            value: (state.extra! as Map)["dietVM"] as DietViewModel),
      ],
      builder: (context, child) {
        return AddDietView((state.extra! as Map)["mealType"] as MealType);
      }),
);

// 음식 즐겨찾기
final _favoriteFood = GoRoute(
  path: AppRoutePath.favoriteFood,
  builder: (context, state) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => getIt<FavoriteFoodViewModel>()),
        ChangeNotifierProvider.value(value: state.extra! as HomeViewModel),
      ],
      builder: (context, child) {
        return FavoriteFoodView();
      }),
);

// 프로필설정
final _profileSetting = GoRoute(
  path: AppRoutePath.profileSetting,
  builder: (context, state) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => getIt<ProfileSettingViewModel>()),
        ChangeNotifierProvider.value(value: state.extra! as HomeViewModel)
      ],
      builder: (context, child) {
        return ProfileSettingView();
      }),
);

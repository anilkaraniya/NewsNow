import 'package:get_it/get_it.dart';

import 'package:news_now/src/repository/auth_repo.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthRepo>(AuthRepo());
}

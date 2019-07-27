import 'package:mimos/models/index.dart';

import './string.utils.dart';

String formatUser(UserModel user, [UserModel activeUser]) {
  if (activeUser != null && activeUser.id == user.id) { return 'You'; }
  return capitalizeWord(user.firstName) + ' ' + capitalizeWord(user.lastName)[0] + '.';
}

String formatUserInitials(UserModel user, [UserModel activeUser]) {
  return user.firstName.substring(0, 1).toUpperCase() + user.lastName.substring(0, 1).toUpperCase();
}

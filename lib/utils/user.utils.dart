import './string.utils.dart';
import '../models/index.dart';

String formatUser(UserModel user, [UserModel activeUser]) {
  if (activeUser != null && activeUser.id == user.id) { return 'You'; }
  return capitalizeWord(user.firstName) + ' ' + capitalizeWord(user.lastName)[0] + '.';
}

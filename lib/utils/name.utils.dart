import './string.utils.dart';
import '../models/user.model.dart';

String formatName(UserModel user, [UserModel activeUser]) {
  if (activeUser != null && activeUser.id == user.id) { return 'You'; }
  return capitalizeWord(user.firstName) + ' ' + capitalizeWord(user.lastName)[0] + '.';
}

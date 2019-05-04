import './string.utils.dart';
import '../models/user.model.dart';

String formatName(UserModel user) {
  return capitalizeWord(user.firstName) + ' ' + capitalizeWord(user.lastName)[0] + '.';
}

import '../models/user.model.dart';

String formatName(UserModel user) {
  return _formatFirstName(user.firstName) + ' ' + _formatLastName(user.lastName);
}

String _formatFirstName(String firstName) {
  return firstName[0].toUpperCase() + firstName.substring(1).toLowerCase();
}

String _formatLastName(String lastName) {
  return lastName[0].toUpperCase() + '.';
}

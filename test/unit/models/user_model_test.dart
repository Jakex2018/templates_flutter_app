import 'package:flutter_test/flutter_test.dart';
import 'package:templates_flutter_app/models/user_model.dart';

void main() {
  test('UserModel Test', () {
    final json = {
      'id': '2213',
      'username': 'John Doe',
      'email': 'john@doe.com',
      'isSubscribed': false
    };
    final user = UserModel.fromJson(json);

    expect(user.id, '2213');
    expect(user.username, 'John Doe');
  });
}

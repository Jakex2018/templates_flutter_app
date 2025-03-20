import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:templates_flutter_app/models/connectivity_model.dart';

void main() {
  group('ConnectivityModel', () {
    test('should return the correct connectivityResult', () {
      // Arrange
      final connectivityModel = ConnectivityModel();

      // Act
      final result = connectivityModel.connectivityResult;

      // Assert
      expect(result, ConnectivityResult.none);
    });
  });
}

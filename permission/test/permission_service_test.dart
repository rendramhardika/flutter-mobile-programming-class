import 'package:flutter_test/flutter_test.dart';
import 'package:permission/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  group('PermissionService', () {
    late PermissionService permissionService;

    setUp(() {
      permissionService = PermissionService();
    });

    test('getStatusDescription returns correct description for granted', () {
      final description = permissionService.getStatusDescription(
        PermissionStatus.granted,
      );
      expect(description, 'Granted');
    });

    test('getStatusDescription returns correct description for denied', () {
      final description = permissionService.getStatusDescription(
        PermissionStatus.denied,
      );
      expect(description, 'Denied');
    });

    test('getStatusDescription returns correct description for permanently denied', () {
      final description = permissionService.getStatusDescription(
        PermissionStatus.permanentlyDenied,
      );
      expect(description, 'Permanently Denied');
    });

    test('getStatusDescription returns correct description for restricted', () {
      final description = permissionService.getStatusDescription(
        PermissionStatus.restricted,
      );
      expect(description, 'Restricted');
    });

    test('getStatusDescription returns correct description for limited', () {
      final description = permissionService.getStatusDescription(
        PermissionStatus.limited,
      );
      expect(description, 'Limited');
    });

    test('getStatusColor returns correct color for granted', () {
      final color = permissionService.getStatusColor(
        PermissionStatus.granted,
      );
      expect(color, 'green');
    });

    test('getStatusColor returns correct color for denied', () {
      final color = permissionService.getStatusColor(
        PermissionStatus.denied,
      );
      expect(color, 'orange');
    });

    test('getStatusColor returns correct color for permanently denied', () {
      final color = permissionService.getStatusColor(
        PermissionStatus.permanentlyDenied,
      );
      expect(color, 'red');
    });
  });
}

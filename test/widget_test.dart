import 'package:flutter_test/flutter_test.dart';
import 'package:bottle_sharing_app_admin/main.dart';

void main() {
  testWidgets('App renders login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that Share Bottle and Admin Login titles are displayed
    expect(find.text('Share Bottle'), findsOneWidget);
    expect(find.text('Admin Login'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
  });
}

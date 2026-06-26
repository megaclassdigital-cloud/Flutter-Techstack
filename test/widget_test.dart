import 'package:flutter_test/flutter_test.dart';
import 'package:techstack/main.dart';

void main() {
  testWidgets('App starts and shows splash screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TechstackHubApp());

    expect(find.text('TechStack'), findsOneWidget);
    expect(find.text('Software Catalog, Elevated'), findsOneWidget);
  });
}

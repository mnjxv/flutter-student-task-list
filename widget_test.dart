import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:student_task_list/main.dart';

Future<void> addTask(WidgetTester tester, String name, String deadline) async {
  await tester.tap(find.text('Add task'));
  await tester.pumpAndSettle();

  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), name);
  await tester.enterText(fields.at(1), deadline);

  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Shows student card and empty state', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskListApp());

    expect(find.text('Student Name'), findsOneWidget);
    expect(find.text('My Tasks'), findsOneWidget);
    expect(find.text('No tasks yet'), findsOneWidget);
  });

  testWidgets('Dialog validates required fields', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskListApp());

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    expect(find.text('Add Task'), findsOneWidget);

    await tester.tap(find.text('Save'));
    await tester.pump();

    expect(find.text('Task name is required'), findsOneWidget);
    expect(find.text('Deadline is required'), findsOneWidget);
  });

  testWidgets('Cancel closes the dialog without adding a task',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TaskListApp());

    await tester.tap(find.text('Add task'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Add Task'), findsNothing);
    expect(find.text('No tasks yet'), findsOneWidget);
  });

  testWidgets('Can add a task and check it off', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskListApp());

    await addTask(tester, 'Finish report', 'Friday 5 PM');

    expect(find.text('Finish report'), findsOneWidget);
    expect(find.text('Friday 5 PM'), findsOneWidget);
    expect(find.text('No tasks yet'), findsNothing);

    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isFalse);
    await tester.tap(find.byType(Checkbox));
    await tester.pump();
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).value, isTrue);
  });

  testWidgets('Can add several tasks', (WidgetTester tester) async {
    await tester.pumpWidget(const TaskListApp());

    await addTask(tester, 'Task one', 'Monday');
    await addTask(tester, 'Task two', 'Tuesday');

    expect(find.text('Task one'), findsOneWidget);
    expect(find.text('Task two'), findsOneWidget);
    expect(find.byType(Checkbox), findsNWidgets(2));
  });
}

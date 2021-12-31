import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:lu_cse_community/provider/notification_services.dart';
import 'package:provider/provider.dart';

Future onError(BuildContext context, String massage) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('An error occurred'),
      content: Text(massage),
      actions: <Widget>[
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.of(ctx).pop();
          },
        )
      ],
    ),
  );
}

durationPicker({
  required BuildContext ctx,
  required String name,
  required int remainingTime,
  required String site,
}) async {
  return Picker(
    adapter: NumberPickerAdapter(data: <NumberPickerColumn>[
      const NumberPickerColumn(begin: 0, end: 99, suffix: Text(' hours')),
      const NumberPickerColumn(
          begin: 0, initValue: 10, end: 60, suffix: Text(' min'), jump: 5),
    ]),
    delimiter: <PickerDelimiter>[
      PickerDelimiter(
        child: Container(
          width: 30.0,
          alignment: Alignment.center,
          child: const Icon(Icons.more_vert),
        ),
      )
    ],
    hideHeader: true,
    cancelText: "",
    confirmText: 'OK',
    confirmTextStyle:
        const TextStyle(inherit: false, color: Color(0xff75cfb8), fontSize: 15),
    title: const Text('Remind me before'),
    selectedTextStyle: const TextStyle(color: Color(0xff75cfb8)),
    onConfirm: (Picker picker, List<int> value) async {
      int _duration = Duration(
        hours: picker.getSelectedValues()[0],
        minutes: picker.getSelectedValues()[1],
      ).inSeconds;

      if (_duration > remainingTime) {
        onError(ctx, "Please select time less than start time");
      } else {
        await NotificationService().showNotification(
          name.hashCode,
          site,
          name,
          (remainingTime + 10) - _duration,
        );
        Provider.of<NotificationService>(ctx, listen: false)
            .changeNotificationButton();
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text('Reminder added'),
        ));
      }
    },
  ).showDialog(ctx);
}

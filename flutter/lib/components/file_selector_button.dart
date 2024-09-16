import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FileSelectorButton extends StatelessWidget {
  final String buttonText;
  final Function(String) onFileSelected;

  const FileSelectorButton({
    Key? key,
    required this.buttonText,
    required this.onFileSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      onPressed: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          onFileSelected(result.files.single.path!);
        }
      },
      text: Text(buttonText),
    );
  }
}

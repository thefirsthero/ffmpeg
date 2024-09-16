import 'package:file_picker/file_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class FolderSelectorButton extends StatelessWidget {
  final String buttonText;
  final Function(String) onFolderSelected;

  const FolderSelectorButton({
    Key? key,
    required this.buttonText,
    required this.onFolderSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      onPressed: () async {
        String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath();
        if (selectedDirectory != null) {
          onFolderSelected(selectedDirectory);
        }
      },
      text: Text(buttonText),
    );
  }
}

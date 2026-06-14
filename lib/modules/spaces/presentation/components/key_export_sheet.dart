import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/theme/gatewise_theme.dart';

enum KeyExportAction { save, share }

Future<File> resolveKeyFile(String filename, String content) async {
  if (Platform.isAndroid) {
    final extDir = await getExternalStorageDirectory();
    if (extDir != null) {
      final downloadsPath =
          '${extDir.parent.parent.parent.parent.path}/Download/$filename';
      try {
        final f = File(downloadsPath);
        await f.writeAsString(content);
        return f;
      } catch (_) {
        final f = File('${extDir.path}/$filename');
        await f.writeAsString(content);
        return f;
      }
    }
  }
  final dir = await getApplicationDocumentsDirectory();
  final f = File('${dir.path}/$filename');
  await f.writeAsString(content);
  return f;
}

Future<void> executeKeyAction({
  required BuildContext context,
  required KeyExportAction action,
  required String filename,
  required String content,
}) async {
  try {
    final file = await resolveKeyFile(filename, content);
    if (!context.mounted) return;
    if (action == KeyExportAction.save) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Salvo em: ${file.path}')),
      );
    } else {
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/x-pem-file')],
        subject: filename,
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          backgroundColor: GateWiseColors.danger,
        ),
      );
    }
  }
}

Future<void> exportKey({
  required BuildContext context,
  required String filename,
  required String content,
  required String sheetTitle,
}) async {
  final action = await showModalBottomSheet<KeyExportAction>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => KeyExportSheet(title: sheetTitle),
  );
  if (action == null || !context.mounted) return;

  await executeKeyAction(
    context: context,
    action: action,
    filename: filename,
    content: content,
  );
}

class KeyExportSheet extends StatelessWidget {
  const KeyExportSheet({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GateWiseColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: GateWiseColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(
              Icons.download_rounded,
              color: GateWiseColors.electricBlue,
            ),
            title: const Text(
              'Salvar no dispositivo',
              style: TextStyle(color: GateWiseColors.textPrimary),
            ),
            subtitle: Text(
              'Salva o arquivo .pem no armazenamento local',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 12,
              ),
            ),
            onTap: () => Navigator.of(context).pop(KeyExportAction.save),
          ),
          ListTile(
            leading: const Icon(
              Icons.share_rounded,
              color: GateWiseColors.electricBlue,
            ),
            title: const Text(
              'Compartilhar',
              style: TextStyle(color: GateWiseColors.textPrimary),
            ),
            subtitle: Text(
              'Abre o compartilhamento do sistema',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 12,
              ),
            ),
            onTap: () => Navigator.of(context).pop(KeyExportAction.share),
          ),
        ],
      ),
    );
  }
}

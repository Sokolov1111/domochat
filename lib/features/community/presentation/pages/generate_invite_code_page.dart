import 'package:domochat/utils/community_codec.dart';
import 'package:flutter/material.dart';

class GenerateInviteCodePage extends StatefulWidget {
  final String communityId;
  const GenerateInviteCodePage({super.key, required this.communityId});

  @override
  State<GenerateInviteCodePage> createState() => _GenerateInviteCodePageState();
}

class _GenerateInviteCodePageState extends State<GenerateInviteCodePage> {
  String? _generatedCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пригласительный код'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text('Код приглашения'),
                    const SizedBox(height: 10,),
                    Text(
                      _generatedCode ?? 'Нажмите кнопку для генерации',
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => setState(() {
                          _generatedCode = CommunityCodec.encode(widget.communityId);
                        }),
                        child: const Text('Сгенерировать код')
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

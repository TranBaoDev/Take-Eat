import 'package:flutter/material.dart';
import 'package:take_eat/l10n/l10n.dart';
import 'package:take_eat/shared/widgets/app_scaffold.dart';

class HelpsScreen extends StatelessWidget {
  const HelpsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final questions = List.generate(
      6,
      (index) => {
        'question': context.l10n.questionFaq,
        'answer': context.l10n.answerFaq,
      },
    );
    final size = MediaQuery.of(context).size;
    return AppScaffold(
      title: 'Help & FAQs',
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                itemCount: questions.length,
                separatorBuilder: (_, __) => const Divider(
                  color: Color(0xFFFF6B35),
                  thickness: 0.5,
                ),
                itemBuilder: (context, index) {
                  final item = questions[index];
                  return Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                        bottom: 12,
                      ),
                      title: Text(
                        item["question"]!,
                        style: const TextStyle(
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      iconColor: const Color(0xFFFF6B35),
                      collapsedIconColor: const Color(0xFFFF6B35),
                      children: [
                        Text(
                          item["answer"]!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

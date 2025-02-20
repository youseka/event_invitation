import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../guest_book.dart';
import '../src/widgets.dart';
import 'yes_no_selection.dart';

class DiscussionSection extends StatelessWidget {
  const DiscussionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          switch (appState.attendees) {
            1 => const Paragraph('1 person going'),
            >= 2 => Paragraph('${appState.attendees} people going'),
            _ => const Paragraph('No one going'),
          },
          if (appState.loggedIn) ...[
            YesNoSelection(
              state: appState.attending,
              onSelection: (attending) => appState.attending = attending,
            ),
            const Header('Discussion'),
            GuestBook(
              addMessage: (message) => appState.addMessageToGuestBook(message),
              messages: appState.guestBookMessages,
            ),
          ],
        ],
      ),
    );
  }
}

import 'package:ask_a_task/features/auth/pages/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      providerConfigs: const [
        EmailProviderConfiguration(),
      ],
      actions: [
        SignedOutAction(
          (context) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => const AuthGate()),
              ),
            );
          },
        ),
      ],
      avatarSize: 50,
    );
  }
}

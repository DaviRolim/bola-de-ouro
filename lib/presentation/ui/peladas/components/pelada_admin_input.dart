import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/pelada_provider.dart';

class SecretPeladaAdminInput extends StatelessWidget {
  final Size size;

  final TextEditingController _controller;
  const SecretPeladaAdminInput({
    Key? key,
    required this.size,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width * 0.7,
      child: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Pelada admin secret',
        ),
        onSubmitted: (String value) {
          context.read<PeladaProvider>().validatePeladaAdmin(value);
        },
      ),
    );
  }
}
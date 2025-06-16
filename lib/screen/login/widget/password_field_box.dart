import 'package:flutter/material.dart';

class PasswordFieldBox extends StatefulWidget {
  final TextEditingController controller;

  const PasswordFieldBox({super.key, required this.controller});

  @override
  State<PasswordFieldBox> createState() => _PasswordFieldBoxState();
}

class _PasswordFieldBoxState extends State<PasswordFieldBox> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility_off : Icons.visibility,
            color: colorScheme.primary,
          ),
          onPressed: (){
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      ),
      textInputAction: TextInputAction.done,
    );
  }
}

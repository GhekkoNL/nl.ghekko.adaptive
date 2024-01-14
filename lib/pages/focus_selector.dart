import 'package:adaptive/global/styling.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusSelector extends StatelessWidget {
  const FocusSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Insets.extraLarge),
      child: Center(
        child: SeparatedColumn(
          separatorBuilder: () => const SizedBox(height: 5),
          mainAxisSize: MainAxisSize.min,
          children: const [
            // Basic widget that can accept traversal, built with FocusableActionDetector
            Text("BasicActionDetector:"),
            BasicActionDetector(),
            SizedBox(height: 10),

            // Clickable widget that can accept traversal, built with FocusableActionDetector
            Text("AdvancedActionDetector:"),
            ClickableActionDetector(),
            SizedBox(height: 10),

            // A totally custom control, built by stacking together various widgets
            Text("CustomControl:"),
            ClickableControl(),
            TextListener(),
          ],
        ),
      ),
    );
  }
}

class TextListener extends StatefulWidget {
  const TextListener({super.key});

  @override
  State createState() => TextListenerState();
}

class TextListenerState extends State<TextListener> {
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Focus(
      onKey: (FocusNode node, RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (kDebugMode) {
            print(event.logicalKey);
          }
        }
        return KeyEventResult.ignored;
      },
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: const TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}

class BasicActionDetector extends StatefulWidget {
  const BasicActionDetector({super.key});

  @override
  State createState() => BasicActionDetectorState();
}

class BasicActionDetectorState extends State<BasicActionDetector> {
  bool _hasFocus = false;
  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      onFocusChange: (value) => setState(() => _hasFocus = value),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<Intent>(onInvoke: (Intent intent) {
          if (kDebugMode) {
            print("Enter or Space was pressed!");
          }
          return null;
        }),
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const FlutterLogo(size: 100),
          // Position focus in the negative margin for a cool effect
          if (_hasFocus) Positioned(left: -4, top: -4, bottom: -4, right: -4, child: _roundedBorder())
        ],
      ),
    );
  }
}

/// Uses [FocusableActionDetector]
class ClickableActionDetector extends StatefulWidget {
  const ClickableActionDetector({super.key});

  @override
  State createState() => ClickableActionDetectorState();
}

class ClickableActionDetectorState extends State<ClickableActionDetector> {
  bool _hasFocus = false;
  late final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      focusNode: _focusNode,
      mouseCursor: SystemMouseCursors.click,
      onFocusChange: (value) => setState(() => _hasFocus = value),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<Intent>(onInvoke: (Intent intent) {
          _submit();
          return null;
        }),
      },
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
          _submit();
        },
        child: Logo(showBorder: _hasFocus),
      ),
    );
  }

  void _submit() => print("Submit!");
}

// Example of a custom focus widget from scratch
class ClickableControl extends StatelessWidget {
  const ClickableControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Focus(
      // Process keyboard event
      onKey: _handleKeyDown,
      child: Builder(
        builder: (context) {
          // Check whether we have focus
          bool hasFocus = Focus.of(context).hasFocus;
          // Show hand cursor
          return MouseRegion(
            cursor: SystemMouseCursors.click,
            // Request focus when clicked
            child: GestureDetector(
              onTap: () {
                Focus.of(context).requestFocus();
                _submit();
              },
              child: Logo(showBorder: hasFocus),
            ),
          );
        },
      ),
    );
  }

  void _submit() => print("Submit!");

  KeyEventResult _handleKeyDown(FocusNode node, RawKeyEvent event) {
    if (event is RawKeyDownEvent && [LogicalKeyboardKey.enter, LogicalKeyboardKey.space].contains(event.logicalKey)) {
      _submit();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key, required this.showBorder});
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Content
        const FlutterLogo(size: 100),
        // Focus effect:
        if (showBorder) Positioned(left: 0, top: -4, bottom: -4, right: -4, child: _roundedBorder())
      ],
    );
  }
}

Widget _roundedBorder() => Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.orange), borderRadius: BorderRadius.circular(6)));

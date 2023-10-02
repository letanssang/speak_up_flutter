import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppSearchBar extends StatefulWidget {
  final VoidCallback onInitial;
  final VoidCallback onLoading;
  final Future<void> Function(String value) onSearch;
  const AppSearchBar({
    super.key,
    required this.onInitial,
    required this.onLoading,
    required this.onSearch,
  });

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;
  @override
  void dispose() {
    _debounce?.cancel();
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: TextField(
              controller: _textEditingController,
              focusNode: _focusNode,
              onTapOutside: (event) {
                _focusNode.unfocus();
              },
              onChanged: (value) {
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                widget.onLoading.call();
                _debounce = Timer(const Duration(milliseconds: 500), () async {
                  await widget.onSearch(value);
                });
              },
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                border: InputBorder.none,
              ),
            ),
          ),
          if (_textEditingController.text.isNotEmpty)
            IconButton(
                onPressed: () {
                  _textEditingController.clear();
                  widget.onInitial.call();
                },
                icon: const Icon(
                  Icons.cancel,
                )),
        ],
      ),
    );
  }
}

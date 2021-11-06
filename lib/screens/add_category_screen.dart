import 'package:flutter/material.dart';
import '../models/hero_dialog_route.dart';

class AddCategoryButton extends StatelessWidget {
  const AddCategoryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return _AddCategoryPopupCard();
          }));
        },
        child: Hero(
          tag: _heroAddCategory,
          child: Material(
            color: const Color(0xFF67B5FD),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 56,
            ),
          ),
        ),
      ),
    );
  }
}

// Tag-value used for the add category popup button.
const String _heroAddCategory = 'add-category-hero';

class _AddCategoryPopupCard extends StatefulWidget {
  // {@macro add_category_popup_card}
  _AddCategoryPopupCard({Key? key}) : super(key: key);

  @override
  State<_AddCategoryPopupCard> createState() => _AddCategoryPopupCardState();
}

class _AddCategoryPopupCardState extends State<_AddCategoryPopupCard> {
  bool isEnabled = true;

  var _text = TextEditingController();

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Hero(
          tag: _heroAddCategory,
          child: Material(
            color: const Color(0xFFECF4FB),
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _text,
                      focusNode: FocusNode(),
                      decoration: InputDecoration(
                        labelText: "Category Name",
                        errorText: _validate ? "Category can't be empty" : null,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _text.clear,
                        ),
                      ),
                      cursorColor: const Color(0xFF67B5FD),
                      enabled: isEnabled,
                      readOnly: !isEnabled,
                    ),
                    const Divider(
                      color: Color(0xFFECF4FB),
                      thickness: 0.5,
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            if (_text.text.isEmpty) {
                              _validate = true;
                            } else {
                              _validate = false;
                            }
                          });
                        },
                        child: const Text('Add'),
                        style: TextButton.styleFrom(primary: Colors.blue))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

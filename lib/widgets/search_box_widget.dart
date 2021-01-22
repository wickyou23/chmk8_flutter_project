import 'package:flutter/material.dart';
import 'package:chkm8_app/utils/extension.dart';

class SearchBoxWidget extends StatefulWidget {
  final List<String> items;
  final String itemSelected;
  final Function(String) onSelected;

  SearchBoxWidget(
    this.items, {
    this.itemSelected,
    this.onSelected,
  });

  @override
  _SearchBoxWidgetState createState() => _SearchBoxWidgetState();
}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {
  List<String> _filterItems = [];
  TextEditingController _searchController = TextEditingController();

  bool get _isFilter {
    return _searchController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleFilterText() {
    if (_searchController.text.isEmpty) {
      _filterItems = [];
    } else {
      _filterItems = this
          .widget
          .items
          .where(
            (element) => element
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()),
          )
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.media.size.width - 40,
      height: context.media.size.height * 0.7,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white38,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(4),
                  borderSide: BorderSide(
                    color: ColorExt.colorWithHex(0x12B3FF),
                    width: 0.5,
                  ),
                ),
                hintText: 'Search',
                hintStyle: context.theme.textTheme.headline5.copyWith(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (_) {
                _handleFilterText();
                setState(() {});
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: ListView.separated(
              itemBuilder: (ctx, idx) {
                String item =
                    (_isFilter) ? _filterItems[idx] : this.widget.items[idx];
                return ListTile(
                  contentPadding: const EdgeInsets.only(
                    top: 4,
                    bottom: 4,
                    left: 20,
                    right: 16,
                  ),
                  title: Text(
                    item,
                    style: context.theme.textTheme.headline5.copyWith(
                      fontSize: 17,
                      color: ColorExt.myBlack,
                    ),
                  ),
                  trailing: (this.widget.itemSelected == item)
                      ? Icon(
                          Icons.check,
                          color: ColorExt.mainColor,
                          size: 20,
                        )
                      : Container(
                          width: 1,
                        ),
                  onTap: () {
                    if (this.widget.onSelected != null) {
                      this.widget.onSelected(item);
                    }

                    context.navigator.pop();
                  },
                );
              },
              separatorBuilder: (ctx, idx) {
                return Divider(
                  height: 0.5,
                  color: Colors.grey[400],
                  indent: 16,
                  endIndent: 16,
                );
              },
              itemCount:
                  (_isFilter) ? _filterItems.length : this.widget.items.length,
            ),
          ),
        ],
      ),
    );
  }
}

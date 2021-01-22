import 'package:flutter/material.dart';

typedef int NumberOfRowsCallBack(int section);
typedef int NumberOfSectionCallBack();
typedef Widget SectionWidgetCallBack(int section);
typedef Widget RowsWidgetCallBack(int section, int row);

class SectionListView extends StatefulWidget {
  SectionListView({
    this.numberOfSection,
    @required this.numberOfRowsInSection,
    this.sectionWidget,
    @required this.rowWidget,
  }) : assert(!(numberOfRowsInSection == null || rowWidget == null),
            'numberOfRowsInSection and rowWidget are mandatory');

  final NumberOfSectionCallBack numberOfSection;
  final NumberOfRowsCallBack numberOfRowsInSection;
  final SectionWidgetCallBack sectionWidget;
  final RowsWidgetCallBack rowWidget;

  @override
  _SectionListViewState createState() => _SectionListViewState();
}

class _SectionListViewState extends State<SectionListView> {
  var itemList = new List<int>();
  int itemCount = 0;
  int sectionCount = 0;

  @override
  void initState() {
    sectionCount = widget.numberOfSection();
    itemCount = listItemCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return buildItemWidget(index);
      },
      key: widget.key,
    );
  }

  int listItemCount() {
    itemList = new List<int>();
    int rowCount = 0;

    for (int i = 0; i < sectionCount; i++) {
      int rows = widget.numberOfRowsInSection(i);
      rowCount += rows + 1;
      itemList.insert(i, rowCount);
    }
    return rowCount;
  }

  Widget buildItemWidget(int index) {
    IndexPath indexPath = sectionModel(index);
    if (indexPath.row < 0) {
      return widget.sectionWidget != null
          ? widget.sectionWidget(indexPath.section)
          : SizedBox(
              height: 0,
            );
    } else {
      return widget.rowWidget(indexPath.section, indexPath.row);
    }
  }

  IndexPath sectionModel(int index) {
    int row = 0;
    int section = 0;
    for (int i = 0; i < sectionCount; i++) {
      int item = itemList[i];
      if (index < item) {
        row = index - (i > 0 ? itemList[i - 1] : 0) - 1;
        section = i;
        break;
      }
    }
    return IndexPath(section: section, row: row);
  }
}

class IndexPath {
  IndexPath({this.section, this.row});

  int section = 0;
  int row = 0;
}

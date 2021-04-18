import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../dummy_data/development.dart';
import '../../widget/pluto_example_button.dart';
import '../../widget/pluto_example_screen.dart';

class AddAndRemoveRowsScreen extends StatefulWidget {
  static const routeName = 'add-and-remove-rows';

  @override
  _AddAndRemoveRowsScreenState createState() => _AddAndRemoveRowsScreenState();
}

class _AddAndRemoveRowsScreenState extends State<AddAndRemoveRowsScreen> {
  List<PlutoColumn> columns;

  List<PlutoRow> rows;

  PlutoGridStateManager stateManager;

  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  @override
  void initState() {
    super.initState();

    final dummyData = DummyData(10, 100);

    columns = dummyData.columns;

    rows = [];
  }

  void handleAddRowButton({int count}) {
    final List<PlutoRow> rows = count == null
        ? [DummyData.rowByColumns(columns)]
        : DummyData.rowsByColumns(length: count, columns: columns);

    stateManager.appendRows(rows);
  }

  void handleRemoveCurrentRowButton() {
    stateManager.removeCurrentRow();
  }

  void handleRemoveSelectedRowsButton() {
    stateManager.removeRows(stateManager.currentSelectingRows);
  }

  void handleFiltering() {
    stateManager.setShowColumnFilter(!stateManager.showColumnFilter);
  }

  void setGridSelectingMode(PlutoGridSelectingMode mode) {
    if (gridSelectingMode == mode) {
      return;
    }

    setState(() {
      gridSelectingMode = mode;
      stateManager.setSelectingMode(mode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlutoExampleScreen(
      title: 'Add and Remove Rows',
      topTitle: 'Add and Remove Rows',
      topContents: [
        const Text('You can add or delete rows.'),
        const Text(
            'Remove selected Rows is only deleted if there is a row selected in Row mode.'),
      ],
      topButtons: [
        PlutoExampleButton(
          url:
              'https://github.com/bosskmk/pluto_grid/blob/master/example/lib/screen/feature/add_and_remove_rows_screen.dart',
        ),
      ],
      body: Container(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                    child: const Text('Add a Row'),
                    onPressed: handleAddRowButton,
                  ),
                  ElevatedButton(
                    child: const Text('Add 100 Rows'),
                    onPressed: () => handleAddRowButton(count: 100),
                  ),
                  ElevatedButton(
                    child: const Text('Remove Current Row'),
                    onPressed: handleRemoveCurrentRowButton,
                  ),
                  ElevatedButton(
                    child: const Text('Remove Selected Rows'),
                    onPressed: handleRemoveSelectedRowsButton,
                  ),
                  ElevatedButton(
                    child: const Text('Toggle filtering'),
                    onPressed: handleFiltering,
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton(
                      value: gridSelectingMode,
                      items: PlutoGridStateManager.selectingModes
                          .map<DropdownMenuItem<PlutoGridSelectingMode>>(
                              (PlutoGridSelectingMode item) {
                        final color =
                            gridSelectingMode == item ? Colors.blue : null;

                        return DropdownMenuItem<PlutoGridSelectingMode>(
                          value: item,
                          child: Text(
                            item.toShortString(),
                            style: TextStyle(color: color),
                          ),
                        );
                      }).toList(),
                      onChanged: (PlutoGridSelectingMode mode) {
                        setGridSelectingMode(mode);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PlutoGrid(
                createFooter: (manager) => Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text('Total Bruto', style: TextStyle(fontSize: 13)),
                          ),
                          Text('950,000 COP', style: TextStyle(fontSize: 16)),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text('Descuento', style: TextStyle(fontSize: 13)),
                          ),
                          Text('0 COP', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text('IVA', style: TextStyle(fontSize: 13)),
                            ),
                            Text('50,000 COP', style: TextStyle(fontSize: 16)),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text('Total Neto', style: TextStyle(fontSize: 13)),
                            ),
                            Text('1,000,000 COP', style: TextStyle(fontSize: 16))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                columns: columns,
                rows: rows,
                onChanged: (PlutoGridOnChangedEvent event) {
                  print(event);
                },
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  stateManager = event.stateManager;
                  stateManager.setSelectingMode(gridSelectingMode);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

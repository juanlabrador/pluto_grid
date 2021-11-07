import 'package:pluto_grid/pluto_grid.dart';

/// Occurs when the keyboard hits the end of the grid.
class PlutoGridCannotMoveCurrentCellEvent extends PlutoGridEvent {
  /// The position of the cell when it hits.
  final PlutoGridCellPosition? cellPosition;

  /// The direction to move.
  final PlutoMoveDirection? direction;

  PlutoGridCannotMoveCurrentCellEvent({
    this.cellPosition,
    this.direction,
  }) : super();

  void handler(PlutoGridStateManager? stateManager) {}
}

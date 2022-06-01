class OptionItem {
  final int? sortOrder;
  final String? value;
  final String? display;
  final int? groupSortOrder;
  final String? groupValue;
  final String? groupDisplay;
  final dynamic meta;

  OptionItem(this.value, this.display, {this.sortOrder, this.groupSortOrder, this.groupValue, this.groupDisplay, this.meta });
}
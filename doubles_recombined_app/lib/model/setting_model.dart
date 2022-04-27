class Setting {
  int? id;
  int? count_court;

  Setting({
    this.id,
    this.count_court,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'count_court': count_court,
    };
  }
}

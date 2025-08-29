class Setting {
  final bool isDarkMode;

  Setting({required this.isDarkMode});

  //Olah function agar kita bisa ubah salah satu value nya saja jika ada banyak nilai settings nanti
  Setting copyWith({bool? isDarkMode}) {
    return Setting(isDarkMode: isDarkMode ?? this.isDarkMode);
  }
}

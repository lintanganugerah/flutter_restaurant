class Setting {
  final bool isDarkMode;
  final bool isDailyReminderActive;

  Setting({required this.isDarkMode, required this.isDailyReminderActive});

  //Olah function agar kita bisa ubah salah satu value nya saja jika ada banyak nilai settings nanti
  Setting copyWith({bool? isDarkMode, bool? isDailyReminderActive}) {
    return Setting(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isDailyReminderActive:
          isDailyReminderActive ?? this.isDailyReminderActive,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_flutter/model/services/local_notification_services.dart';

void main() {
  // Inisialisasi binding untuk integration test, ini wajib
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Grup tes untuk service notifikasi
  group('LocalNotificationServices End-to-End Test', () {
    // Kita akan menggunakan instance asli dari service Anda
    late LocalNotificationServices services;

    // `setUpAll` dijalankan sekali sebelum semua tes dalam grup ini dimulai
    setUpAll(() async {
      services = LocalNotificationServices();
      // Inisialisasi service-nya, sama seperti di main.dart
      await services.init();
    });

    testWidgets('harus berhasil menjadwalkan notifikasi harian', (
      tester,
    ) async {
      // Arrange
      // 1. Pastikan tidak ada notifikasi lain yang sedang berjalan untuk memulai tes dari keadaan bersih.
      await services.cancelAllNotifications();

      // 2. Verifikasi bahwa awalnya tidak ada notifikasi
      var initialRequests = await services.getPendingNotificationRequests();
      expect(
        initialRequests.isEmpty,
        isTrue,
        reason: "Harusnya tidak ada notifikasi di awal",
      );

      // Act
      // 3. Panggil metode yang ingin kita uji: menjadwalkan notifikasi untuk jam 11:00.
      await services.scheduleDailyLunchReminder(hour: 11, minute: 0);

      // Assert
      // 4. Ambil kembali daftar notifikasi yang sedang menunggu dari sistem.
      final pendingRequests = await services.getPendingNotificationRequests();

      // 5. Lakukan verifikasi:
      //    - Harus ada tepat satu notifikasi yang dijadwalkan.
      expect(
        pendingRequests.length,
        1,
        reason: "Harus ada 1 notifikasi yang dijadwalkan",
      );
      //    - ID notifikasi tersebut harus 1 (sesuai yang di-hardcode di service Anda).
      expect(pendingRequests.first.id, 1);
      //    - Judulnya harus sesuai.
      expect(pendingRequests.first.title, 'Waktunya Makan Siang!');
    });

    testWidgets('harus berhasil membatalkan notifikasi yang sudah dijadwalkan', (
      tester,
    ) async {
      // Arrange
      // 1. Jadwalkan notifikasi terlebih dahulu untuk memastikan ada yang bisa dibatalkan.
      await services.scheduleDailyLunchReminder(hour: 11, minute: 0);

      // 2. Verifikasi awal bahwa notifikasi memang sudah ada sebelum dibatalkan.
      var pendingRequestsBeforeCancel = await services
          .getPendingNotificationRequests();
      expect(
        pendingRequestsBeforeCancel.length,
        1,
        reason: "Prasyarat: Notifikasi harus ada sebelum dibatalkan",
      );

      // Act
      // 3. Panggil metode untuk membatalkan notifikasi.
      await services.cancelDailyLunchReminder();

      // Assert
      // 4. Ambil kembali daftar notifikasi yang sedang menunggu.
      final pendingRequestsAfterCancel = await services
          .getPendingNotificationRequests();

      // 5. Verifikasi bahwa daftar notifikasi sekarang sudah kosong.
      expect(
        pendingRequestsAfterCancel.isEmpty,
        isTrue,
        reason: "Seharusnya tidak ada notifikasi setelah dibatalkan",
      );
    });
  });
}

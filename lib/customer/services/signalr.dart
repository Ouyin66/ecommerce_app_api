import 'package:signalr_netcore/signalr_client.dart';
import '../../api/api.dart';

class SignalRService {
  final hubConnection = HubConnectionBuilder()
      .withUrl("http://10.0.2.2:5132/notificationHub")
      .build();

  void setupSignalR() {
    hubConnection.on('OrderStatusUpdated', (message) {
      final updatedStatus = message![0];
      print('Order status updated: $updatedStatus');

      // Thực hiện các hành động như cập nhật UI hoặc lưu trạng thái
    });

    hubConnection.start().catchError((err) {
      print('SignalR connection error: $err');
    });
  }

  void dispose() {
    hubConnection.stop();
  }
}

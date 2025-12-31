import 'package:dio/dio.dart';
import 'local_database.dart';
import '../network/network_info.dart';

class OfflineSyncManager {
  final LocalDatabase _localDatabase;
  final NetworkInfo _networkInfo;
  final Dio _dio;

  OfflineSyncManager({
    required LocalDatabase localDatabase,
    required NetworkInfo networkInfo,
    required Dio dio,
  })  : _localDatabase = localDatabase,
        _networkInfo = networkInfo,
        _dio = dio;

  Future<void> addToSyncQueue(
      String action,
      String table,
      Map<String, dynamic> data,
      ) async {
    await _localDatabase.insert('sync_queue', {
      'action': action,
      'tableName': table,
      'data': data.toString(),
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> syncPendingRequests() async {
    final isConnected = await _networkInfo.isConnected;
    if (!isConnected) {
      print('No internet connection. Sync will retry when online.');
      return;
    }

    final pendingRequests = await _localDatabase.queryWhere(
      'sync_queue',
      'status = ?',
      ['pending'],
    );

    for (final request in pendingRequests) {
      try {
        final action = request['action'] as String;
        final table = request['tableName'] as String;

        // Execute sync based on action type
        switch (action) {
          case 'POST':
            await _dio.post('/sync/$table', data: request['data']);
            break;
          case 'PUT':
            await _dio.put('/sync/$table', data: request['data']);
            break;
          case 'DELETE':
            await _dio.delete('/sync/$table', data: request['data']);
            break;
        }

        // Mark as synced
        await _localDatabase.update(
          'sync_queue',
          {'status': 'synced', 'updatedAt': DateTime.now().toIso8601String()},
          'id = ?',
          [request['id']],
        );
      } catch (e) {
        print('Sync error: $e');
      }
    }
  }
}
import 'dart:io';
import '../serialization/request.dart';
import '../tcp/public_handler.dart';

class ServerMaker{
  final int port;
  late ServerSocket server;
  late Future<void> Function(PublicHandler handler) onRequest;
  bool _isOnRequestInitialized = false;

  ServerMaker(this.port);

  void addOnRequest(Future<void> Function(PublicHandler handler) onRequest){
    this.onRequest = onRequest;
    _isOnRequestInitialized = true;
  }

  void run() async {
    server = await ServerSocket.bind(InternetAddress.anyIPv4, port);

    await for (Socket client in server){
      await _handleRequest(client);
    }
  }

  Future<void> _handleRequest(Socket client) async {
    client.listen((data) async {
      HttpRequest request = convert(data);
      
      if(_isOnRequestInitialized){
        PublicHandler handler = PublicHandler(client, request);
        await onRequest(handler);
      }
    });
  }
}
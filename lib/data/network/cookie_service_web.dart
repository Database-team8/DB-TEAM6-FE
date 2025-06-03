import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ajoufinder/domain/interfaces/cookie_service.dart';

class CookieServiceWeb extends CookieService{
  @override
  Future<void> deleteCookie(String name, {String path = '/'}) async {
    if (kIsWeb) {
      String cookieString = '${Uri.encodeComponent(name)}=; Path=$path; Max-Age=0';
      web.window.document.cookie = cookieString;
    }
  }

  @override
  Future<String?> getCookie(String name) async {
    if (kIsWeb) {
      final cookies = web.window.document.cookie;
      
      if (cookies.isNotEmpty) {
        final cookieList = cookies.split(';');
        
        for (var cookie in cookieList) {
          final parts = cookie.split('=');
          final cookieName = parts[0].trim();
          
          if (name == cookieName) {
            return Uri.decodeComponent(parts[1].trim());
          }
        }
      }
    }
    return null; 
  }

  @override
  Future<void> setCookie(String name, String value, {int? maxAgeInSeconds, String path = '/'}) async {
    if (kIsWeb) {
      final cookieParts = [
        '${Uri.encodeComponent(name)}=${Uri.encodeComponent(value)}',
        'Path=$path',
        if (maxAgeInSeconds != null) 'Max-Age=$maxAgeInSeconds',
        'SameSite=Lax',
      ];
      web.window.document.cookie = cookieParts.join('; ');
    }
  }
}
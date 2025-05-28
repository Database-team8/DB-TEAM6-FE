abstract class CookieService {
  Future<String?> getCookie(String name);
  Future<void> setCookie(String name, String value, {int? maxAgeInSeconds, String path = '/'});
  Future<void> deleteCookie(String name, {String path = '/'});
}
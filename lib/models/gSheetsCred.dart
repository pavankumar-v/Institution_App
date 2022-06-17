import 'package:gsheets/gsheets.dart';

class UserSheetsApi {
  UserSheetsApi({required this.spreadsheetId, required this.sheetName});
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "gsheets-352410",
  "private_key_id": "ecea6208e15718d98d20e6b6f0d74e980f7120a8",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCdczOgiodcUJpx\n3KVwnYIczlddJQOltolRHkFIG6XmXQCTld4zOZguFV/N1i6uZo5AcTOgrw8qL9G7\nluffSLI1xqXVQJxLbMEHbi6UeHs/lDEkED6WiY7Td63nIpY+fsC1/XxctCMYOEJL\nuu9VbAy8mEXqZA0HdHjAyyreQnYiTu/BHI+TV5yww7dfqicMduJR9x38xXNZasuL\nk7RrDGnyKyrw3ZOIOOrbWz44fpFOSbTkUIRQhmaQ0vqd0Uzy999Lmsb2HtjQkJge\n2hFuNinXXmJsFBeUdX+kNQHWnhCcYRvnXyWMYhWC0x0Fev6DgKK7kwi5CtBuu8NW\nqCR2s4r9AgMBAAECggEAGmks35DlME/H/HID4V5WaUEWiAYRtM4n/g6qai9TFo+C\nrX798Q9H7vEAa01ycqg60+X5QEqlK1Eup/4iAoMV+63I+vrVzNQfFAFAOID2QZ24\n2YENEqDb7657YhJb6/tElbKB1iYUXfdv7Xabt3NCtq7/SVhDlDzOFZ7u36371Xiv\nZWqU40SBzoxILnzmBekfZj9COU0G8deBrE50t0pMVXkm9vWp4YhdZHpBL0vl/mjW\noI4zcqXXckajLLC7Q+8kTcIsiw57T8+uUCNIFuGfXrfxgdulweqqWSTly2rblvrN\nhLq9Bf1qa4oquQd2xbm8ZdUCTSELbrhCLQsALq+/UQKBgQDJ0PJAzdN11ierRS55\nuPftWzrRxtEPFqyVx/uPrHuDyUlbzu6Og4vFe+6Sa6ZaJAaKLwkVS2XhNDoDQhgH\n2ofnf9+R74kYkdf4jt/SGDKuZ85UNVFGf/x2+O77q4Yt2Go4LxyzvgHTDUOfBwCi\nSjLIAaHxeCODz04rmgeJrmCjDQKBgQDHuOrWcfn7ewgg7WpAlgeEMZKEAUv/XHJ6\n9EFeqMfagQkPkimXFN3jMFume9U72yeKsCL40ZMRTWOfZsOR0oOyupYz7oLtLSJD\nDxfkbmtWHz6Ls1xDijyt7IkWGFr4Puenb0uboVEqeAPo1JAUe9i5QWeN+qrqJb+9\nd2cQHxZLsQKBgQCQWEwMoapvC58P1slo8i0RrUCircr1Ochy0LhSiJFHLv6zFYx2\njgu4Ue3O+APhUQcEaqPagTT7IDml/u3lIB44K7OiU2sBEb8g3j+jqv8E0uY2QHRD\nMmNGTMHRa1rrC3DdgoTK4km3xDLrWTzQ1rT/bHuBk+YC7pEAioh9pyUjOQKBgHIx\n6RR0VtrTnfI1zWrgXavYLE4N78YytcJXpojZOGxXGzcr+1vHMpeULtMiOunehN1n\nmJdsPQrHlQ6vU2MtWt/2j6th1LqH8+8j0iVqfTTg6II4K6jygX9wn3Fiu6D1Vr8F\ng9WYhzAhLxsRbtBHf8NtAijMCq2Wp+tNOkCdhcIBAoGAYtiIRs3BJE0ygFIMKobk\n72QdWMroxJ4ptxUhLds+hOFH5o+LhMq6IyulXoandIcuA6tdyEfHAR+Xxjt7pNha\nKfwJnJcBPGq61EycKb4brGGC7Bfq6PdN4xVTWt9uAU0KXh0Cakq3XbCld9zN0mbh\nhk2cSZQqBC5EZuZ49UkbbBU=\n-----END PRIVATE KEY-----\n",
  "client_email": "gsheets@gsheets-352410.iam.gserviceaccount.com",
  "client_id": "117298829021372546005",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/gsheets%40gsheets-352410.iam.gserviceaccount.com"
}

''';
  String spreadsheetId;
  String sheetName;
  // final _spreadsheetId = '1Y_20nATHMm4Ig4p-hQHn1qBbeWBn5g5A5UMELvAqGbI';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _userSheet;

  Future init() async {
    try {
      final spreadsheet = await _gsheets.spreadsheet(spreadsheetId);
      _userSheet = await _getWorkSheet(spreadsheet, title: sheetName);
      return true;
      // final firstRow = ['id', 'name', 'email', 'isBegginner'];
      // _userSheet!.values.insertRow(1, firstRow);
    } catch (e) {
      print('init error: $e');
      return null;
    }
  }

  Future<Worksheet?> _getWorkSheet(Spreadsheet spreadsheet,
      {required String title}) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title);
    }
  }

  Future insert(Map<String, dynamic> rowList) async {
    try {
      if (_userSheet == null) return;
      _userSheet!.values.map.appendRow(rowList);
      return true;
    } catch (e) {
      print('insert Error $e');
      return null;
    }
  }
}

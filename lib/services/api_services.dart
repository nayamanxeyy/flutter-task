import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/college.dart';


class ApiService {
static const String baseUrl = 'https://admin.collegesinnepal.com/api/colleges/';


final http.Client client;


ApiService({http.Client? client}) : client = client ?? http.Client();


Future<Map<String, dynamic>> fetchColleges({int page = 1, String? search}) async {
final uri = Uri.parse(baseUrl).replace(queryParameters: {
'page': page.toString(),
if (search != null && search.isNotEmpty) 'search': search,
});


final response = await client.get(uri, headers: {
'Accept': 'application/json',
});


if (response.statusCode == 200) {
final Map<String, dynamic> jsonBody = json.decode(response.body);
final List<dynamic> results = jsonBody['results'] ?? [];
final colleges = results.map((e) => College.fromJson(e)).toList();
return {
'count': jsonBody['count'],
'next': jsonBody['next'],
'previous': jsonBody['previous'],
'results': colleges,
};
} else {
throw Exception('Failed to load colleges: ${response.statusCode}');
}
}
}
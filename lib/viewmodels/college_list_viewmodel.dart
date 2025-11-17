import 'package:flutter/material.dart';
import 'package:projectdemo/models/college.dart';
import 'package:projectdemo/services/api_services.dart';


enum ViewState { idle, busy, error }


class CollegeListViewModel extends ChangeNotifier {
final ApiService apiService;


CollegeListViewModel({required this.apiService});


List<College> colleges = [];
ViewState state = ViewState.idle;
String? errorMessage;
int currentPage = 1;
int totalCount = 0;
bool hasMore = true;
String _search = '';


String get search => _search;


set search(String value) {
_search = value;
// reset when search changed
resetAndFetch();
}


Future<void> resetAndFetch() async {
currentPage = 1;
colleges = [];
hasMore = true;
notifyListeners();
await fetchColleges();
}


Future<void> fetchColleges() async {
if (!hasMore) return;
state = ViewState.busy;
notifyListeners();


try {
final data = await apiService.fetchColleges(page: currentPage, search: _search);
final List<College> fetched = List<College>.from(data['results']);


if (currentPage == 1) {
colleges = fetched;
} else {
colleges.addAll(fetched);
}


totalCount = data['count'] ?? totalCount;
hasMore = data['next'] != null;
errorMessage = null;
state = ViewState.idle;
currentPage += 1;
notifyListeners();
} catch (e) {
errorMessage = e.toString();
state = ViewState.error;
notifyListeners();
}
}
}
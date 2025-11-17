// lib/views/college_list_view.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/college_list_viewmodel.dart';
import '../widgets/college_card.dart';

class CollegeListView extends StatefulWidget {
  const CollegeListView({super.key});

  @override
  State<CollegeListView> createState() => _CollegeListViewState();
}

class _CollegeListViewState extends State<CollegeListView> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();

    // load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<CollegeListViewModel>(context, listen: false);
      if (vm.colleges.isEmpty) vm.fetchColleges();
    });

    _scrollController.addListener(() {
      final vm = Provider.of<CollegeListViewModel>(context, listen: false);
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          vm.state != ViewState.busy &&
          vm.hasMore) {
        vm.fetchColleges();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  int _columnsForWidth(double width) {
    if (width > 1000) return 4;
    if (width > 700) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Colleges in Nepal'),
        centerTitle: false,
        elevation: 1,
      ),
      body: Consumer<CollegeListViewModel>(
        builder: (context, vm, _) {
          // loading state when nothing loaded yet
          if (vm.state == ViewState.busy && vm.colleges.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // error state when nothing loaded
          if (vm.state == ViewState.error && (vm.colleges.isEmpty)) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(vm.errorMessage ?? 'Something went wrong', textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => vm.fetchColleges(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          final colleges = vm.colleges;

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Search colleges...',
                          prefixIcon: const Icon(Icons.search),
                          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onSubmitted: (val) {
                          vm.search = val.trim();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        vm.search = _searchController.text.trim();
                      },
                      child: const Text('Go'),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await vm.resetAndFetch();
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _columnsForWidth(MediaQuery.of(context).size.width),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: colleges.length + (vm.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      // loader at the end for pagination
                      if (index >= colleges.length) {
                        if (vm.state == ViewState.busy) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (vm.state == ViewState.error) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(vm.errorMessage ?? 'Failed to load more'),
                                const SizedBox(height: 8),
                                OutlinedButton(
                                  onPressed: () => vm.fetchColleges(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }

                      final college = colleges[index];
                      return CollegeCard(
                        college: college,
                        // If your CollegeCard accepts onTap, pass a callback to open detail page.
                        onTap: () => {},
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import '../models/college.dart';


class CollegeDetailView extends StatelessWidget {
final College college;


const CollegeDetailView({super.key, required this.college});


@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(title: Text(college.name)),
body: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
if (college.coverPhoto != null)
CachedNetworkImage(
imageUrl: college.coverPhoto!,
height: 220,
fit: BoxFit.cover,
placeholder: (c, u) => SizedBox(height: 220, child: Center(child: CircularProgressIndicator())),
errorWidget: (c, u, e) => SizedBox(height: 220, child: Center(child: Icon(Icons.broken_image, size: 48))),
),
Padding(
padding: const EdgeInsets.all(16.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(college.name, style: Theme.of(context).textTheme.titleLarge),
SizedBox(height: 8),
Text(college.affiliatedTo ?? '', style: Theme.of(context).textTheme.titleSmall),
SizedBox(height: 12),
Text('UGC Accredited: ${college.isUgcAccredited ? 'Yes' : 'No'}'),
SizedBox(height: 16),
if (college.shortDescription != null) Html(data: college.shortDescription!),
],
),
)
],
),
),
);
}
}
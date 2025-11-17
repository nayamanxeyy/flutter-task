import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:projectdemo/widgets/html_parser.dart';
import '../models/college.dart';


class CollegeCard extends StatelessWidget {
final College college;
final VoidCallback onTap;


const CollegeCard({super.key, required this.college, required this.onTap});


@override
Widget build(BuildContext context) {
return InkWell(
onTap: onTap,
child: Card(
elevation: 6,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
child: Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children: [
Expanded(
child: ClipRRect(
borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
child: college.coverPhoto != null
? CachedNetworkImage(
imageUrl: college.coverPhoto!,
fit: BoxFit.cover,
placeholder: (c, url) => Center(child: CircularProgressIndicator()),
errorWidget: (c, url, err) => Center(child: Icon(Icons.broken_image)),
)
: Container(color: Colors.grey.shade200, child: Icon(Icons.school, size: 48)),
),
),
Padding(
padding: const EdgeInsets.all(8.0),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(college.name, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
SizedBox(height: 6),
Text(college.affiliatedTo ?? '', style: Theme.of(context).textTheme.bodySmall),
SizedBox(height: 8),
Text(
parseHtmlString(college.shortDescription).trim(),
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: TextStyle(fontSize: 12),
),
],
),
)
],
),
),
);
}
}
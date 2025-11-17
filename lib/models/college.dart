class College {
final int id;
final String name;
final String slug;
final String? affiliatedTo;
final String? coverPhoto;
final String? logo;
final String? shortDescription;
final bool isUgcAccredited;


College({
required this.id,
required this.name,
required this.slug,
this.affiliatedTo,
this.coverPhoto,
this.logo,
this.shortDescription,
required this.isUgcAccredited,
});


factory College.fromJson(Map<String, dynamic> json) {
return College(
id: json['id'] as int,
name: json['name'] as String,
slug: json['slug'] as String,
affiliatedTo: json['affiliated_to_name'] as String?,
coverPhoto: json['cover_photo'] as String?,
logo: json['logo'] as String?,
shortDescription: json['short_description'] as String?,
isUgcAccredited: json['is_ugc_accredited'] == true,
);
}
}
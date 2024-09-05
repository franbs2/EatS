import 'package:cloud_firestore/cloud_firestore.dart';


class Banners {
  final String title;
  final String image;
  final String description;
  final List<String> content;
  final DateTime startDate;
  final DateTime endDate;

  Banners({
    required this.title,
    required this.image,
    required this.description,
    required this.content,
    required this.startDate,
    required this.endDate,
  });

  factory Banners.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Banners(
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      description: data['description'] ?? '',
      content: List<String>.from(data['content']),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
    );
  }
}

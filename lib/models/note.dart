import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String? id;
  final String headLine;
  final String description;
  final Timestamp createdAt;
  Note({
    this.id,
    required this.headLine,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson(){
    return{
      'id': id,
      'headLine': headLine,
      'description': description,
      'createdAt': createdAt,
    };
  }
 factory Note.fromJson (Map<String, dynamic> json){
    return Note(
      id: json['id'] ?? 0,
      headLine: json['headLine'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? Timestamp.now(),
    );
 }
}


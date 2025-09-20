import 'package:flutter/material.dart';
import '../../core/app_colors/app_colors.dart';

class CreateNotePage extends StatelessWidget {
  CreateNotePage({super.key});

  final TextEditingController headlineController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.only(top: 80, left: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Center(
              child: Text(
                "Create New Note",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Headline Label
            Text(
              "Head line",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),

            // Headline Input
            TextField(
              controller: headlineController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter Note Address",
                hintStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                fillColor: AppColors.secondaryColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Description Label
            Text(
              "Description",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),

            // Description Input (multiline)
            TextField(
              controller: descriptionController,
              style: TextStyle(color: Colors.white),
              //------------maxLines property added------------
              maxLines: 6,
              decoration: InputDecoration(
                hintText: "Enter Your Description",
                hintStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                fillColor: AppColors.secondaryColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),

            // Select Media Button
            ElevatedButton(
              onPressed: () {
                // TODO: Implement select media logic
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text("Select Media"),
            ),
            const SizedBox(height: 12),

            // Create Button
            ElevatedButton(
              onPressed: () {
                final title = headlineController.text.trim();
                final desc = descriptionController.text.trim();

                if (title.isEmpty || desc.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all fields")),
                  );
                } else {
                  // TODO: Implement create note logic
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 48),
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: Text("Create"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

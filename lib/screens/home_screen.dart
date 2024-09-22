import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:review_my_answers/constants/colors.dart';
import 'package:review_my_answers/screens/review_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isImageSelected = false;
  final ImagePicker _picker = ImagePicker();
  late XFile? pickedFile;

  final reviewTopicController = TextEditingController();

  @override
  void dispose() {
    reviewTopicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: InkWell(
        onTap: () async {
          try {
            pickedFile = await _picker.pickImage(
              source: ImageSource.gallery,
            );
            setState(
              () {
                isImageSelected = true;
              },
            );
          } catch (e) {
            log("Failed to load image! Error: $e");
          }
        },
        child: (isImageSelected && pickedFile != null)
            ? ListView(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kWhite),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          File(pickedFile!.path),
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                            return const Center(
                              child: Text('This image type is not supported'),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: TextField(
                      style: const TextStyle(
                        color: kWhite,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        hintText: 'Enter the topic of review',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ReviewScreen(
                                pickedFile: pickedFile!,
                                reviewTopic: reviewTopicController.text),
                          ),
                        );
                      },
                      child: const Text("Review my answer"),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )
            : Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: kWhite),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Icon(
                    Icons.add,
                    size: 20,
                    color: kWhite,
                  ),
                ),
              ),
      ),
    );
  }
}

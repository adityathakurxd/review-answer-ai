import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';
import 'package:review_my_answers/constants/colors.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    required this.pickedFile,
    required this.reviewTopic,
  });

  final XFile pickedFile;
  final String reviewTopic;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool isLoading = true;

  String extractedText = "";
  List<String> pointsToImprove = [];

  @override
  void initState() {
    reviewAnswer();
    super.initState();
  }

  reviewAnswer() async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: "<YOUR API KEY HERE>",
    );

    final prompt = TextPart(
        'Act as a teacher and review the work by a student in the attached image. Your task is to review the image for the topic ${widget.reviewTopic} and provide points of improvement and send it back as JSON with the format as {"review": { "text": "extracted text from the image here", "points": ["point 1", "point 2", "point 3"]}}. IMPORTANT Do not add "```json" to it');

    final pickedImage = await widget.pickedFile.readAsBytes();

    final imagePart = [
      DataPart(widget.pickedFile.mimeType ?? "image/jpeg", pickedImage),
    ];

    final response = await model.generateContent([
      Content.multi([prompt, ...imagePart])
    ]);

    if (response.text != null) {
      print(response.text);

      var parsedJson = jsonDecode(response.text!);

      extractedText = parsedJson['review']['text'];
      pointsToImprove = List<String>.from(parsedJson['review']['points']);

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        title: const Text("Review My Answer AI"),
      ),
      body: (isLoading)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: kBlack),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        extractedText,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Points to improve on:",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: kWhite),
                  ),
                ),
                for (int i = 0; i < pointsToImprove.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: kWhite,
                        border: Border.all(color: Colors.green, width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          pointsToImprove[i],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/data_bank.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';
// Import Appwrite packages
import 'package:appwrite/appwrite.dart';
import 'package:news_now/src/uitils/server/appwrite.dart';
import 'package:provider/provider.dart';

class SubmitScreen extends StatefulWidget {
  const SubmitScreen({super.key});

  static const routeName = '/submit';

  @override
  State<SubmitScreen> createState() => _SubmitScreenState();
}

class _SubmitScreenState extends State<SubmitScreen> {
  final _submitArticleScreenKey = GlobalKey<FormState>();
  String errorMessage = '';
  double progress = 20;
  bool isUploading = false;
  String profilePictureUploadStatus = "";
  Image? altImageWidget;
  io.File? systemImageFile;
  String? rawProfilePictureUrl;

  String? articleTitle;
  String? articleDescription;

  Future<void> saveForm(UserInformation userInformation) async {
    if (_submitArticleScreenKey.currentState!.validate() &&
        altImageWidget != null) {
      _submitArticleScreenKey.currentState!.save();

      try {
        final uniqueId = ID.unique();
        if (systemImageFile != null) {
          await uploadFile(systemImageFile as io.File, uniqueId);
        }

        // Create document in Appwrite database
        await database.createDocument(
          databaseId: APPWRITE_DATABASE_ID,
          collectionId: APPWRITE_COLLECTION_ID_submissions,
          documentId: uniqueId,
          data: {
            "discription": articleDescription,
            "title": articleTitle,
            "newsImageURL": rawProfilePictureUrl,
            "users": userInformation.userId,
          },
        );
      } catch (e) {
        setState(() {
          errorMessage = "Error: ${e.toString()}";
        });
      }
    }
  }

  Future<void> uploadFile(io.File file, String articleId) async {
    profilePictureUploadStatus = "";

    try {
      setState(() {
        isUploading = true;
        progress = 0;
      });

      // Upload file to Appwrite storage
      final uploadedFile = await storage.createFile(
        bucketId: APPWRITE_BUCKET_ID_articles_image,
        fileId: "article_image_$articleId",
        file: InputFile.fromPath(
          path: file.path,
          filename: 'article_image_$articleId.jpg',
        ),
        onProgress: (uploaded) {
          setState(() {
            progress = uploaded.progress * 100;
            profilePictureUploadStatus = "Upload in progress...";
          });
        },
      );

      final fileUrl =
          "https://cloud.appwrite.io/v1/storage/buckets/$APPWRITE_BUCKET_ID_articles_image/files/${uploadedFile.$id}/view?project=67bc8d29001459bf1e41";

      setState(() {
        rawProfilePictureUrl = fileUrl;
        isUploading = false;
        profilePictureUploadStatus = "Upload is 100% complete.";
        altImageWidget = null;
        _submitArticleScreenKey.currentState!.reset();
      });
    } catch (e) {
      setState(() {
        isUploading = false;
        errorMessage = "Upload failed: ${e.toString()}";
        profilePictureUploadStatus = "Upload failed.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 100,
        ),
        child: Form(
          key: _submitArticleScreenKey,
          child: SizedBox(
            height: height * 0.88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Submit Article",
                  style: TextStyle(
                      fontSize: 20, color: AppColors.textPrimaryColor),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Note: Provide authentic and correct information if there is any Abusive or Misleading Information, Bad or Hate Speech, etc then article will be rejected and action will be taken accordingly!",
                  style: TextStyle(color: Colors.red, fontFamily: "Roboto"),
                ),
                const SizedBox(height: 20),
                textInputField(1),
                const SizedBox(height: 20),
                customUpoadButton(),
                if (profilePictureUploadStatus.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Text(
                      profilePictureUploadStatus,
                      style: const TextStyle(
                        color: AppColors.accentColor,
                      ),
                    ),
                  ),
                if (isUploading)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 20,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            LinearProgressIndicator(
                              value: progress,
                              backgroundColor: AppColors.secondaryColor,
                              color: AppColors.accentColor,
                            ),
                            Center(
                              child: Text(
                                "${(100 * progress).roundToDouble()}%",
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 20),
                postArticleButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column textInputField(double inputWidth) {
    return Column(
      children: [
        SizedBox(
          width: inputWidth.sw,
          child: customeFormField(
            "",
            const Icon(
              Icons.card_giftcard,
              color: Colors.white,
            ),
            "Article Title",
            validator: (value) {
              if (value == null) {
                return 'Please Enter Article Title.';
              }
              if (value.isEmpty) {
                return 'Please Enter Article Title.';
              }
              return null;
            },
            onSaved: (value) {
              articleTitle = value;
            },
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        SizedBox(
          width: inputWidth.sw,
          child: TextFormField(
            cursorColor: Colors.blueAccent,
            style: const TextStyle(color: Colors.white),
            maxLines: 10,
            decoration: InputDecoration(
              counterStyle: const TextStyle(
                color: Color.fromARGB(255, 194, 187, 187),
              ),
              labelText: "Article Description",
              alignLabelWithHint: true,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              labelStyle: const TextStyle(
                color: Color.fromARGB(255, 194, 187, 187),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 58, 53, 53),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null) {
                return 'Please Enter Article Description.';
              }
              if (value.isEmpty) {
                return 'Please Enter Article Description.';
              }
              return null;
            },
            onSaved: (value) {
              articleDescription = value;
            },
          ),
        ),
      ],
    );
  }

  Expanded customUpoadButton() {
    return altImageWidget == null
        ? Expanded(
            child: ElevatedButton(
              onPressed: () async {
                final XFile? image = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                  maxHeight: 400,
                  maxWidth: 400,
                  imageQuality: 50,
                );
                if (image != null) {
                  systemImageFile = io.File(image.path);
                  altImageWidget = Image.memory(
                    await image.readAsBytes(),
                  );
                  setState(() {});
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(AppColors.secondaryColor),
                padding: WidgetStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                ),
                shape: WidgetStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                )),
              ),
              child: const Text(
                "Upload Image",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          )
        : Expanded(
            child: Container(
              child: altImageWidget!,
            ),
          );
  }

  Expanded postArticleButton() {
    return Expanded(
      child: ElevatedButton(
        onPressed: isUploading
            ? null
            : () async {
                await saveForm(Provider.of<DataBank>(
                  context,
                  listen: false,
                ).userInformation);
              },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(AppColors.accentColor),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          ),
          shape: WidgetStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          )),
        ),
        child: isUploading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Text(
                "Submit Articles",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }

  Widget customeFormField(String? initvalue, Widget? icon, String hint,
      {void Function(String?)? onSaved,
      String? Function(String?)? validator,
      void Function(String)? onChanged}) {
    return TextFormField(
      cursorColor: Colors.blueAccent,
      style: const TextStyle(color: Colors.white),
      initialValue: initvalue,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        prefixIcon: icon,
        labelText: hint,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 194, 187, 187)),
        filled: true,
        fillColor: const Color.fromARGB(255, 58, 53, 53),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(15)),
      ),
      validator: validator,
      onSaved: onSaved,
      onChanged: onChanged,
    );
  }

  Widget titleText(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: "Roboto",
      ),
    );
  }
}

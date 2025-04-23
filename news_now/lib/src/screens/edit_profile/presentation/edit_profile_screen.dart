import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appwrite/appwrite.dart';

import 'package:news_now/custome_icons_icons.dart';
import 'package:news_now/src/package_service/locator_service.dart';
import 'package:news_now/src/repository/auth_repo.dart';
import 'package:news_now/src/uitils/server/appwrite.dart';
import 'package:news_now/src/constants/app_colors.dart';
import 'package:news_now/src/screens/profile/data/user_information.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  static const routeName = '/edit-profile';

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _personalDataSetKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String errorMessage = '';
  double progress = 0;
  bool isUploading = false;
  String profilePictureUploadStatus = "";
  ImageProvider? altImageWidget;
  String? rawProfilePictureUrl;

  String? userName;
  String? fullName;
  String? emailId;
  DateTime? joined;
  String? profilePicture;
  String? biography;
  String? companyName;
  String? jobTitle;
  String? githubUsername;
  String? linkedin;
  String? twitter;
  String? instagram;
  String? facebook;
  String? websiteURL;

  @override
  Widget build(BuildContext context) {
    UserInformation? userInformation =
        ModalRoute.of(context)!.settings.arguments as UserInformation;

    userName = userInformation.userName;
    fullName = userInformation.fullName;
    emailId = userInformation.emailId;
    joined = userInformation.joined;
    profilePicture = userInformation.profilePicture;
    biography = userInformation.biography;
    companyName = userInformation.companyName;
    jobTitle = userInformation.jobTitle;
    githubUsername = userInformation.githubUsername;
    linkedin = userInformation.linkedin;
    twitter = userInformation.twitter;
    instagram = userInformation.instagram;
    facebook = userInformation.facebook;
    websiteURL = userInformation.websiteURL;

    void saveData() async {
      final isValid = _personalDataSetKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      _personalDataSetKey.currentState!.save();
      setState(() {
        _isLoading = true;
        errorMessage = '';
      });
      try {
        FocusManager.instance.primaryFocus?.unfocus();

        Map<String, dynamic> updateData = {
          "userName": userName ?? userInformation.userName,
          "emailId": userInformation.emailId,
          "fullName": fullName ?? userInformation.userName,
          "profilePicture": rawProfilePictureUrl ?? profilePicture,
        };

        // Add optional fields only if they have a value
        if (biography != null && biography!.isNotEmpty) {
          updateData["biography"] = biography;
        }
        if (companyName != null && companyName!.isNotEmpty) {
          updateData["companyName"] = companyName;
        }
        if (jobTitle != null && jobTitle!.isNotEmpty) {
          updateData["jobTitle"] = jobTitle;
        }
        if (githubUsername != null && githubUsername!.isNotEmpty) {
          updateData["githubUsername"] = githubUsername;
        }
        if (linkedin != null && linkedin!.isNotEmpty) {
          updateData["linkedin"] = linkedin;
        }
        if (twitter != null && twitter!.isNotEmpty) {
          updateData["twitter"] = twitter;
        }
        if (instagram != null && instagram!.isNotEmpty) {
          updateData["instagram"] = instagram;
        }
        if (facebook != null && facebook!.isNotEmpty) {
          updateData["facebook"] = facebook;
        }
        if (websiteURL != null && websiteURL!.isNotEmpty) {
          updateData["websiteURL"] = websiteURL;
        }

        // Update user document in Appwrite database
        await database.updateDocument(
          databaseId: APPWRITE_DATABASE_ID,
          collectionId: APPWRITE_COLLECTION_ID_user,
          documentId: userInformation.userId!,
          data: updateData,
        );

        // Update name in Appwrite account if needed
        if (fullName != null && fullName != userInformation.fullName) {
          await account.updateName(name: fullName!);
        }
      } catch (error) {
        setState(() {
          errorMessage = "Update failed: ${error.toString()}";
          _isLoading = false;
        });
        if (kDebugMode) {
          print("Error updating profile: $error");
        }
      } finally {
        await locator.get<AuthRepo>().getUserInformation(context);
        Navigator.of(context).pop();
      }
    }

    Future<void> uploadFile(io.File file) async {
      setState(() {
        profilePictureUploadStatus = "";
        isUploading = true;
      });

      try {
        final String fileName = '${userInformation.userId}_profile.jpg';

        // Create input file for upload
        final InputFile inputFile = InputFile.fromPath(
          path: file.path,
          filename: fileName,
        );

        if (userInformation.profilePictureID != null) {
          await storage.deleteFile(
            bucketId: APPWRITE_BUCKET_ID_profile_picture,
            fileId: userInformation.profilePictureID!,
          );
        }

        // Upload file to Appwrite Storage
        final uploadResult = await storage.createFile(
          bucketId: APPWRITE_BUCKET_ID_profile_picture,
          fileId: ID.unique(),
          file: inputFile,
          onProgress: (progress) {
            setState(() {
              this.progress = progress.progress;
            });
          },
        );

        // Get file URL
        final fileUrl = uploadResult.$id;

        // Update user document with new profile picture URL
        await database.updateDocument(
          databaseId: APPWRITE_DATABASE_ID,
          collectionId: APPWRITE_COLLECTION_ID_user,
          documentId: userInformation.userId!,
          data: {
            "profilePicture":
                "https://cloud.appwrite.io/v1/storage/buckets/67c2e8540007bfbeff3d/files/$fileUrl/view?project=67bc8d29001459bf1e41",
          },
        );

        // Update user account prefs to store profile picture URL
        await account.updatePrefs(prefs: {
          'profilePicture':
              "https://cloud.appwrite.io/v1/storage/buckets/67c2e8540007bfbeff3d/files/$fileUrl/view?project=67bc8d29001459bf1e41",
        });

        // Update local state
        setState(() {
          rawProfilePictureUrl =
              "https://cloud.appwrite.io/v1/storage/buckets/67c2e8540007bfbeff3d/files/$fileUrl/view?project=67bc8d29001459bf1e41";
          isUploading = false;
          profilePictureUploadStatus = "Upload is 100% complete.";
        });

        // Refresh user data
        await locator.get<AuthRepo>().getUserInformation(context);
      } catch (e) {
        setState(() {
          isUploading = false;
          errorMessage = "Failed to upload: ${e.toString()}";
        });
      }
    }

    Widget customeFormField(String? initvalue, Widget? icon, String hint,
        {void Function(String?)? onSaved,
        String? Function(String?)? validator,
        void Function(String)? onChanged}) {
      return TextFormField(
        cursorColor: AppColors.textPrimaryColor,
        style: const TextStyle(color: AppColors.textPrimaryColor),
        initialValue: initvalue,
        decoration: InputDecoration(
          prefixIcon: icon,
          labelText: hint,
          labelStyle: const TextStyle(color: AppColors.textPrimaryColor),
          filled: true,
          fillColor: AppColors.secondaryColor,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15)),
        ),
        validator: validator,
        onSaved: onSaved,
        onChanged: onChanged,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Account Details",
          style: TextStyle(fontFamily: "Roboto"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 30,
            top: 25,
            bottom: 30,
          ),
          child: Form(
            key: _personalDataSetKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleText("Profile Picture"),
                const SizedBox(
                  height: 3,
                ),
                const Text(
                  "Upload a picture to make your profile stand out and let people recognize your comments and cotributions easily!",
                  style: TextStyle(
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                InkWell(
                  onTap: () async {
                    final XFile? image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 10,
                    );
                    if (image != null) {
                      setState(() {
                        altImageWidget = FileImage(
                          io.File(image.path),
                        );
                      });
                      await uploadFile(io.File(image.path));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: userInformation.userId == "default" ||
                            userInformation.profilePicture == null ||
                            userInformation.profilePicture!.isEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              fit: BoxFit.cover,
                              height: 80,
                              width: 80,
                              image: altImageWidget ??
                                  const AssetImage(
                                      "assets/images/profilePlaceholder.jpeg"),
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image(
                              fit: BoxFit.cover,
                              height: 80,
                              width: 80,
                              image: NetworkImage(
                                rawProfilePictureUrl ?? profilePicture!,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (profilePictureUploadStatus.isNotEmpty)
                  Text(
                    profilePictureUploadStatus,
                    style: const TextStyle(
                      color: AppColors.textSecondaryColor,
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (isUploading)
                  ClipRRect(
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
                const SizedBox(
                  height: 25,
                ),
                titleText("Account Information"),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customeFormField(
                        userInformation.fullName,
                        const Icon(
                          CustomeIcons.person,
                          color: AppColors.textPrimaryColor,
                        ),
                        "Full Name", validator: (value) {
                      if (value == null) {
                        return 'Please Enter Full Name.';
                      }
                      if (value.isEmpty) {
                        return 'Please Enter Full Name.';
                      }
                      return null;
                    }, onSaved: (value) async {
                      fullName = value;
                    }),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.userName,
                      const Icon(
                        CustomeIcons.at,
                        color: AppColors.textPrimaryColor,
                      ),
                      "Username",
                      validator: (value) {
                        if (value == null) {
                          return 'Please Enter Username.';
                        }
                        if (value.isEmpty || value == "") {
                          return 'Please Enter Username.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        userName = value;
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    titleText("About"),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      cursorColor: AppColors.textPrimaryColor,
                      style: const TextStyle(color: AppColors.textPrimaryColor),
                      initialValue: biography,
                      maxLines: 6,
                      maxLength: 100,
                      decoration: InputDecoration(
                        counterStyle: TextStyle(
                          color: AppColors.textPrimaryColor,
                        ),
                        labelText: "Bio",
                        alignLabelWithHint: true,
                        floatingLabelAlignment: FloatingLabelAlignment.start,
                        labelStyle: TextStyle(
                          color: AppColors.textPrimaryColor,
                        ),
                        filled: true,
                        fillColor: AppColors.secondaryColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onSaved: (value) {
                        if (value != null) {
                          biography = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.companyName,
                      null,
                      "Company",
                      onSaved: (value) {
                        if (value != null) {
                          companyName = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.jobTitle,
                      null,
                      "Job Title",
                      onSaved: (value) {
                        if (value != null) {
                          jobTitle = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    titleText("Profile Social Links"),
                    const SizedBox(
                      height: 3,
                    ),
                    const Text(
                      "Add your social media profiles so others can connect with you and you can grow your network!",
                      style: TextStyle(
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    customeFormField(
                      userInformation.githubUsername,
                      const Icon(
                        CustomeIcons.github_circled_alt2,
                        color: AppColors.textPrimaryColor,
                      ),
                      "GitHub",
                      onSaved: (value) {
                        if (value != null) {
                          githubUsername = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.linkedin,
                      const Icon(
                        CustomeIcons.linkedin_1,
                        color: AppColors.textPrimaryColor,
                      ),
                      "Linkedin",
                      onSaved: (value) {
                        if (value != null) {
                          linkedin = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.twitter,
                      const Icon(
                        CustomeIcons.twitter,
                        color: AppColors.textPrimaryColor,
                      ),
                      "Twitter",
                      onSaved: (value) {
                        if (value != null) {
                          twitter = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.instagram,
                      const Icon(
                        CustomeIcons.instagram,
                        color: AppColors.textPrimaryColor,
                      ),
                      "Instagram",
                      onSaved: (value) {
                        if (value != null) {
                          instagram = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.facebook,
                      const Icon(
                        color: AppColors.textPrimaryColor,
                        CustomeIcons.facebook,
                      ),
                      "Facebook",
                      onSaved: (value) {
                        if (value != null) {
                          facebook = value;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customeFormField(
                      userInformation.websiteURL,
                      const Icon(
                        CustomeIcons.link,
                        color: AppColors.textPrimaryColor,
                      ),
                      "Your Website",
                      onSaved: (value) {
                        if (value != null) {
                          websiteURL = value;
                        }
                      },
                    ),
                    if (errorMessage.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 3,
                          ),
                        ),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 40,
                    ),
                    _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.accentColor,
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: saveData,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                    AppColors.accentColor),
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 30),
                                ),
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                )),
                              ),
                              child: const Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleText(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimaryColor,
        fontSize: 20,
        fontFamily: "Roboto",
      ),
    );
  }
}

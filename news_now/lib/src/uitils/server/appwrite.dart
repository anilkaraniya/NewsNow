// ignore_for_file: constant_identifier_names
import 'package:appwrite/appwrite.dart';

const APPWRITE_ENDPOINT = "https://cloud.appwrite.io/v1";
const APPWRITE_PROJECT_ID = "67bc8d29001459bf1e41";
const APPWRITE_DATABASE_ID = "67bc8d7700376bb5f31e";

const APPWRITE_COLLECTION_ID_articles = "67bc8e0c0003c239f998";
const APPWRITE_COLLECTION_ID_submissions = "67bc8e310011b7f3b3fe";
const APPWRITE_COLLECTION_ID_comments = "67bc8e140030afda3563";
const APPWRITE_COLLECTION_ID_user = "67bc8e2400047982d509";
const APPWRITE_COLLECTION_ID_upVoted = "67bd80df0000278ca039";

const APPWRITE_BUCKET_ID_profile_picture = "67c2e8540007bfbeff3d";
const APPWRITE_BUCKET_ID_articles_image = "67c2ee4b003b7305d9ee";

Client client =
    Client().setEndpoint(APPWRITE_ENDPOINT).setProject(APPWRITE_PROJECT_ID);

Databases database = Databases(client);
Account account = Account(client);
Storage storage = Storage(client);

import {
  Client,
  Account,
  Databases,
  Storage,
  type Models,
  ID,
  Query,
} from "appwrite";

export const APPWRITE_ENDPOINT = "https://cloud.appwrite.io/v1";
export const APPWRITE_PROJECT_ID = "67bc8d29001459bf1e41";
export const APPWRITE_DATABASE_ID = "67bc8d7700376bb5f31e";

export const APPWRITE_COLLECTION_ID_ARTICLES = "67bc8e0c0003c239f998";
export const APPWRITE_COLLECTION_ID_SUBMISSIONS = "67bc8e310011b7f3b3fe";
export const APPWRITE_COLLECTION_ID_COMMENTS = "67bc8e140030afda3563";
export const APPWRITE_COLLECTION_ID_USER = "67bc8e2400047982d509";
export const APPWRITE_COLLECTION_ID_UPVOTED = "67bd80df0000278ca039";

export const APPWRITE_BUCKET_ID_PROFILE_PICTURE = "67c2e8540007bfbeff3d";
export const APPWRITE_BUCKET_ID_ARTICLES_IMAGE = "67c2ee4b003b7305d9ee";

// Interfaces for type safety
export interface UserInformation extends Models.Document {
  name?: string;
  email?: string;
}

export interface ArticleBase {
  title?: string;
  newsImageURL?: string;
  discription?: string;
  user?: UserInformation;
}

export interface ArticleSubmission extends ArticleBase, Models.Document {
  $id: string;
}

export interface PublishedArticle extends ArticleBase, Models.Document {
  publishedDate: string;
  comments: any[];
  upVotes: any[];
}

// Initialize the Appwrite client
const client = new Client()
  .setEndpoint(APPWRITE_ENDPOINT)
  .setProject(APPWRITE_PROJECT_ID);

export const account = new Account(client);
export const databases = new Databases(client);
export const storage = new Storage(client);

export async function login(
  email: string,
  password: string
): Promise<Models.Preferences> {
  try {
    const currentSession = await account.get();
    console.log("Session is already active");
    return currentSession;
  } catch (error) {
    return await account.createEmailPasswordSession(email, password);
  }
}

export async function logout(): Promise<void> {
  await account.deleteSessions();
}

export async function getCurrentUser(): Promise<Models.User<Models.Preferences> | null> {
  try {
    const user = await account.get();
    if (user?.labels[0] !== "admin") {
      return null;
    }

    return user;
  } catch (error) {
    return null;
  }
}

export async function getSubmittedArticles(): Promise<
  Models.DocumentList<ArticleSubmission>
> {
  try {
    return await databases.listDocuments(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID_SUBMISSIONS
    );
  } catch (error) {
    console.error("Error fetching submitted articles:", error);
    throw error;
  }
}

export async function getArticle(
  articleId: string
): Promise<ArticleSubmission> {
  try {
    return await databases.getDocument(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID_SUBMISSIONS,
      articleId
    );
  } catch (error) {
    console.error(`Error fetching article ${articleId}:`, error);
    throw error;
  }
}

export async function updateArticle(
  articleId: string,
  data: Partial<ArticleSubmission>
): Promise<ArticleSubmission> {
  try {
    return await databases.updateDocument(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID_SUBMISSIONS,
      articleId,
      data
    );
  } catch (error) {
    console.error(`Error updating article ${articleId}:`, error);
    throw error;
  }
}

export async function publishArticle(
  article: ArticleSubmission
): Promise<PublishedArticle> {
  try {
    const publishedArticle = await databases.createDocument<PublishedArticle>(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID_ARTICLES,
      article.$id,
      {
        title: article.title,
        newsImageURL: article.newsImageURL,
        discription: article.discription,
        user: article.users?.$id,
      }
    );

    await databases.deleteDocument(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID_SUBMISSIONS,
      article.$id
    );

    return publishedArticle;
  } catch (error) {
    console.error(`Error publishing article ${article.$id}:`, error);
    throw error;
  }
}

export async function deleteArticle(
  articleId: string,
  collectionId: string = APPWRITE_COLLECTION_ID_SUBMISSIONS
): Promise<void> {
  try {
    await databases.deleteDocument(
      APPWRITE_DATABASE_ID,
      collectionId,
      articleId
    );

    await storage.deleteFile(
      APPWRITE_BUCKET_ID_ARTICLES_IMAGE,
      "article_image_" + articleId
    );
  } catch (error) {
    console.error(`Error deleting article ${articleId}:`, error);
    throw error;
  }
}

export async function getReleasedArticles(): Promise<
  Models.DocumentList<ArticleSubmission>
> {
  try {
    return await databases.listDocuments(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID_ARTICLES
    );
  } catch (error) {
    console.error("Error fetching submitted articles:", error);
    throw error;
  }
}

export async function getReleasedArticle(
  articleId: string
): Promise<ArticleSubmission> {
  try {
    return await databases.getDocument(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID_ARTICLES,
      articleId
    );
  } catch (error) {
    console.error(`Error fetching article ${articleId}:`, error);
    throw error;
  }
}

export async function updateReleasedArticle(
  articleId: string,
  data: Partial<ArticleSubmission>
): Promise<ArticleSubmission> {
  try {
    return await databases.updateDocument(
      APPWRITE_DATABASE_ID,
      APPWRITE_COLLECTION_ID_ARTICLES,
      articleId,
      data
    );
  } catch (error) {
    console.error(`Error updating article ${articleId}:`, error);
    throw error;
  }
}

export async function deleteRelesedArticle(
  articleId: string,
  collectionId: string = APPWRITE_COLLECTION_ID_ARTICLES
): Promise<void> {
  try {
    await databases.deleteDocument(
      APPWRITE_DATABASE_ID,
      collectionId,
      articleId
    );

    await storage.deleteFile(
      APPWRITE_BUCKET_ID_ARTICLES_IMAGE,
      "article_image_" + articleId
    );
  } catch (error) {
    console.error(`Error deleting article ${articleId}:`, error);
    throw error;
  }
}

<script lang="ts">
  import { onMount } from "svelte";
  import { page } from "$app/stores";
  import { goto } from "$app/navigation";
  import {
    deleteRelesedArticle,
    storage,
    APPWRITE_BUCKET_ID_ARTICLES_IMAGE,
    getReleasedArticle,
    updateReleasedArticle,
  } from "$lib/appwrite";

  const articleId = $page.params.id;

  let article: any = null;
  let isLoading = true;
  let isSaving = false;
  let error: any = null;
  let successMessage: string | null = null;

  // Form fields
  let title = "";
  let description = "";
  let imageUrl = "";
  let imageFile: any = null;
  let imagePreview: any = null;

  onMount(async () => {
    await fetchArticle();
  });

  async function fetchArticle() {
    isLoading = true;
    error = null;

    try {
      article = await getReleasedArticle(articleId);

      // Set form fields
      title = article.title || "";
      description = article.discription || "";
      imageUrl = article.newsImageURL || "";
      imagePreview = imageUrl;
    } catch (err) {
      console.error("Error fetching article:", err);
      error =
        "Failed to load article. It may have been deleted or you may not have permission to view it.";
    } finally {
      isLoading = false;
    }
  }

  function handleImageChange(event: any) {
    const file = event.target.files[0];
    if (!file) return;

    // Validate file type
    if (!file.type.startsWith("image/")) {
      alert("Please select an image file");
      return;
    }

    imageFile = file;

    // Create a preview
    const reader = new FileReader();
    reader.onload = (e: any) => {
      imagePreview = e.target.result;
    };
    reader.readAsDataURL(file);
  }

  async function uploadImage() {
    if (!imageFile) return imageUrl;

    try {
      const fileId = "article_image_" + articleId;
      try {
        await storage.deleteFile(APPWRITE_BUCKET_ID_ARTICLES_IMAGE, fileId);
      } catch (err) {
        console.error(fileId);
        console.error("Error deleting the current image:", err);
        throw new Error("Failed to delete the current image");
      }

      const response = await storage.createFile(
        APPWRITE_BUCKET_ID_ARTICLES_IMAGE,
        fileId,
        imageFile
      );

      return (
        "https://cloud.appwrite.io/v1/storage/buckets/" +
        APPWRITE_BUCKET_ID_ARTICLES_IMAGE +
        "/files/" +
        response.$id +
        "/view?project=67bc8d29001459bf1e41"
      );
    } catch (err) {
      console.error("Error uploading image:", err);
      throw new Error("Failed to upload image");
    }
  }

  async function handleSave() {
    isSaving = true;
    error = null;
    successMessage = null;

    try {
      // Upload image if a new one was selected
      let updatedImageUrl = imageUrl;
      if (imageFile) {
        updatedImageUrl = await uploadImage();
      }

      // Update article
      await updateReleasedArticle(articleId, {
        title,
        discription: description, // Note: using the field name from your Dart model
        newsImageURL: updatedImageUrl,
      });

      successMessage = "Article saved successfully!";

      // Update local state
      imageUrl = updatedImageUrl;
      imageFile = null;
    } catch (err) {
      console.error("Error saving article:", err);
      error = "Failed to save article. Please try again.";
    } finally {
      isSaving = false;
    }
  }

  async function handleDelete() {
    if (
      !confirm(
        "Are you sure you want to delete this article? This action cannot be undone."
      )
    ) {
      return;
    }

    try {
      await deleteRelesedArticle(articleId);
      goto("/dashboard");
    } catch (err) {
      console.error("Error deleting article:", err);
      error = "Failed to delete article. Please try again.";
    }
  }
</script>

<svelte:head>
  <title>Edit Article | Admin Dashboard</title>
</svelte:head>

<div class="edit-container">
  <div class="page-header">
    <div class="header-content">
      <a href="/dashboard" class="back-button">← Back to Articles</a>
      <h1>Edit Article</h1>
    </div>

    <div class="header-actions">
      <button class="delete-button" on:click={handleDelete}>Delete</button>
    </div>
  </div>

  {#if isLoading}
    <div class="loading">
      <p>Loading article...</p>
    </div>
  {:else if !article}
    <div class="not-found">
      <p>Article not found or you don't have permission to view it.</p>
      <a href="/dashboard/" class="back-link">Back to Articles</a>
    </div>
  {:else}
    <form on:submit|preventDefault={handleSave} class="edit-form">
      <div class="form-group">
        <label for="title">Title</label>
        <input
          type="text"
          id="title"
          bind:value={title}
          placeholder="Article title"
          required
        />
      </div>

      <div class="form-group">
        <label for="description">Description/Content</label>
        <textarea
          id="description"
          bind:value={description}
          placeholder="Article content"
          rows="10"
          required
        ></textarea>
      </div>

      <div class="form-group">
        <label for="image">Featured Image</label>

        {#if imagePreview}
          <div class="image-preview">
            <img src={imagePreview} alt="Article preview" />
          </div>
        {/if}

        <div class="file-input-container">
          <input
            type="file"
            id="image"
            accept="image/*"
            on:change={handleImageChange}
          />
          <label for="image" class="file-input-label">
            {imageFile ? imageFile.name : "Choose a new image"}
          </label>
        </div>
      </div>

      {#if error}
        <div class="error-message">
          {error}
        </div>
      {/if}

      {#if successMessage}
        <div class="success-message">
          {successMessage}
        </div>
      {/if}

      <div class="form-actions">
        <button type="submit" class="save-button" disabled={isSaving}>
          {#if isSaving}
            Saving...
          {:else}
            Save Changes
          {/if}
        </button>
      </div>
    </form>

    {#if article.users}
      <div class="author-info">
        <h3>Author Information</h3>
        <p>
          <strong>Name:</strong>
          {article.users.fullName || "N/A"}
        </p>
        <p>
          <strong>Email:</strong>
          {article.users.emailId || "N/A"}
        </p>
        <p>
          <strong>User ID:</strong>
          {article.users.$id || "N/A"}
        </p>
      </div>
    {/if}
  {/if}
</div>

<style>
  .edit-container {
    max-width: 800px;
    margin: 0 auto;
  }

  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 2rem;
  }

  .header-content {
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .back-button {
    color: #4a56e2;
    text-decoration: none;
    font-weight: 500;
  }

  .back-button:hover {
    text-decoration: underline;
  }

  h1 {
    margin: 0;
    color: #333;
  }

  .header-actions {
    display: flex;
    gap: 0.5rem;
  }

  .error-message,
  .success-message {
    padding: 1rem;
    border-radius: 4px;
    margin-bottom: 1.5rem;
  }

  .error-message {
    background-color: #ffebee;
    color: #c62828;
  }

  .success-message {
    background-color: #e8f5e9;
    color: #2e7d32;
  }

  .loading,
  .not-found {
    text-align: center;
    padding: 3rem 0;
    color: #666;
  }

  .back-link {
    display: inline-block;
    margin-top: 1rem;
    color: #4a56e2;
    text-decoration: none;
  }

  .back-link:hover {
    text-decoration: underline;
  }

  .edit-form {
    background: white;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    margin-bottom: 2rem;
  }

  .form-group {
    margin-bottom: 1.5rem;
  }

  label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
    color: #333;
  }

  input[type="text"],
  textarea {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
    font-family: inherit;
  }

  textarea {
    resize: vertical;
  }

  .image-preview {
    margin-bottom: 1rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    overflow: hidden;
  }

  .image-preview img {
    max-width: 100%;
    display: block;
  }

  .file-input-container {
    position: relative;
  }

  input[type="file"] {
    position: absolute;
    width: 0.1px;
    height: 0.1px;
    opacity: 0;
    overflow: hidden;
    z-index: -1;
  }

  .file-input-label {
    display: inline-block;
    padding: 0.75rem 1rem;
    background-color: #f5f5f5;
    color: #333;
    border: 1px solid #ddd;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .file-input-label:hover {
    background-color: #e0e0e0;
  }

  .form-actions {
    display: flex;
    justify-content: flex-end;
  }

  .save-button,
  .publish-button,
  .delete-button {
    padding: 0.75rem 1.5rem;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .save-button {
    background-color: #4a56e2;
    color: white;
  }

  .save-button:hover {
    background-color: #3a46c2;
  }

  .save-button:disabled {
    background-color: #a0a0a0;
    cursor: not-allowed;
  }

  .delete-button {
    background-color: #f44336;
    color: white;
  }

  .delete-button:hover {
    background-color: #d32f2f;
  }

  .author-info {
    background: white;
    padding: 1.5rem;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .author-info h3 {
    margin-top: 0;
    margin-bottom: 1rem;
    color: #333;
  }

  /* Responsive styles */
  @media (max-width: 768px) {
    .page-header {
      flex-direction: column;
      gap: 1rem;
    }

    .header-actions {
      width: 100%;
    }

    .header-actions button {
      flex: 1;
    }

    .edit-form {
      padding: 1.5rem;
    }
  }
</style>

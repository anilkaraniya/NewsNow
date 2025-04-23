<!-- src/routes/dashboard/articles/+page.svelte -->
<script lang="ts">
  import { onMount } from "svelte";
  import { deleteRelesedArticle, getReleasedArticles } from "$lib/appwrite";

  let articles: any = [];
  let isLoading = true;
  let error: any = null;

  onMount(async () => {
    await fetchArticles();
  });

  async function fetchArticles() {
    isLoading = true;
    error = null;

    try {
      const response = await getReleasedArticles();
      articles = response.documents.reverse();
    } catch (err) {
      console.error("Error fetching articles:", err);
      error = "Failed to load submitted articles. Please try again.";
    } finally {
      isLoading = false;
    }
  }

  async function handleDelete(articleId: string) {
    if (
      !confirm(
        "Are you sure you want to delete this article? This action cannot be undone."
      )
    ) {
      return;
    }

    try {
      await deleteRelesedArticle(articleId);
      await fetchArticles();
      alert("Article deleted successfully!");
    } catch (err) {
      console.error("Error deleting article:", err);
      alert("Failed to delete article. Please try again.");
    }
  }

  function formatDate(dateString: string) {
    if (!dateString) return "N/A";

    const date = new Date(dateString);
    return new Intl.DateTimeFormat("en-US", {
      year: "numeric",
      month: "short",
      day: "numeric",
      hour: "2-digit",
      minute: "2-digit",
    }).format(date);
  }

  function truncateText(text: string, maxLength = 100) {
    if (!text) return "No description";

    if (text.length <= maxLength) return text;

    return text.substring(0, maxLength) + "...";
  }
</script>

<svelte:head>
  <title>Admin Dashboard</title>
</svelte:head>

<div class="articles-container">
  <div class="page-header">
    <h1>Articles</h1>
    <button
      class="refresh-button"
      on:click={fetchArticles}
      disabled={isLoading}
    >
      {#if isLoading}
        Loading...
      {:else}
        Refresh
      {/if}
    </button>
  </div>

  {#if error}
    <div class="error-message">
      {error}
    </div>
  {/if}

  {#if isLoading}
    <div class="loading">
      <p>Loading articles...</p>
    </div>
  {:else if articles.length === 0}
    <div class="empty-state">
      <p>No submitted articles found.</p>
    </div>
  {:else}
    <div class="articles-grid">
      {#each articles as article (article.$id)}
        <div class="article-card">
          <div class="article-image">
            {#if article.newsImageURL}
              <img
                src={article.newsImageURL}
                alt={article.title || "Article image"}
              />
            {:else}
              <div class="no-image">No Image</div>
            {/if}
          </div>

          <div class="article-content">
            <h2 class="article-title">{article.title || "Untitled Article"}</h2>

            <div class="article-meta">
              <span>By: {article.user?.fullName || "Unknown author"}</span>
              <span>Submitted: {formatDate(article.$createdAt)}</span>
            </div>

            <p class="article-description">
              {truncateText(article.discription)}
            </p>

            <div class="article-actions">
              <a
                href={`/dashboard/articles/${article.$id}`}
                class="edit-button"
              >
                Edit
              </a>

              <button
                class="delete-button"
                on:click={() => handleDelete(article.$id)}
              >
                Delete
              </button>
            </div>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
  .articles-container {
    max-width: 1200px;
    margin: 0 auto;
  }

  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2rem;
  }

  h1 {
    margin: 0;
    color: #333;
  }

  .refresh-button {
    padding: 0.5rem 1rem;
    background-color: #4a56e2;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }

  .refresh-button:hover {
    background-color: #3a46c2;
  }

  .refresh-button:disabled {
    background-color: #a0a0a0;
    cursor: not-allowed;
  }

  .error-message {
    background-color: #ffebee;
    color: #c62828;
    padding: 1rem;
    border-radius: 4px;
    margin-bottom: 1.5rem;
  }

  .loading,
  .empty-state {
    text-align: center;
    padding: 3rem 0;
    color: #666;
  }

  .articles-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
    gap: 1.5rem;
  }

  .article-card {
    background: white;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
    transition:
      transform 0.2s,
      box-shadow 0.2s;
  }

  .article-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
  }

  .article-image {
    height: 200px;
    background-color: #f5f5f5;
    position: relative;
  }

  .article-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
  }

  .no-image {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #999;
    font-style: italic;
  }

  .article-content {
    padding: 1.5rem;
  }

  .article-title {
    margin: 0 0 0.5rem 0;
    font-size: 1.25rem;
    color: #333;
  }

  .article-meta {
    display: flex;
    justify-content: space-between;
    color: #666;
    font-size: 0.875rem;
    margin-bottom: 1rem;
  }

  .article-description {
    color: #444;
    margin-bottom: 1.5rem;
    line-height: 1.5;
  }

  .article-actions {
    display: flex;
    gap: 0.5rem;
  }

  .edit-button,
  .delete-button {
    flex: 1;
    padding: 0.5rem;
    border: none;
    border-radius: 4px;
    font-size: 0.875rem;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    transition: background-color 0.2s;
  }

  .edit-button {
    background-color: #2196f3;
    color: white;
  }

  .edit-button:hover {
    background-color: #1976d2;
  }

  .delete-button {
    background-color: #f44336;
    color: white;
  }

  .delete-button:hover {
    background-color: #d32f2f;
  }

  /* Responsive styles */
  @media (max-width: 768px) {
    .articles-grid {
      grid-template-columns: 1fr;
    }

    .article-meta {
      flex-direction: column;
      gap: 0.25rem;
    }
  }
</style>

<script lang="ts">
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import { login } from "$lib/appwrite";
  import { user } from "$lib/auth";

  let email = "";
  let password = "";
  let error = "";
  let isLoading = false;

  onMount(() => {
    user.subscribe((value) => {
      if (value) {
        goto("/dashboard");
      }
    });
  });

  async function handleLogin() {
    error = "";
    isLoading = true;

    try {
      if (!email || !password) {
        throw new Error("Email and password are required");
      }

      await login(email, password);

      // Redirect to dashboard page
      goto("/dashboard", { replaceState: true });
    } catch (err: any) {
      console.error("Login error:", err);
      error = err.message || "Failed to login. Please check your credentials.";
    } finally {
      isLoading = false;
    }
  }
</script>

<div class="login-container">
  <div class="login-card">
    <h1>Admin Login</h1>

    {#if error}
      <div class="error-message">
        {error}
      </div>
    {/if}

    <form on:submit|preventDefault={handleLogin}>
      <div class="form-group">
        <label for="email">Email</label>
        <input
          type="email"
          id="email"
          bind:value={email}
          placeholder="Enter your email"
          required
        />
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <input
          type="password"
          id="password"
          bind:value={password}
          placeholder="Enter your password"
          required
        />
      </div>

      <button type="submit" class="login-button" disabled={isLoading}>
        {#if isLoading}
          Loading...
        {:else}
          Login
        {/if}
      </button>
    </form>
  </div>
</div>

<style>
  .login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background-color: #f5f5f5;
  }

  .login-card {
    background: white;
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    width: 100%;
    max-width: 400px;
  }

  h1 {
    text-align: center;
    margin-bottom: 2rem;
    color: #333;
  }

  .form-group {
    margin-bottom: 1.5rem;
  }

  label {
    display: block;
    margin-bottom: 0.5rem;
    font-weight: 500;
  }

  input {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #ddd;
    border-radius: 4px;
    font-size: 1rem;
  }

  .login-button {
    width: 100%;
    padding: 0.75rem;
    background-color: #4a56e2;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .login-button:hover {
    background-color: #3a46c2;
  }

  .login-button:disabled {
    background-color: #a0a0a0;
    cursor: not-allowed;
  }

  .error-message {
    background-color: #ffebee;
    color: #c62828;
    padding: 0.75rem;
    border-radius: 4px;
    margin-bottom: 1.5rem;
  }
</style>

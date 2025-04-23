<!-- src/routes/+page.svelte -->
<script lang="ts">
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import { user, initAuth } from "$lib/auth";

  onMount(() => {
    // Initialize authentication
    initAuth();

    // Subscribe to user store
    const unsubscribe = user.subscribe((value: any) => {
      if (value) {
        // If user is logged in, redirect to dashboard
        goto("/dashboard");
      } else {
        // If no user, redirect to login
        goto("/login");
      }
    });

    return unsubscribe;
  });
</script>

<div class="container">
  <h1>Redirecting...</h1>
  <p>Please wait while we redirect you to the appropriate page.</p>
</div>

<style>
  .container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 100vh;
    text-align: center;
    color: #333;
  }

  h1 {
    margin-bottom: 1rem;
  }
</style>

<script>
  /** @type {{children: import('svelte').Snippet}} */
  let { children } = $props();
</script>

<div class="app">
  <main>
    {@render children()}
  </main>
</div>

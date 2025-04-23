<script>
  import { onMount } from "svelte";
  import { goto } from "$app/navigation";
  import { user, initAuth, requireAuth, isLoading } from "$lib/auth";
  import { page } from "$app/stores";
  import { logout } from "$lib/appwrite";
  import { get } from "svelte/store";

  let userName = "";
  let isMenuOpen = false;

  onMount(() => {
    initAuth();
    requireAuth($page.url);

    const unsubscribe = isLoading.subscribe((loading) => {
      if (!loading && !get(user)) {
        goto("/login");
      }
    });

    user.subscribe((value) => {
      if (!value) {
        goto("/login");
      }
      if (value) {
        userName = value.name || value.email || "Admin";
      }
    });
    return () => unsubscribe();
  });

  async function handleLogout() {
    try {
      await logout();
      goto("/login");
    } catch (error) {
      console.error("Logout error:", error);
    }
  }

  function toggleMenu() {
    isMenuOpen = !isMenuOpen;
  }
</script>

<div class="layout">
  <!-- Sidebar -->
  <aside class={`sidebar ${isMenuOpen ? "open" : ""}`}>
    <div class="sidebar-header">
      <h2>News Admin</h2>
      <button class="close-menu" onclick={toggleMenu}>×</button>
    </div>

    <nav class="sidebar-nav">
      <a
        href="/dashboard"
        class={$page.url.pathname === "/dashboard" ? "active" : ""}
      >
        Dashboard
      </a>
      <a
        href="/dashboard/submission"
        class={$page.url.pathname.includes("/dashboard/submission")
          ? "active"
          : ""}
      >
        Submitted Articles
      </a>
      <div class="sidebar-footer">
        <button class="logout-button" onclick={handleLogout}>Logout</button>
      </div>
    </nav>
  </aside>

  <!-- Main content -->
  <main class="content">
    <header class="content-header">
      <button class="menu-toggle" aria-label="Toggle menu" onclick={toggleMenu}>
        <span></span>
        <span></span>
        <span></span>
      </button>

      <div class="user-info">
        <span>Welcome, {userName}</span>
      </div>
    </header>

    <div class="page-content">
      <slot />
    </div>
  </main>
</div>

<style>
  .layout {
    display: flex;
    min-height: 100vh;
  }

  .sidebar {
    width: 260px;
    background-color: #222;
    color: white;
    display: flex;
    flex-direction: column;
    transition: transform 0.3s ease;
  }

  .sidebar-header {
    padding: 1.5rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #333;
  }

  .sidebar-header h2 {
    margin: 0;
    font-size: 1.5rem;
  }

  .close-menu {
    display: none;
    background: none;
    border: none;
    color: white;
    font-size: 1.5rem;
    cursor: pointer;
  }

  .sidebar-nav {
    flex: 1;
    padding: 1.5rem 0;
  }

  .sidebar-nav a {
    display: block;
    padding: 0.75rem 1.5rem;
    color: #ccc;
    text-decoration: none;
    transition: background-color 0.2s;
  }

  .sidebar-nav a:hover {
    background-color: #333;
    color: white;
  }

  .sidebar-nav a.active {
    background-color: #4a56e2;
    color: white;
  }

  .sidebar-footer {
    padding: 1.5rem;
    border-top: 1px solid #333;
  }

  .logout-button {
    width: 100%;
    padding: 0.75rem;
    background-color: #e53935;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .logout-button:hover {
    background-color: #c62828;
  }

  .content {
    flex: 1;
    background-color: #f5f5f5;
    display: flex;
    flex-direction: column;
  }

  .content-header {
    background-color: white;
    padding: 1rem 1.5rem;
    display: flex;
    justify-content: space-between;
    align-items: center;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  }

  .user-info {
    font-weight: 500;
  }

  .page-content {
    flex: 1;
    padding: 1.5rem;
    overflow-y: auto;
  }

  .menu-toggle {
    display: none;
    background: none;
    border: none;
    cursor: pointer;
    width: 30px;
    height: 20px;
    position: relative;
    padding: 0;
  }

  .menu-toggle span {
    display: block;
    position: absolute;
    height: 2px;
    width: 100%;
    background: #333;
    left: 0;
    transition: 0.25s ease-in-out;
  }

  .menu-toggle span:nth-child(1) {
    top: 0;
  }

  .menu-toggle span:nth-child(2) {
    top: 9px;
  }

  .menu-toggle span:nth-child(3) {
    top: 18px;
  }

  /* Mobile responsive styles */
  @media (max-width: 768px) {
    .sidebar {
      position: fixed;
      top: 0;
      left: 0;
      bottom: 0;
      z-index: 10;
      transform: translateX(-100%);
    }

    .sidebar.open {
      transform: translateX(0);
    }

    .close-menu {
      display: block;
    }

    .menu-toggle {
      display: block;
    }
  }
</style>

import { writable } from "svelte/store";
import { browser } from "$app/environment";
import { goto } from "$app/navigation";
import { getCurrentUser } from "./appwrite";

export const user = writable<any>(null);
export const isLoading = writable(true);

export async function initAuth() {
  if (browser) {
    isLoading.set(true);

    try {
      const currentUser = await getCurrentUser();

      if (currentUser) {
        user.set(currentUser);
      } else {
        user.set(null);
      }
    } catch (error) {
      console.error("Error initializing auth:", error);
      user.set(null);
    } finally {
      isLoading.set(false); // Ensure loading is completed
    }
  }
}

export function requireAuth(url: any) {
  if (browser) {
    user.subscribe((value) => {
      if (url.pathname === "/login") return;

      if (value === null && !isLoading) {
        goto("/login");
      } else if (value !== null && url.pathname !== "/dashboard") {
        goto("/dashboard", { replaceState: true });
      }
    });
  }
}

export async function checkAuth(event: any) {
  const sessionCookie = event.cookies.get("appwrite-session");

  if (!sessionCookie && !event.url.pathname.startsWith("/login")) {
    return Response.redirect(new URL("/login", event.url.origin));
  }

  return null;
}

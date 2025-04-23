// src/hooks.server.js
import { checkAuth } from "$lib/auth";

/** @type {import('@sveltejs/kit').Handle} */
export async function handle({ event, resolve }) {
  // Check authentication for protected routes
  const authResponse = await checkAuth(event);
  if (authResponse) return authResponse;

  const response = await resolve(event);
  return response;
}

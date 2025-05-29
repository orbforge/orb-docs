<script>
  import '../app.css';
  import 'highlight.js/styles/github.css';
  import { page } from '$app/stores';
  import { parseNavigation } from '$lib/navigation.js';
  
  const sections = parseNavigation();
</script>

<div class="app">
  <nav class="sidebar">
    <h2><a href="/" class="home-link">Orb Documentation</a></h2>
    {#each sections as section}
      <div class="nav-section">
        <h3><a href="/{section.slug}" class="section-link" class:active={$page.url.pathname === `/${section.slug}`}>{section.title}</a></h3>
        <ul class="nav-list">
          {#each section.articles as article}
            <li>
              <a 
                href="/{article.slug}" 
                class:active={$page.url.pathname === `/${article.slug}`}
              >
                {article.title}
              </a>
            </li>
          {/each}
        </ul>
      </div>
    {/each}
  </nav>
  
  <main class="main-content">
    <slot />
  </main>
</div>
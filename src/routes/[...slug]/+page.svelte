<script>
	import { parseMarkdown } from '$lib/markdown.js'

	export let data

	$: ({ html, frontmatter, toc } = parseMarkdown(data.content))
</script>

<svelte:head>
	<title>{frontmatter.title || 'Orb Documentation'}</title>
	{#if frontmatter.metaDescription}
		<meta name="description" content={frontmatter.metaDescription} />
	{/if}
</svelte:head>

<article class="article-content">
	{#if toc}
		<div class="toc-container">
			{@html toc}
		</div>
	{/if}
	{@html html}
</article>

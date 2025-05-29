// This file reuses the markdown parsing logic from the parent repo
import { marked } from 'marked';
import matter from 'gray-matter';
import hljs from 'highlight.js';

// Create a custom renderer for syntax highlighting
const renderer = new marked.Renderer();

// Override the code renderer for syntax highlighting
renderer.code = function(code) {
  const validCode = typeof code.text === 'string' ? code.text : '';
  const validLanguage = code.lang && hljs.getLanguage(code.lang) ? code.lang : 'plaintext';
  
  let highlighted;
  try {
    highlighted = hljs.highlight(validCode, { language: validLanguage }).value;
  } catch (err) {
    console.error(`Error highlighting code block: ${err.message}`);
    highlighted = validCode;
  }
  
  return `<pre class="hljs language-${validLanguage}"><code>${highlighted}</code></pre>`;
};

// Override the link renderer to strip .md extensions and /docs/ prefix
renderer.link = function(link) {
  let modifiedHref = link.href;
  
  // Remove /docs/ prefix
  if (modifiedHref && typeof modifiedHref === 'string' && modifiedHref.startsWith('/docs/')) {
    modifiedHref = modifiedHref.replace('/docs/', '/');
  }
  
  // Remove .md extension
  if (modifiedHref && typeof modifiedHref === 'string' && modifiedHref.endsWith('.md')) {
    modifiedHref = modifiedHref.slice(0, -3);
  }
  
  const text = link.tokens.map(t => t.raw).join('');
  if (link.title) {
    return `<a href="${modifiedHref}" title="${link.title}">${text}</a>`;
  } else {
    return `<a href="${modifiedHref}">${text}</a>`;
  }
};

// Override the heading renderer to collect TOC entries
renderer.heading = function({ tokens, depth }) {
  const text = this.parser.parseInline(tokens);
  const raw = tokens.map(token => token.raw || '').join('');
  const anchor = raw.toLowerCase().replace(/[^\w]+/g, '-');
  
  // Add to TOC if it exists in the context (exclude h1)
  if (this.toc && depth > 1) {
    this.toc.push({
      anchor: anchor,
      level: depth,
      text: text
    });
  }
  
  return '<h' + depth + ' id="' + anchor + '">' + text + '</h' + depth + '>\n';
};

// Assign the custom renderer to marked
marked.setOptions({ renderer });

/**
 * Processes markdown content to remove .md extensions from links
 */
function processMarkdownContent(content) {
  // Replace .md extensions in markdown links
  content = content.replace(/(\[[^\]]+\]\([^)]+)(\.md)(\))/g, '$1$3');
  return content;
}

/**
 * Builds a nested TOC structure from collected headings
 */
function buildTOC(coll, k, level, ctx) {
  if (k >= coll.length || coll[k].level <= level) { return k; }
  var node = coll[k];
  ctx.push("<li><a href='#" + node.anchor + "'>" + node.text + "</a>");
  k++;
  var childCtx = [];
  k = buildTOC(coll, k, node.level, childCtx);
  if (childCtx.length > 0) {
    ctx.push("<ul>");
    childCtx.forEach(function (idm) {
      ctx.push(idm);
    });
    ctx.push("</ul>");
  }
  ctx.push("</li>");
  k = buildTOC(coll, k, level, ctx);
  return k;
}

/**
 * Parse markdown file content
 */
export function parseMarkdown(content) {
  // Parse the markdown and extract frontmatter
  const { content: rawContent, data: frontmatter } = matter(content);
  
  // Process the markdown content
  const processedContent = processMarkdownContent(rawContent);
  
  // Create TOC array and attach to renderer
  const toc = [];
  renderer.toc = toc;
  
  // Parse the markdown content into HTML
  const html = marked.parse(processedContent);
  
  // Build the TOC HTML
  const tocCtx = [];
  if (toc.length > 0) {
    tocCtx.push('<div class="toc-title">Contents</div>\n<ul>');
    buildTOC(toc, 0, 0, tocCtx);
    tocCtx.push("</ul>");
  }
  
  return {
    html,
    frontmatter,
    toc: tocCtx.join("")
  };
}
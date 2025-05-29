// Parse navigation from navigation.md
import { marked } from 'marked';
import fs from 'fs';
import path from 'path';

// Read navigation.md at build time
const __dirname = path.dirname(new URL(import.meta.url).pathname);
const navigationPath = path.resolve(__dirname, '../../navigation.md');
const navigationContent = fs.readFileSync(navigationPath, 'utf-8');

function removeMarkdownExtension(path) {
  return path.endsWith('.md') ? path.slice(0, -3) : path;
}

export function parseNavigation() {
  const tokens = marked.lexer(navigationContent);
  const sections = [];
  let currentSection = null;
  
  for (const token of tokens) {
    if (token.type === 'heading' && token.depth === 2) {
      const linkMatch = token.text.match(/\[(.*?)\]\((.*?)\)/);
      
      if (linkMatch) {
        const title = linkMatch[1];
        const sectionPath = linkMatch[2].replace('/docs/', '');
        const sectionSlug = removeMarkdownExtension(sectionPath);
        
        currentSection = {
          title,
          slug: sectionSlug,
          articles: []
        };
        
        sections.push(currentSection);
      }
    } else if (token.type === 'list' && currentSection) {
      for (const item of token.items) {
        const linkMatch = item.text.match(/\[(.*?)\]\((.*?)\)/);
        
        if (linkMatch) {
          const title = linkMatch[1];
          const articlePath = linkMatch[2].replace('/docs/', '');
          const articleSlug = removeMarkdownExtension(articlePath);
          
          currentSection.articles.push({
            title,
            slug: articleSlug
          });
        }
      }
    }
  }
  
  return sections;
}
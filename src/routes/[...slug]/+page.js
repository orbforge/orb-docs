import { error } from '@sveltejs/kit';
import fs from 'fs';
import path from 'path';

export const ssr = true;

export async function load({ params }) {
  const slug = params.slug;
  
  // Try different file paths
  const paths = [
    `docs/${slug}.md`,
    `docs/${slug}/README.md`,
    `docs/${slug}/${slug.split('/').pop()}.md`
  ];
  
  let content = null;
  let loadedPath = null;
  
  // Use server-side file reading
  if (typeof window === 'undefined') {
    const __dirname = path.dirname(new URL(import.meta.url).pathname);
    const baseDir = path.resolve(__dirname, '../../../');
    
    for (const filePath of paths) {
      try {
        const fullPath = path.join(baseDir, filePath);
        content = fs.readFileSync(fullPath, 'utf-8');
        loadedPath = filePath;
        break;
      } catch (e) {
        // Continue to next path
      }
    }
  }
  
  if (!content) {
    throw error(404, 'Documentation not found');
  }
  
  return {
    content,
    slug
  };
}
import MarkdownIt from 'markdown-it';
import emoji from 'markdown-it-emoji';

const markdownRenderer = new MarkdownIt({
  linkify: true,
});

markdownRenderer.use(emoji);

export default markdownRenderer;

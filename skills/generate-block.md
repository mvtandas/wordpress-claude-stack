# /generate-block

Generate a custom Gutenberg block with PHP registration and React edit/save.

## Usage
```
/generate-block hero-banner --attributes "title, subtitle, backgroundImage, ctaText, ctaUrl"
/generate-block testimonial-card --attributes "quote, authorName, authorRole, avatar"
```

## Instructions

Create block structure:
```
blocks/{block-name}/
├── block.json         # Block metadata
├── index.js           # Block registration (JS)
├── edit.js            # Editor component
├── save.js            # Frontend save
├── style.css          # Frontend styles
├── editor.css         # Editor-only styles
└── render.php         # Server-side render (dynamic blocks)
```

block.json template:
```json
{
    "$schema": "https://schemas.wp.org/trunk/block.json",
    "apiVersion": 3,
    "name": "{namespace}/{block-name}",
    "version": "1.0.0",
    "title": "{Block Title}",
    "category": "theme",
    "icon": "block-default",
    "description": "{description}",
    "supports": {
        "html": false,
        "align": true,
        "color": { "background": true, "text": true }
    },
    "attributes": {},
    "textdomain": "{textdomain}",
    "editorScript": "file:./index.js",
    "editorStyle": "file:./editor.css",
    "style": "file:./style.css"
}
```

PHP registration:
```php
function {prefix}_register_blocks(): void {
    register_block_type(__DIR__ . '/blocks/{block-name}');
}
add_action('init', '{prefix}_register_blocks');
```

Rules:
- Use `block.json` API version 3
- Use `useBlockProps()` in edit component
- Use `RichText`, `MediaUpload`, `InspectorControls` from `@wordpress/block-editor`
- For dynamic content, use `render.php` with `render_callback`
- Escape all output in save/render

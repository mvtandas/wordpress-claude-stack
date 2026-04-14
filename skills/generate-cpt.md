# /generate-cpt

Generate a Custom Post Type with taxonomy and meta boxes.

## Usage
```
/generate-cpt portfolio --taxonomies "category, tag" --fields "url, client, year"
/generate-cpt testimonial --fields "author_name, company, rating"
```

## Instructions

Generate a complete CPT registration file:

```php
<?php
declare(strict_types=1);

function {prefix}_register_{cpt}_post_type(): void {
    $labels = [
        'name'               => __('{CPT Plural}', '{textdomain}'),
        'singular_name'      => __('{CPT Singular}', '{textdomain}'),
        'add_new'            => __('Add New', '{textdomain}'),
        'add_new_item'       => __('Add New {CPT Singular}', '{textdomain}'),
        'edit_item'          => __('Edit {CPT Singular}', '{textdomain}'),
        'view_item'          => __('View {CPT Singular}', '{textdomain}'),
        'all_items'          => __('All {CPT Plural}', '{textdomain}'),
        'search_items'       => __('Search {CPT Plural}', '{textdomain}'),
        'not_found'          => __('No {cpt plural} found.', '{textdomain}'),
    ];

    $args = [
        'labels'             => $labels,
        'public'             => true,
        'show_in_rest'       => true, // Gutenberg support
        'has_archive'        => true,
        'menu_icon'          => 'dashicons-portfolio',
        'supports'           => ['title', 'editor', 'thumbnail', 'excerpt'],
        'rewrite'            => ['slug' => '{cpt-slug}'],
    ];

    register_post_type('{cpt_slug}', $args);
}
add_action('init', '{prefix}_register_{cpt}_post_type');
```

Also generate:
- Custom taxonomy registration if requested
- Meta box with `add_meta_box()` for custom fields
- Save function with nonce verification and sanitization
- Template suggestions: `single-{cpt}.php`, `archive-{cpt}.php`

Rules:
- Always set `show_in_rest => true` for Gutenberg
- Always sanitize meta on save
- Always verify nonce on save
- Use `__()` for all visible strings (i18n)

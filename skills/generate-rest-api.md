# /generate-rest-api

Generate a WordPress REST API endpoint with validation and permissions.

## Usage
```
/generate-rest-api products --methods "get, post, put, delete"
/generate-rest-api newsletter/subscribe --methods "post"
```

## Instructions

Generate a REST API class:

```php
<?php
declare(strict_types=1);

class {Prefix}_REST_{Resource} {

    private string $namespace = '{prefix}/v1';
    private string $rest_base = '{resource}';

    public function register_routes(): void {
        register_rest_route($this->namespace, '/' . $this->rest_base, [
            [
                'methods'             => WP_REST_Server::READABLE,
                'callback'            => [$this, 'get_items'],
                'permission_callback' => [$this, 'get_items_permissions_check'],
                'args'                => $this->get_collection_params(),
            ],
            [
                'methods'             => WP_REST_Server::CREATABLE,
                'callback'            => [$this, 'create_item'],
                'permission_callback' => [$this, 'create_item_permissions_check'],
                'args'                => $this->get_endpoint_args_for_item_schema(true),
            ],
        ]);

        register_rest_route($this->namespace, '/' . $this->rest_base . '/(?P<id>[\d]+)', [
            [
                'methods'             => WP_REST_Server::READABLE,
                'callback'            => [$this, 'get_item'],
                'permission_callback' => [$this, 'get_item_permissions_check'],
            ],
            [
                'methods'             => WP_REST_Server::EDITABLE,
                'callback'            => [$this, 'update_item'],
                'permission_callback' => [$this, 'update_item_permissions_check'],
            ],
            [
                'methods'             => WP_REST_Server::DELETABLE,
                'callback'            => [$this, 'delete_item'],
                'permission_callback' => [$this, 'delete_item_permissions_check'],
            ],
        ]);
    }

    public function get_items_permissions_check(WP_REST_Request $request): bool {
        return true; // Public
    }

    public function create_item_permissions_check(WP_REST_Request $request): bool {
        return current_user_can('edit_posts');
    }
}

add_action('rest_api_init', function() {
    (new {Prefix}_REST_{Resource}())->register_routes();
});
```

Rules:
- Always use permission callbacks — never return true for write operations without capability check
- Use `WP_REST_Server::READABLE` etc. constants, not string methods
- Validate params with `validate_callback`
- Sanitize params with `sanitize_callback`
- Return `WP_REST_Response` for success, `WP_Error` for errors
- Use proper HTTP status codes (200, 201, 400, 403, 404)

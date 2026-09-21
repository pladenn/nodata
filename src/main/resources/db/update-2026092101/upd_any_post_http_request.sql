-- Propagates the "Any HTTP" connection and the "Any POST http request" proxy action
-- (built on work) to dev, keyed by id so this is safe/idempotent on either instance.

INSERT INTO "connection" ("id", "description", "type", "url", "login", "password", "code")
VALUES (
    '6fdfb5ed-816e-77a1-3e13-d84bbb452939',
    'Any HTTP',
    'HTTP',
    '{parameters.url}',
    NULL,
    NULL,
    'system-any-http-request'
)
ON CONFLICT (id) DO UPDATE SET
    "description" = EXCLUDED."description",
    "type"        = EXCLUDED."type",
    "url"         = EXCLUDED."url",
    "login"       = EXCLUDED."login",
    "password"    = EXCLUDED."password",
    "code"        = EXCLUDED."code";

INSERT INTO "action" ("id", "code", "connection_id", "query", "content", "execution_type",
                       "title", "post_process", "description", "redirect", "name")
VALUES (
    'eeaece13-e0bb-40e1-b093-c6e05658be57',
    'system-any-post-http-request',
    '6fdfb5ed-816e-77a1-3e13-d84bbb452939',
    NULL,
    '{body}',
    'HTTP_POST',
    'Any POST http request',
    NULL,
    'Generic HTTP POST proxy, twin of system-any-get-http-request. POSTs {body} (raw text) to the full URL given as {url}. Same ''Any HTTP'' connection (url = {parameters.url}), so it works against any downstream target, internal or external.',
    NULL,
    'Any POST http request'
)
ON CONFLICT (id) DO UPDATE SET
    "code"           = EXCLUDED."code",
    "connection_id"  = EXCLUDED."connection_id",
    "query"          = EXCLUDED."query",
    "content"        = EXCLUDED."content",
    "execution_type" = EXCLUDED."execution_type",
    "title"          = EXCLUDED."title",
    "post_process"   = EXCLUDED."post_process",
    "description"    = EXCLUDED."description",
    "redirect"       = EXCLUDED."redirect",
    "name"           = EXCLUDED."name";

INSERT INTO "parameter" ("id", "action_id", "name", "type", "default_value", "title",
                          "editable", "order", "dictionary_id", "name_column", "value_column",
                          "editable_dictionary", "dict_null_value", "description")
VALUES (
    '84d0fe59-afe3-471d-8479-19b6a51e4b68',
    'eeaece13-e0bb-40e1-b093-c6e05658be57',
    'url',
    'STRING',
    NULL,
    'URL',
    true,
    0,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
)
ON CONFLICT (id) DO UPDATE SET
    "action_id"            = EXCLUDED."action_id",
    "name"                 = EXCLUDED."name",
    "type"                 = EXCLUDED."type",
    "default_value"        = EXCLUDED."default_value",
    "title"                = EXCLUDED."title",
    "editable"             = EXCLUDED."editable",
    "order"                = EXCLUDED."order",
    "dictionary_id"        = EXCLUDED."dictionary_id",
    "name_column"          = EXCLUDED."name_column",
    "value_column"         = EXCLUDED."value_column",
    "editable_dictionary"  = EXCLUDED."editable_dictionary",
    "dict_null_value"      = EXCLUDED."dict_null_value",
    "description"          = EXCLUDED."description";

INSERT INTO "parameter" ("id", "action_id", "name", "type", "default_value", "title",
                          "editable", "order", "dictionary_id", "name_column", "value_column",
                          "editable_dictionary", "dict_null_value", "description")
VALUES (
    '5a386182-1168-4b50-bbfa-769e632d3336',
    'eeaece13-e0bb-40e1-b093-c6e05658be57',
    'body',
    'TEXT',
    NULL,
    'Request body',
    true,
    10,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
)
ON CONFLICT (id) DO UPDATE SET
    "action_id"            = EXCLUDED."action_id",
    "name"                 = EXCLUDED."name",
    "type"                 = EXCLUDED."type",
    "default_value"        = EXCLUDED."default_value",
    "title"                = EXCLUDED."title",
    "editable"             = EXCLUDED."editable",
    "order"                = EXCLUDED."order",
    "dictionary_id"        = EXCLUDED."dictionary_id",
    "name_column"          = EXCLUDED."name_column",
    "value_column"         = EXCLUDED."value_column",
    "editable_dictionary"  = EXCLUDED."editable_dictionary",
    "dict_null_value"      = EXCLUDED."dict_null_value",
    "description"          = EXCLUDED."description";

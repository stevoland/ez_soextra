{section show=$attribute.content}{def $href=concat( '/content/download/', $attribute.contentobject_id, '/', $attribute.id,'/version/', $attribute.version , '/file/', $attribute.content.original_filename|urlencode )|ezurl(no)}{if is_set($#host_path)}{set $href=concat($#host_path, $href)}{/if}Filename: {$attribute.content.original_filename|wash(xhtml)}
Link: {$href}
Size: {$attribute.content.filesize|si(byte)}{/section}

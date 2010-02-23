{def $href=$attribute.content.filepath|ezroot(no)}{if is_set($#host_path)}{set $href=concat($#host_path, $href)}{/if}Filename: {$attribute.content.original_filename|wash(xhtml)}
Link: {$href}
Size: {$attribute.content.filesize|si(byte)}

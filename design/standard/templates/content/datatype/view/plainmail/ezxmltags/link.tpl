{set $href=$href|ezurl(no)}{if and(is_set($#host_path), $href|begins_with('/'))}{set $href=concat($#host_path, $href)}{/if}{$content} ({$href})
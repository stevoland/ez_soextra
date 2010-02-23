{if $level|eq(1)}{$content|upcase}
================================================================================



{elseif $level|lt(4)}{$content|upcase}

{def $len=min($content|count_chars,80)
	 $char=cond($level|eq(2), '=', '-')
	 $count=0}{while $count|lt($len)}{$char}{set $count=$count|inc(1)}{/while}



{else}{$content|upcase}

{/if}
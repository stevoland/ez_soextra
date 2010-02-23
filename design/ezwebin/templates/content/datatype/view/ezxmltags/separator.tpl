{def $style=''}{*
*}{default $classification = ''
		 $class_styles=ezini( 'sOExtraSettings', 'ClassStyles', 'soextra.ini',,true() )}{*
*}{if and( or(is_set($#use_inline_styles), is_set($use_inline_styles)), $classification|trim, is_set($class_styles[$classification]) )}{*
	*}{set $style=concat($style, $class_styles[$classification]|wash) }{*
*}{/if}{*
*}{if and( is_set( $fontclass ), $fontclass|trim )}{*
	*}{if and( or(is_set($#use_inline_styles), is_set($use_inline_styles)), is_set($class_styles[$fontclass]) ) }{*
		*}{set $style=concat($style, $class_styles[$fontclass]|wash) }{*
	*}{else}{*
		*}{set $classification = concat( $classification, ' ', $fontclass ) }{*
	*}{/if}{*
*}{/if}
{if and(is_set($width), $width|trim)}{set $style=concat($style, 'width:', $width|wash, '; ') }{/if}
<div class="separator{if $classification|ne('')} {$classification|wash}"{/if}"{if $style|ne('')} style="{$style}"{/if}>
    <div class="separator-design"></div>
</div>
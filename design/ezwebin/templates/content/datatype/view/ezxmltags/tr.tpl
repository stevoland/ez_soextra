{def $style=''}
{if and(is_set( $align ), $align )}{if and(is_unset($#use_inline_styles), is_unset($use_inline_styles))}{set $classification=concat( $classification, ' text-', $align )}{else}{set $style=concat('text-align:',$align,'; ')}{/if}{/if}
*}{default $class_styles=ezini( 'sOExtraSettings', 'ClassStyles', 'soextra.ini',,true() )}{*
*}{if and( or(is_set($#use_inline_styles), is_set($use_inline_styles)), $classification|trim, is_set($class_styles[$classification]) )}{*
	*}{set $style=concat($style, $class_styles[$classification]|wash) }{*
*}{/if}{*
*}{if and( is_set( $fontclass ), $fontclass|trim )}{*
	*}{if and( or(is_set($#use_inline_styles), is_set($use_inline_styles)), is_set($class_styles[$fontclass]) ) }{*
		*}{set $style=concat($style, $class_styles[$fontclass]|wash) }{*
	*}{else}{*
		*}{set $classification = concat( $classification, ' ', $fontclass ) }{*
	*}{/if}{*
*}{/if}{*
{if and(is_set($forecolor), $forecolor|trim)}{set $style=concat($style, 'color:', $forecolor|wash, '; ') }{/if}
{if and(is_set($backcolor), $backcolor|trim)}{set $style=concat($style, 'background-color:', $backcolor|wash,'; ') }{/if}
{if and(is_set($fontsize), $fontsize|trim)}{if and( and(is_unset($#use_inline_styles), is_unset($use_inline_styles)), $fontsize|contains('px'), $fontsize|int|ge(10), $fontsize|int|le(26) )}{set $classification=concat( $classification, ' font-', $fontsize|wash )}{else}{set $style=concat($style, 'font-size:', $fontsize|wash, '; ') }{/if}{/if}
{if and(is_set($lineheight), $lineheight|trim)}{set $style=concat($style, 'line-height:', $lineheight|wash, '; ') }{/if}
{if and(is_set($margin), $margin|trim)}{set $style=concat($style, 'margin:', $margin|wash, '; ') }{/if}
{if and(is_set($padding), $padding|trim)}{set $style=concat($style, 'padding:', $padding|wash, '; ') }{/if}
{if and(is_set($height), $height|trim)}{set $style=concat($style, 'height:', $height|wash, '; ') }{/if}
{if and(is_set($border), $border|trim)}{set $style=concat($style, 'border:', $border|wash, '; ') }{else}
{if and(is_set($border_color), $border_color|trim)}{set $style=concat($style, 'border-color:', $border_color|wash, '; ') }{/if}
{if and(is_set($border_style), $border_style|trim)}{set $style=concat($style, 'border-style:', $border_style|wash, '; ') }{/if}
{if and(is_set($border_size), $border_size|trim)}{set $style=concat($style, 'border-width:', $border_size|wash, '; ') }{/if}{/if}
<tr{if or($classification|ne(''), $row_count|gt( 0 )) } class="{if $classification|ne('')}{$classification|wash}{/if} {if $row_count|gt( 0 )}{if mod( $row_count, 2 )}odd{else}even{/if}{/if}"{/if}{if $style|ne('')} style="{$style}"{/if}>{$content}</tr>
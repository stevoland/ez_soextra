{def $image_variation="false"
     $attribute_parameters=$object_parameters }
{default $inner_style=''
		 $css_class=''}
{if is_set( $attribute_parameters.size )}
{set $image_variation=$object.data_map.image.content[$attribute_parameters.size]}
{else}
{set $image_variation=$object.data_map.image.content[ezini( 'ImageSettings', 'DefaultEmbedAlias', 'content.ini' )]}
{/if}
{def $attr_width=cond( is_set($object_parameters.attr_width), $object_parameters.attr_width, $image_variation.width )
     $attr_height=cond( is_set($object_parameters.attr_height), $object_parameters.attr_height, $image_variation.height ) }
{if and( is_set($object_parameters.border_size), is_set($object_parameters.border_style), is_set($object_parameters.border_color) )}
    {set $inner_style = concat( $inner_style, 'border: ', $object_parameters.border_size, ' ', $object_parameters.border_style, ' ', $object_parameters.border_color, ';' )}
{/if}
{if is_set($object_parameters.margin)}
	{set $inner_style = concat( $inner_style, 'margin: ', $object_parameters.margin, ';' )}
{/if}
{attribute_view_gui 
					attribute=$object.data_map.image 
					image_class=$object_parameters.size 
					border_size=first_set( $object_parameters.border_size, '0' ) 
					border_color=first_set( $object_parameters.border_color, '' ) 
					border_style=first_set( $object_parameters.border_style, 'solid' ) 
					margin=first_set( $object_parameters.margin, '' ) 
					padding=first_set( $object_parameters.padding, '' ) 
					attr_width=cond(is_set($attr_width), $attr_width)
					attr_height=cond(is_set($attr_height), $attr_height)
					inline_style=cond(is_set($inner_style), $inner_style)
					css_class=$css_class
					inline=true()}
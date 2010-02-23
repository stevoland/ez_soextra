{def $attr_width=cond( is_set($object_parameters.attr_width), $object_parameters.attr_width )
     $attr_height=cond( is_set($object_parameters.attr_height), $object_parameters.attr_height ) }

{def $image_width = cond( is_set($attr_width), $attr_width, $object.data_map.image.content[$object_parameters.size].width )}
{if is_set($object_parameters.margin_size)}
    {set $image_width = $image_width|sum(  $object_parameters.margin_size|mul( 2 ) )}
{/if}
{if is_set($object_parameters.border_size)}
    {set $image_width = $image_width|sum(  $object_parameters.border_size|mul( 2 ) )}
{/if}

<div class="content-view-embed"{if or(is_set($#use_inline_styles), is_set($use_inline_styles)) } style="width:{$image_width}px;{if $object_parameters.align|eq('center')}margin:0 auto;{elseif $object_parameters.align|eq('right')}margin:0 0 0 auto;{/if}"{/if}>
<div class="class-image">
    <div class="attribute-image">{if is_set( $link_parameters.href )}{attribute_view_gui 
					attribute=$object.data_map.image
					image_class=$object_parameters.size
					href=$link_parameters.href|ezurl(no)
					inner_style=cond(is_set($inner_style), $inner_style)
					target=$link_parameters.target
					border_size=first_set( $object_parameters.border_size, '0' )
					border_color=first_set( $object_parameters.border_color, '' )
					border_style=first_set( $object_parameters.border_style, 'solid' )
					margin=first_set( $object_parameters.margin, '' ) 
					padding=first_set( $object_parameters.padding, '' ) 
					attr_width=cond(is_set($attr_width), $attr_width)
					attr_height=cond(is_set($attr_height), $attr_height)}{else}{attribute_view_gui 
					attribute=$object.data_map.image 
					image_class=$object_parameters.size 
					border_size=first_set( $object_parameters.border_size, '0' ) 
					border_color=first_set( $object_parameters.border_color, '' ) 
					border_style=first_set( $object_parameters.border_style, 'solid' ) 
					margin=first_set( $object_parameters.margin, '' ) 
					padding=first_set( $object_parameters.padding, '' ) 
					attr_width=cond(is_set($attr_width), $attr_width)
					attr_height=cond(is_set($attr_height), $attr_height)}{/if}</div>

    {if $object.data_map.caption.has_content}
    
        <div class="attribute-caption" style="width:{$image_width}px;">
 
            {attribute_view_gui attribute=$object.data_map.caption} </div>
        {/if} </div>
</div>

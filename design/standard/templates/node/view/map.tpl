{if is_unset($inline) }<div class="content-view-embed node-view-map class-{$node.object.class_identifier}">{/if}

{def $locations=array($node)
	 $location_attribute = 'location'
	 $short_descriptive_attribute='description'
	 $w=400
	 $h=400}
{*if is_set($inline)}
	{def $inline_style=cond($object_parameters.align|eq('right'), 'float:right;', 'float:left;')
		 $css_class=cond( $object_parameters.align, concat('object-',$object_parameters.align) ) }
{/if*}
{if and( is_set($object_parameters.attr_width), $object_parameters.attr_width|trim|ne('') ) }
	{set $w=$object_parameters.attr_width}
{/if}
{if and( is_set($object_parameters.attr_height), $object_parameters.attr_height|trim|ne('') ) }
	{set $h=$object_parameters.attr_height}
{/if}

{include uri="design:parts/gmap.tpl" 
         locations=$locations
		 width=$w
		 height=$h
		 inner_style=cond(is_set($inner_style), $inner_style)
		 css_class=cond(is_set($css_class), $css_class) }

{if is_unset($inline) }</div>{/if}
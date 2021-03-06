        {if ezini_hasvariable('StylesheetSettings', 'EditorDialogCSSFileList', 'design.ini',,true()  )}
            {set $editor_css_list = $editor_css_list|append( ezini('StylesheetSettings', 'EditorDialogCSSFileList', 'design.ini',,true()  ) )}
        {/if}
    
        {def $tag_list='paragraph,literal,header,table,td,th,strong,emphasize,ol,ul,li,link,embed,embed-inline'
             $tags=$tag_list|explode(',')
             $all_tags=$tags|merge(ezini('CustomTagSettings', 'AvailableCustomTags', 'content.ini',,true() ) )
             $classes=array()
             $tags_with_fontclass = array() }
        
        soestyle_classes_per_tag : {ldelim}
            {foreach $all_tags as $tag}
                {if ezini_hasvariable($tag, 'FavouriteClasses', 'soextra.ini',,true() )}
                    {set $classes=ezini($tag, 'FavouriteClasses', 'soextra.ini',,true() ) }
                {else}
                    {set $classes=cond( ezini_hasvariable($tag, 'AvailableClasses', 'content.ini',,true()  ), ezini($tag, 'AvailableClasses', 'content.ini',,true() ), hash() ) }
                {/if}
                "{$tag}": "{$classes|implode(',')}"{delimiter},
                {/delimiter}
            {/foreach}
        {rdelim},
        
        {def $descriptions=hash()}
        soestyle_class_descriptions_per_tag : {ldelim}
            {foreach $all_tags as $tag}
                {set $classes=cond( ezini_hasvariable($tag, 'AvailableClasses', 'content.ini',,true()  ), ezini($tag, 'AvailableClasses', 'content.ini',,true() ), array() ) }
                {set $descriptions=cond( ezini_hasvariable($tag, 'ClassDescription', 'content.ini',,true()  ), ezini($tag, 'ClassDescription', 'content.ini',,true() ), hash() ) }
                "{$tag}": {ldelim}{if $classes|count}{foreach $classes as $class}"{$class}": "{if is_set($descriptions[$class])}{$descriptions[$class]|wash}{/if}"{delimiter},
                {/delimiter}{/foreach}{/if}{rdelim}{delimiter},
                {/delimiter}
            {/foreach}
        {rdelim},
        {undef $descriptions}
        
        soestyle_custom_attributes_per_tag : {ldelim}
            {def $attrs=array()}
            {foreach $all_tags as $tag}
                {set $attrs=cond(ezini_hasvariable($tag, 'CustomAttributes', 'content.ini',,true()  ),
                                    ezini($tag, 'CustomAttributes', 'content.ini',,true()  ), array() ) }
                {if $attrs|contains('fontclass') }
                    {set $tags_with_fontclass=$tags_with_fontclass|append($tag)}
                {/if}
                "{$tag}": "{if $attrs|count}{$attrs|implode(',')}{/if}"{delimiter},
                {/delimiter}
            {/foreach}
            {undef $attrs}
        {rdelim},
        
        soestyle_custom_attribute_style_map : {ldelim}
            {def $style_map=ezini('EditorSettings', 'CustomAttributeStyleMap', 'ezoe.ini',,true()  ) }
            {foreach $style_map as $key => $val}
                "{$key}": "{$val}"{delimiter},{/delimiter}
            {/foreach}
            {undef $style_map}
        {rdelim},
        
        soestyle_font_sizes : {ldelim}
            {def $font_sizes=ezini('sOExtraSettings', 'FontSizes', 'soextra.ini',,true()  ) }
            {if $font_sizes|count}
                    "Default": "",
                {foreach $font_sizes as $key => $val}
                    "{$key}": "{cond($val, $val, '')}"{delimiter},{/delimiter}
                {/foreach}
            {/if}
            {undef $font_sizes}
        {rdelim},
        
        soestyle_class_styles : {ldelim}
            {def $styles=ezini('sOExtraSettings', 'ClassStyles', 'soextra.ini',,true()  ) }
            {foreach $styles as $key => $val}
                "{$key}": "{cond($val, $val, '')}"{delimiter},{/delimiter}
            {/foreach}
            {undef $styles}
        {rdelim},
        
        soestyle_font_classes_per_tag : {ldelim}
            {def $attrs=array()
                 $default_font_classes=cond(ezini_hasvariable('CustomAttribute_fontclass', 'Selection', 'ezoe_attributes.ini',,true()  ),
                                                ezini('CustomAttribute_fontclass', 'Selection', 'ezoe_attributes.ini',,true()  ), array() )
                 $tag_font_classes=array()}
            {foreach $all_tags as $tag}
                
                {set $attrs=cond(ezini_hasvariable(concat('CustomAttribute_', $tag, '_fontclass'), 'Selection', 'ezoe_attributes.ini',,true()  ),
                                    ezini(concat('CustomAttribute_', $tag, '_fontclass'), 'Selection', 'ezoe_attributes.ini',,true() ), $default_font_classes )}
                "{$tag}": {ldelim}{if $tags_with_fontclass|contains($tag) }{foreach $attrs as $k => $v}"{$v}" : "{cond($k, $k, '')}"{delimiter},{/delimiter}{/foreach}{/if}{rdelim}{delimiter},
                {/delimiter}
            {/foreach}
            {undef $attrs}
        {rdelim},
        
        soestyle_custom_create_buttons : {ldelim}
            {def $button_names=cond(ezini_hasvariable('sOExtraSettings', 'CustomCreateButtons', 'soextra.ini',,true()  ),
                                                ezini('sOExtraSettings', 'CustomCreateButtons', 'soextra.ini',,true()  ), array() )
                 $custom_tag=''
                 $is_inline=cond(ezini_hasvariable('CustomTagSettings', 'IsInline', 'content.ini',,true()  ),
                                                ezini('CustomTagSettings', 'IsInline', 'content.ini',,true()  ), hash() ) }
            {foreach $button_names as $name}
                "{$name}": {ldelim}
                    {set $custom_tag=ezini($name, 'CustomTag', 'soextra.ini',,true()  )}
                    customTag: "{$custom_tag}",
                    isInline: "{cond( is_set($is_inline[$custom_tag]), $is_inline[$custom_tag], 'false' ) }",
                    title: "{cond(ezini_hasvariable($name, 'Title', 'soextra.ini',,true()  ),
                                                ezini($name, 'Title', 'soextra.ini',,true() ), concat('Insert ', $custom_tag) ) }",
                    isEmpty: "{cond(ezini_hasvariable($name, 'IsEmpty', 'soextra.ini',,true()  ),
                                                ezini($name, 'IsEmpty', 'soextra.ini',,true() ), 'false' ) }",
                    openDialog: "{cond(ezini_hasvariable($name, 'OpenDialog', 'soextra.ini',,true()  ),
                                                ezini($name, 'OpenDialog', 'soextra.ini',,true() ), 'false' ) }"
                {rdelim}                    
                {delimiter},{/delimiter}
            {/foreach}
        {rdelim},
        
        soestyle_empty_elements : [
            {if ezini_hasvariable('sOExtraSettings', 'EmptyElements', 'soextra.ini',,true() )}
                {foreach ezini('sOExtraSettings', 'EmptyElements', 'soextra.ini',,true() ) as $element }
                    "{$element}"{delimiter},{/delimiter}
                {/foreach}
            {/if}
        ],
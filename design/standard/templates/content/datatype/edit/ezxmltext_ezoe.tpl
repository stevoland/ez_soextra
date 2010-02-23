{default input_handler=$attribute.content.input
         attribute_base='ContentObjectAttribute'
         editorRow=10}
		 
{if gt($attribute.contentclass_attribute.data_int1,1)}
    {set editorRow=$attribute.contentclass_attribute.data_int1}
{/if}

{if $input_handler.is_editor_enabled}
<!-- Start editor -->

    {def $layout_settings = $input_handler.editor_layout_settings}

    {run-once}
    {* code that only run once (common for all xml blocks) *}

    {def $plugin_list = ezini('EditorSettings', 'Plugins', 'ezoe.ini',,true()  )
         $skin        = ezini('EditorSettings', 'Skin', 'ezoe.ini',,true() )
         $skin_variant = ''
         $content_css_list_temp = ezini('StylesheetSettings', 'EditorCSSFileList', 'design.ini',,true())
         $content_css_list = array()
         $editor_css_list  = array( concat('skins/', $skin, '/ui.css') )
         $ez_locale        = ezini( 'RegionalSettings', 'Locale', 'site.ini')
         $language         = '-'|concat( $ez_locale )
         $plugin_js_list   = array( 'ezoe::i18n::'|concat( $language ) )
         $spell_languages = '+English=en'
    }
    {if ezini_hasvariable( 'EditorSettings', 'SkinVariant', 'ezoe.ini',,true() )}
        {set $skin_variant = ezini('EditorSettings', 'SkinVariant', 'ezoe.ini',,true() )}
    {/if}
    {if $attribute.language_code|eq( $ez_locale )}
        {def $cur_locale = fetch( 'content', 'locale' )}
        {set $spell_languages = concat( '+', $cur_locale.intl_language_name, '=', $cur_locale.http_locale_code|explode('-')[0])}
        {undef $cur_locale}
    {else}
        {def $cur_locale = fetch( 'content', 'locale' )
             $atr_locale = fetch( 'content', 'locale', hash( 'locale_code', $attribute.language_code ) )}
        {set $spell_languages = concat( '+', $atr_locale.intl_language_name, '=', $atr_locale.http_locale_code|explode('-')[0])}
        {set $spell_languages = concat( $spell_languages, ',', $cur_locale.intl_language_name, '=', $cur_locale.http_locale_code|explode('-')[0])}
        {undef $cur_locale $atr_locale}
    {/if}

    {if $skin_variant}
        {set $editor_css_list = $editor_css_list|append( concat('skins/', $skin, '/ui_', $skin_variant, '.css') )}
    {/if}
    
    {foreach $content_css_list_temp as $css}
        {set $content_css_list = $content_css_list|append( $css|explode( '<skin>' )|implode( $skin ) )}
    {/foreach}

    {foreach $plugin_list as $plugin}
        {set $plugin_js_list = $plugin_js_list|append( concat( 'plugins/', $plugin|trim, '/editor_plugin.js' ))}
    {/foreach}

    <!-- Load TinyMCE code -->
    <script id="tinymce_script_loader" type="text/javascript" src={"javascript/tiny_mce.js"|ezdesign}></script>
    {ezoescript( $plugin_js_list )}
    <!-- Init TinyMCE script -->
    <script type="text/javascript">
    <!--
    
    if ( window.ez === undefined || ez.version < 0.95 ) document.write('<script type="text/javascript" src={"javascript/ezoe/ez_core.js"|ezdesign}><\/script>');

    var eZOeAttributeSettings, eZOeGlobalSettings = {ldelim}
    
        {if ezini_hasvariable('StylesheetSettings', 'EditorDialogCSSFileList', 'design.ini',,true()  )}
            {set $editor_css_list = $editor_css_list|append( ezini('StylesheetSettings', 'EditorDialogCSSFileList', 'design.ini',,true()  ) )}
        {/if}
    
		{def $tag_list='paragraph,literal,header,table,td,th,strong,emphasize,ol,ul,link,embed,embed-inline'
			 $tags=$tag_list|explode(',')
             $all_tags=$tags|merge(ezini('CustomTagSettings', 'AvailableCustomTags', 'content.ini',,true() ) )
			 $classes=array()
             $tags_with_fontclass = array() }
        
		soestyle_classes_per_tag : {ldelim}
			{foreach $tags as $tag}
				{set $classes=ezini($tag, 'AvailableClasses', 'content.ini',,true() ) }
				"{$tag}": "{$classes|implode(',')}"{delimiter},
				{/delimiter}
			{/foreach}
		{rdelim},
        
        {def $descriptions=hash()}
		soestyle_class_descriptions_per_tag : {ldelim}
			{foreach $tags as $tag}
				{set $classes=ezini($tag, 'AvailableClasses', 'content.ini',,true() )
					 $descriptions=cond( ezini_hasvariable($tag, 'ClassDescription', 'content.ini',,true()  ), ezini($tag, 'ClassDescription', 'content.ini',,true() ), hash() ) }
				"{$tag}": {ldelim}{foreach $classes as $class}"{$class}": "{if is_set($descriptions[$class])}{$descriptions[$class]|wash}{/if}"{delimiter},
				{/delimiter}{/foreach}{rdelim}{delimiter},
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
        
		soestyle_body_classes: "ezcca-{$attribute.contentclassattribute_id} ezcc-{$attribute.object.class_identifier}",
        mode : "none",
        theme : "ez",
        width : '100%',
        language : '{$language}',
        skin : '{$skin}',
        skin_variant : '{$skin_variant}',
        plugins : "-{$plugin_list|implode(',-')}",
        theme_advanced_buttons2 : "",
        theme_advanced_buttons3 : "",
        theme_advanced_blockformats : "p,pre,h1,h2,h3,h4,h5,h6",
        theme_advanced_path_location : "bottom",
        theme_advanced_statusbar_location: "bottom",
        theme_advanced_toolbar_location : "top",
        theme_advanced_toolbar_align : "left",
        theme_advanced_toolbar_floating : true,
        theme_advanced_resize_horizontal : false,
        theme_advanced_resizing : true,
		theme_advanced_more_colors : true,
        valid_elements: "-strong/-b/-bold[class|customattributes],-em/-i/-emphasize[class|customattributes],span[id|type|class|title|customattributes|align],pre[class|title|customattributes],ol[class|customattributes],ul[class|customattributes],li,a[href|name|target|title|class|id|customattributes],p[class|customattributes|align],img[src|class|alt|align|inline|id|customattributes],table[class|border|width|id|title|customattributes|ezborder|bordercolor|align],tr,th[class|width|rowspan|colspan|customattributes|align],td[class|width|rowspan|colspan|customattributes|align],div[id|type|class|title|customattributes|align],h1[class|customattributes|align],h2[class|customattributes|align],h3[class|customattributes|align],h4[class|customattributes|align],h5[class|customattributes|align],h6[class|customattributes|align],br",
        valid_child_elements: "a[%itrans_na],table[tr],tr[td|th],h1/h2/h3/h4/h5/h6/pre/strong/b/p/em/i/u/span[%itrans|#text]div/pre/td/th[%btrans|%itrans|#text]",
        cleanup : false,
        cleanup_serializer : 'xml',    
        entity_encoding : 'raw',
        remove_linebreaks : false,
        apply_source_formatting : false,
        fix_list_elements : true,
        fix_table_elements : true,
        convert_urls : false,
        inline_styles : false,
        tab_focus : ':prev,:next',
        theme_ez_xml_alias_list : {$input_handler.json_xml_tag_alias},
        theme_ez_editor_css : '{ezoecss( $editor_css_list, false() )|implode(',')}',
        theme_ez_content_css : '{ezoecss( $content_css_list, false())|implode(',')}',
        theme_ez_statusbar_open_dialog : {cond( ezini('EditorSettings', 'TagPathOpenDialog', 'ezoe.ini',,true())|eq('enabled'), 'true', 'false' )},
        popup_css : {concat("stylesheets/skins/", $skin, "/dialog.css")|ezdesign},
        //save_callback : "eZOeCleanUpEmbedTags",
        gecko_spellcheck : true,
        table_inline_editing : true, // table edit controlls in gecko
        save_enablewhendirty : true,
        ez_root_url : {'/'|ezroot},
        ez_extension_url : {'/ezoe/'|ezurl},
        ez_js_url : {'/extension/ezoe/design/standard/javascript/'|ezroot},
        ez_contentobject_id : {$attribute.contentobject_id},
        ez_contentobject_version : {$attribute.version},
        spellchecker_rpc_url : {'/ezoe/spellcheck_rpc'|ezurl},
        spellchecker_languages : '{$spell_languages}'
    {rdelim};
    
    {literal}

    // make sure TinyMCE doesn't try to load language pack
    // and set urls for plugins so their dialogs work correctly
    (function(){
        var uri = document.getElementById('tinymce_script_loader').src, tps = eZOeGlobalSettings.plugins.split(','), pm = tinymce.PluginManager, tp;
        tinymce.ScriptLoader.markDone( uri.replace( 'tiny_mce', 'langs/' + eZOeGlobalSettings.language ) );
        for (var i = 0, l = tps.length; i < l; i++)
        {
            tp = tps[i].slice(1);
            pm.urls[ tp ] = uri.replace( 'tiny_mce.js', 'plugins/' + tp );
        }
    }())

    tinyMCE.init( eZOeGlobalSettings );

    function eZOeToggleEditor( id, settings )
    {
        var el = document.getElementById( id );
        if ( el )
        {
            if ( tinyMCE.getInstanceById( id ) == null )
                //tinyMCE.execCommand('mceAddControl', false, id);
                new tinymce.Editor(id, settings).render();
            else
                tinyMCE.execCommand( 'mceRemoveControl', false, id );
        }
    }

    function eZOeCleanUpEmbedTags( element_id, html, body )
    {
        // remove the content of the embed tags that are just there for oe preview
        // purpose, this is to avoid that the ez xml parsers in some cases 
        // duplicates the embed tag
        ez.array.forEach( body.getElementsByTagName('div'), function( node ){
            if ( node && node.className.indexOf('mceNonEditable') !== -1 )
                node.innerHTML = '';
        });
        ez.array.forEach( body.getElementsByTagName('span'), function( node ){
            if ( node && node.className.indexOf('mceNonEditable') !== -1 )
                node.innerHTML = '';
        });

        // fix link cleanup issues in IE 6 / 7 (it adds the current url before the anchor and invalid urls)
        var currenthost = document.location.protocol + '//' + document.location.host;
        ez.array.forEach( body.getElementsByTagName('a'), function( node ){
            if ( node.href.indexOf( currenthost ) === 0 && node.getAttribute('mce_href') != node.href )
                node.href = node.getAttribute('mce_href');
        });
        return body.innerHTML;
    }


    {/literal}
    //-->
    </script>
    {/run-once}
    
    
    
    <div class="oe-window">
        <textarea class="box" id="{$attribute_base}_data_text_{$attribute.id}" name="{$attribute_base}_data_text_{$attribute.id}" cols="88" rows="{$editorRow}">{$input_handler.input_xml}</textarea>
    </div>
    
    <div class="block">
        <input class="button{if $layout_settings['buttons']|contains('disable')} hide{/if}" type="submit" name="CustomActionButton[{$attribute.id}_disable_editor]" value="{'Disable editor'|i18n('design/standard/content/datatype')}" />
        <script type="text/javascript">
        <!--
        
        eZOeAttributeSettings = eZOeGlobalSettings;
        eZOeAttributeSettings['ez_attribute_id'] = {$attribute.id};
        eZOeAttributeSettings['theme_advanced_buttons1'] = "{$layout_settings['buttons']|implode(',')}";
        eZOeAttributeSettings['theme_advanced_path_location'] = "{$layout_settings['path_location']}";
        eZOeAttributeSettings['theme_advanced_statusbar_location'] = "{$layout_settings['path_location']}";
        eZOeAttributeSettings['theme_advanced_toolbar_location'] = "{$layout_settings['toolbar_location']}";

        eZOeToggleEditor( '{$attribute_base}_data_text_{$attribute.id}', eZOeAttributeSettings );

        //-->
        </script>
    </div>
<!-- End editor -->
{else}
    {let aliased_handler=$input_handler.aliased_handler}
    {include uri=concat("design:content/datatype/edit/",$aliased_handler.edit_template_name,".tpl") input_handler=$aliased_handler}
    <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_enable_editor]" value="{'Enable editor'|i18n('design/standard/content/datatype')}" /><br />
    {/let}
{/if}
{/default}

/* 
 * 
 */

(function() {
	var each = tinymce.each;
		

	tinymce.create('tinymce.plugins.sOExtra', {
		init : function(ed, url) {
			var t = this;

			t.editor = ed;
			t.url = url;
			t.classesPerTag = {};
			t.classStyles = ed.getParam('soestyle_class_styles', '', 'hash');
			t.attributesPerTag = ed.getParam('soestyle_custom_attributes_per_tag', '', 'hash');
			t.descriptionsPerTag = ed.getParam('soestyle_class_descriptions_per_tag', '', 'hash');
			t.fontSizes = ed.getParam('soestyle_font_sizes', '', 'hash');
			t.fontClassesPerTag = ed.getParam('soestyle_font_classes_per_tag', '', 'hash');
			t.customCreateButtonData = ed.getParam('soestyle_custom_create_buttons', '', 'hash');
			t.customCreateButtons = {};
			t.classSelect;
			t.classSelectAncestors = [];
			t.fontClassSelectAncestors = [];
			t.prevNode;
			t.styleMap = ed.getParam('soestyle_custom_attribute_style_map', '', 'hash');
			t.foreColorNode;
			t.backColorNode;
			t.fontSizeNode;
			t.fontClassNode;
			t.foreColorControl;
			t.backColorControl;
			t.fontSizeControl;
			t.foreColor;
			t.backColor;
			t.currentNode;
			t.numAncestorsWithFontClasses = 0;
			t.numAncestorsWithClasses = 0;
			t.firstUIupdate = true;
			
			//console.info(t.customCreateButtonData);

			// Register buttons
			each([
				['soextra_classselect', 'ezstyle.desc', 'mceeZStyle'],
				['soextra_class', 'ezstyle.desc', 'soextra_class'],
				['soextra_fontsize', 'soextra_fontsize.desc', 'soextra_fontsize'],
				['soextra_fontclass', 'soextra_fontclass.desc', 'soextra_fontclass'],
				['soextra_forecolor', 'textcolor.desc', 'mceTextColor'],
				['soextra_backcolor', 'backcolor.desc', 'mceBackColor']
			], function(c) {
				ed.addButton(c[0], {title : c[1], cmd : c[2], ui : c[3]});
			})
			ed.onNodeChange.add(t._nodeChanged, t);
			ed.onSaveContent.add(t._submitHandler, t);
			ed.onLoadContent.add(t._pageInitHandler, t);
			
			
			// add classes to editor content body (default "ezcca-[contentclass_attribute_id] ezcc-[contentclass_identifier]")
			ed.onLoadContent.add(function() {
				var classes = ed.getParam('soestyle_body_classes'),
					body = ed.dom.select('body');
				if ( !!classes )
					ed.dom.addClass(body, classes);
			});
		},

        _pageInitHandler : function(ed)
		{
			var t = this,
				imgs = ed.dom.select('img');
			each(imgs, function(img) {
				var w = t._getCustomAttribute(img, 'attr_width'),
					h = t._getCustomAttribute(img, 'attr_height');
				if ( !!w  )
					ed.dom.setAttrib(img, 'width', w);
				if ( !!h  )
					ed.dom.setAttrib(img, 'height', h);
			});
		},

        _submitHandler : function(ed, o)
		{
			var t = this,
				imgs = t.editor.dom.select('img');
			
			each(imgs, function(img) {
				var inEmbed = false;
				if ( ed.dom.hasClass(img, 'soextra_resizable' ) )
				{
					var ancestors = t.editor.dom.getParents(img, '*');
						
					each(ancestors, function(n){
						var xmlName = t.editor.theme.__tagsToXml(n);
						if ( xmlName == "embed" || xmlName == "embed-inline" )
						{
							t._updateCustomAttribute(n, 'attr_height', ed.dom.getAttrib(img, 'height'), false);
							t._updateCustomAttribute(n, 'attr_width', ed.dom.getAttrib(img, 'width'), false);
							inEmbed = true;
							
							return;
						}
					});
				}
				if ( !inEmbed )
				{
					t._updateCustomAttribute(img, 'attr_height', ed.dom.getAttrib(img, 'height'), false);
					t._updateCustomAttribute(img, 'attr_width', ed.dom.getAttrib(img, 'width'), false);
				}
				
			});
			
			var h = eZOeCleanUpEmbedTags(ed.id, o.content, ed.getBody());

			if (h)
				o.content = h;
		},
		
		_nodeChanged : function(ed, cm, n, co) {
            var t = this, s = t.editor.settings;

            if (s.readonly)
                return;
			
			if ( t.prevNode != n )
			{
				if ( !!t.foreColorControl || !!t.backColorControl || !!t.classSelect || !!t.fontSizeControl )
				{
					t._updateUI(n, ed, cm);
				}
				t.prevNode = n;
			}
			
		},
		
		
		_updateUI : function(n, ed, cm) {
			var t = this, s = t.editor.settings, theme = t.editor.theme;
			
			// get rid of old menu
			if ( !!t.classSelect )
			{
				/*t.classSelect.selectByIndex(-1);
				t.classSelect.oldID = null;
			
				if ( t.classSelect.items.length >= 1 && t.classSelect.menu )
				{
					t.classSelect.menu.remove(t.classSelect.items[0]);
				}
				t.classSelect.items = [];*/
				t.classSelectAncestors = [];
			}
			if ( !!t.fontClassControl )
			{
				t.fontClassSelectAncestors = [];
			}
			t.foreColorNode = null;
			t.backColorNode = null;
			t.fontSizeNode = null;
			t.fontClassNode = null;
			
			// get available classes
			var ancestors = t.editor.dom.getParents(n, '*'),
				currentNode = ancestors[0],
				usedTags = [],
				index = 0,
				inEmbed = false,
				inEmptyCustom = false;
			
			t.currentNode = currentNode;
			t.numAncestorsWithFontClasses = 0;
			t.numAncestorsWithClasses = 0;
			
			each(ancestors, function(n){
				var xmlName = theme.__tagsToXml(n);
				if ( inEmbed )
					return;
				if ( xmlName == "embed" || xmlName == "embed-inline"  )
				{
					inEmbed = true;
					return;
				}
				if ( xmlName == "literal" )
				{
					t.classSelectAncestors = [];
					t.fontClassSelectAncestors = [];
				}
				else if ( xmlName == "custom" )
				{
					xmlName = theme.__getTagCommand(n).val;
					if ( n.nodeName == 'IMG' )
						inEmptyCustom = true;
				}
				
				if ( tinymce.inArray(usedTags, xmlName) == -1 )
				{
					if ( !!t.foreColorControl && !t.foreColorNode && !!t.attributesPerTag[xmlName] && t.attributesPerTag[xmlName].indexOf('forecolor') >= 0 )
					{
						t.foreColorNode = n;
					}
					if ( !!t.backColorControl && !t.backColorNode && !!t.attributesPerTag[xmlName] && t.attributesPerTag[xmlName].indexOf('backcolor') >= 0 )
					{
						t.backColorNode = n;
					}
					if ( !!t.fontSizeControl && !t.fontSizeNode && !!t.attributesPerTag[xmlName] && t.attributesPerTag[xmlName].indexOf('fontsize') >= 0 )
					{
						t.fontSizeNode = n;
					}
					if ( !!t.fontClassControl && !t.fontClassNode && !!t.attributesPerTag[xmlName] && t.attributesPerTag[xmlName].indexOf('fontclass') >= 0 )
					{
						t.fontClassNode = n;
					}
				
					var first = true,
						title = ( s.theme_ez_xml_alias_list && s.theme_ez_xml_alias_list[xmlName] !== undefined )
									? s.theme_ez_xml_alias_list[xmlName] : xmlName;
					each(t.classesPerTag[xmlName], function(v) {
						if ( first )
						{
							t.classSelectAncestors.push({node:n, val:'', title:'Default', xmlName:xmlName});
							t.numAncestorsWithClasses++;
							first = false;
						}
						t.classSelectAncestors.push({node:n, val:v, title:title, xmlName:xmlName});
					});
					
					first = true;					
					each(t.fontClassesPerTag[xmlName], function(k, v) {
						t.fontClassSelectAncestors.push({node:n, title:v, value:k, xmlName:xmlName});
						if ( first )
						{
							t.numAncestorsWithFontClasses++;
							first = false;
						}
					});
					usedTags.push(xmlName);
				}
			});
			
			each(t.customCreateButtons, function(c){
				c.setDisabled( ( inEmbed || inEmptyCustom ) );
			});
			
			if ( !!t.classSelect )
			{
				if ( inEmbed )
				{
					t.classSelectAncestors = [];
				}
					
				t.classSelect.setDisabled( !t.classSelectAncestors.length );
				
				function updateClassMenu(c, m) {
					if ( !m )
						m = c.menu;
					each(m.items, function(item){
						item.remove();
					});
					m.add({title : 'Style', 'class' : 'mceMenuItemTitle'}).setDisabled(1);
					
					each(t.classSelectAncestors, function(item){
						var title = 'Default',
							val = '';
						if ( item.val != '' )
						{
							var val = ( t.descriptionsPerTag[item.xmlName] && t.descriptionsPerTag[item.xmlName][item.val] ) ?
								t.descriptionsPerTag[item.xmlName][item.val] : item.val;
							var title = ( item.node == t.currentNode && t.numAncestorsWithClasses == 1 ) ? '' : item.title + ': ';
						}
						
						var o = {icon : 1}, mi;
						o.onclick = function() {
							if ( ed.dom.getAttrib(item.node, 'class') == item.val )
							{
								ed.dom.setAttrib(item.node, 'class', '');
							}
							else
							{
								ed.dom.setAttrib(item.node, 'class', item.val);
							}
						};
						//if ( !!t.classStyles[item.value] )
						//	item.title = '<span style=\'display:inline;' + t.classStyles[item.value] + '\'>' + item.title + '<span>';
						o.title = title + val;
						mi = m.add(o);
						
						//index++;
					});
					
				};
				
				if ( !t.classSelect.isMenuRendered )
				{
					if ( t.firstUIupdate )
					{
						t.classSelect.onRenderMenu.add(updateClassMenu);
						t.classSelect.renderMenu();
					}
				}
				else 
				{
					updateClassMenu(t.classSelect);
				}
				
			}
			
			if ( !!t.fontClassControl )
			{
				if ( inEmbed )
					t.fontClassSelectAncestors = [];
					
				t.fontClassControl.setDisabled( !t.fontClassSelectAncestors.length );
				
				function updateFontClassMenu(c, m) {
					//m.removeAll();
					each(m.items, function(item){
						item.remove();
					});
					m.add({title : 'Font family', 'class' : 'mceMenuItemTitle'}).setDisabled(1);
					
					each(t.fontClassSelectAncestors, function(item){
						var title = ( item.node == t.currentNode && t.numAncestorsWithFontClasses == 1 ) ? '' : item.xmlName + ': ';					
						
						var o = {icon : 1}, mi;
						o.onclick = function() {
							var on = t._updateCustomAttribute(item.node, 'fontclass', item.value);
							mi.setSelected(on ? 1 : 0);
							each(t.fontClassSelectAncestors, function(otherItem){
								if ( otherItem.node == item.node && otherItem.mi != mi )
									otherItem.mi.setSelected(0);
							})
						};
						if ( !!t.classStyles[item.value] )
							o.style = 'display:inline;' + t.classStyles[item.value];
						o.title = title + item.title;
						o.node = item.node;
						mi = m.add(o);
						item.mi = mi;
						if ( t._getCustomAttribute(item.node, 'fontclass') == item.value )
						{
							mi.setSelected(1);
						}
					});
				}
				if ( !t.fontClassControl.isMenuRendered )
				{
					if ( t.firstUIupdate )
						t.fontClassControl.onRenderMenu.add(updateFontClassMenu);
				}
				else 
				{
					updateFontClassMenu(t.fontClassControl, t.fontClassControl.menu);
				}
			}
			
			if ( t.foreColorControl )
			{
				t.foreColorControl.setDisabled( !t.foreColorNode );
				var color = t._getCustomAttribute(t.foreColorNode, 'forecolor') || '#000000';
				if ( color != t.foreColor )
				{
					t.foreColor = color;
					tinymce.DOM.setStyle(t.foreColorControl.id + '_preview', 'background', color);
					
				}
			}
			if ( t.backColorControl )
			{
				t.backColorControl.setDisabled( !t.backColorNode );
				var color = t._getCustomAttribute(t.backColorNode, 'backcolor') || '#ffffff';
				if ( color != t.backColor )
				{
					t.backColor = color;
					tinymce.DOM.setStyle(t.backColorControl.id + '_preview', 'background', color);
					
				}
			}
			if ( t.fontSizeControl )
			{
				t.fontSizeControl.setDisabled( !t.fontSizeNode );
				if ( !!t.fontSizeNode && !!t.fontSizeControl.menu )
				{
					t.updateFontSizeMenu();
				}
			}
				
			t.firstUIupdate = false;
		},
		
		updateFontSizeMenu: function()
		{
			var t = this,
				fontSize = t._getCustomAttribute(t.fontSizeNode, 'fontsize'),
				i=0,
				selectedIndex;
			each(t.fontSizes, function(k, v){
				if ( k == fontSize )
					selectedIndex = i;
				i++;
			});
			
			if ( !!t.fontSizeControl.menu.items )
			{
				i = 0;
				each(t.fontSizeControl.menu.items, function(mi){
					mi.setSelected( ( i == selectedIndex + 1 ) ? 1 : 0 );
					i++;
				});
			}
		},
		
		createControl : function(n, cm)
        {
			switch (n) {
                case "soextra_classselect":
                    return this._createClassSelect();
				case "soextra_forecolor":
                    return this._createTextColorMenu();
                case "soextra_backcolor":
                    return this._createBackColorMenu();
				case "soextra_fontsize":
					return this._createFontSizeMenu(n);
				case "soextra_fontclass":
					return this._createFontClassMenu(n);
				case "soextra_class":
					return this._createClassMenu(n);
				default:
					if ( !!this.customCreateButtonData[n] )
					{
						return  this._createCustomTagMenu(n);
					}
			}
        },
        
        _insertHTMLCleanly: function( ed, html, id )
	    {
	        // makes sure block nodes do not break the html structure they are inserted into
	        var paragraphCleanup = false;
	        if ( html.indexOf( '<div' ) === 0 || html.indexOf( '<pre' ) === 0 )
	        {
	            var edCurrentNode = ed.selection.getNode();
	            if ( edCurrentNode && edCurrentNode.nodeName.toLowerCase() === 'p' )
	            {
	                paragraphCleanup = true;
	            }
	        }
	        ed.execCommand('mceInsertRawHTML', false, html, {skip_undo : 1} );
			
        	var emptyContent = [ '', '<br>', '<BR>', '&nbsp;', ' ', " " ],
        		el = ed.dom.get( id );
	        if ( paragraphCleanup )
	        {
		        // cleanup broken paragraphs after inserting block tags into paragraphs
		        if ( el.previousSibling
		             && el.previousSibling.nodeName.toLowerCase() === 'p'
		             && ( !el.previousSibling.hasChildNodes() || jQuery.inArray( el.previousSibling.innerHTML, emptyContent ) !== -1 ))
		        {
		                el.parentNode.removeChild( el.previousSibling );
		        }
		        if ( el.nextSibling
		                && el.nextSibling.nodeName.toLowerCase() === 'p'
		                && ( !el.nextSibling.hasChildNodes() || jQuery.inArray( el.nextSibling.innerHTML, emptyContent ) !== -1 ))
		       {
		                el.parentNode.removeChild( el.nextSibling );
		       }
	        }
	        
	        return el;
	    },
        
        _insertCustomTag : function(data) {
        	var t = this,
				ed = t.editor,
				editorSelectedText = false,
				editorSelectedHtml = false,
				selectedHtml = ed.selection.getContent( {format:'text'} ),
				tagHtml = '',
				customTag = data.customTag,
				imageSrc = 'extension/_soextra/design/standard/images/blank.gif';
			
			if ( !!window._ez && !!_ez._root_url ) {
				imageSrc = _ez._root_url + imageSrc;
			} else {
				imageSrc = '/' + imageSrc;
			}
				
            if ( !/\n/.test( selectedHtml ) && jQuery.trim( selectedHtml ) !== '' )
                editorSelectedText = selectedHtml;

            selectedHtml = ed.selection.getContent( {format:'html'} );
            if ( jQuery.trim( selectedHtml ) !== '' )
                editorSelectedHtml = selectedHtml;
            
            if ( !editorSelectedHtml ) editorSelectedHtml = customTag;
            

	        if ( customTag === 'underline' )
	        {
	            tagHtml = '<u id="__mce_tmp" type="custom" class="mceItemCustomTag ' + customTag + '">' + editorSelectedHtml + '<\/u>';
	        }
	        else if ( customTag === 'sub' || customTag === 'sup' )
	        {
	            tagHtml = '<' + customTag + ' id="__mce_tmp" type="custom" class="mceItemCustomTag ' + customTag + '">' + editorSelectedHtml + '<\/' + customTag + '>';
	        }
	        else if ( data.isInline == 'true' || data.isInline == 'image' )
	        {
	            if ( data.isInline == 'image' )
	            {
	                //var customImgUrl = document.getElementById( customTag + '_image_url_source' ), imageSrc = imageIcon;
	                //if ( customImgUrl && customImgUrl.value )
	                //    imageSrc = customImgUrl.value;
	                tagHtml = '<img id="__mce_tmp" type="custom" src="' + imageSrc + '" class="mceItemCustomTag ' + customTag + '"" />';
	            }
	            else
	                tagHtml = '<span id="__mce_tmp" type="custom" class="mceItemCustomTag ' + customTag + '">' + editorSelectedHtml + '<\/span>';
	        }
	        else
	        {
	            tagHtml = '<div id="__mce_tmp" type="custom" class="' + customTag + ' mceItemCustomTag"><p>' + editorSelectedHtml + '<\/p><\/div>';
	        }
        	
        	var newNode = t._insertHTMLCleanly( ed, tagHtml, '__mce_tmp' );
        	newNode.id = '';
        	
        	newNode.setAttribute('id', null);
        	
        	// append a paragraph if user just inserted a custom tag in editor and it's the last tag
	        var edBody = newNode.parentNode, doc = ed.getDoc(), temp = newNode;
	        if ( edBody.nodeName.toLowerCase() !== 'body' )
	        {
	            temp = edBody;
	            edBody = edBody.parentNode
	        }
	        if ( edBody.nodeName.toLowerCase() === 'body'
	        && edBody.childNodes.length <= (jQuery.inArray( temp, edBody.childNodes ) +1) )
	        {
	            var p = doc.createElement('p');
	            p.innerHTML = ed.isIE ? '&nbsp;' : '<br \/>';
	            edBody.appendChild( p );
	        }
            return newNode;
        },
        
        _arrayIndexOf: function( arr, o, s ) {
            // javascript 1.6: finds the first index that is like object o, s is optional start index
            for (var i=s || 0, l = arr.length; i < l; i++) if (arr[i]===o) return i;
            return -1;
        },
        
        _createCustomTagMenu : function(n) {
        	var t = this;
			var ed = t.editor;
			var c = ed.controlManager.createButton(n, {title : t.customCreateButtonData[n].title, ezPlugin: true, scope : t});
			
			c.settings.onclick = function() {
				var data = t.customCreateButtonData[n];
					
					
				//console.info(this);
				
				if ( data.openDialog == 'enabled' )
				{
					ed.execCommand( 'mceCustom', null, data.customTag );
				}
				else
				{
					var newNode = t._insertCustomTag(data);
					ed.dom.setAttrib(newNode, 'id', '');
				}
			}
			
			//console.info(c);
			
			t.customCreateButtons[n] = c;
			return c;
        },
		
		_createFontSizeMenu : function(n, cm) {
			var t = this;
			var ed = t.editor;
			var c = ed.controlManager.createSplitButton(n, {title : 'Font size', ezPlugin: true, cmd : 'soeXtraFontSize', scope : t});

			c.onRenderMenu.add(function(c, m) {
				m.removeAll();
				m.add({title : 'Font size', 'class' : 'mceMenuItemTitle'}).setDisabled(1);
				each(t.fontSizes, function(k, v) {
					var o = {icon : 1}, mi;

					o.onclick = function() {
						t._updateCustomAttribute(t.fontSizeNode, 'fontsize', k);
						each(m.items, function(item){
							item.setSelected( (item == mi) ? 1 : 0);
						});
					};

					o.title = v;
					mi = m.add(o);
				});
				if ( !!t.fontSizeNode && !!t.fontSizeControl.menu )
					t.updateFontSizeMenu.apply(t);
			});
			
			t.fontSizeControl = c;

			return c;
		},
		
		_createFontClassMenu : function(n, cm) {
			var t = this;
			var ed = t.editor;
			var c = ed.controlManager.createSplitButton(n, {title : 'Font family', ezPlugin: true, cmd : 'soeXtraFontClass', scope : t});

			
			
			t.fontClassControl = c;

			return c;
		},
		
		_createClassMenu : function(n, cm) {
			var t = this;
			var ed = t.editor;
			var c = ed.controlManager.createSplitButton(n, {title : 'Style', ezPlugin: true, cmd : 'soeXtraClass', scope : t});
			
			each(ed.getParam('soestyle_classes_per_tag', '', 'hash'), function(v, k) {
                if (v)
				{
					var vals = v.split(',');
					t.classesPerTag[k] = [];
					each(vals, function(v){
						if ( ',xCenter,xLeft,xRight,xJustify,'.indexOf(v) < 0 )
							t.classesPerTag[k].push(v);
					})
				}
            });
                
			t.classSelect = c;

			return c;
		},
		
		_createClassSelect : function(n) {
            var t = this, ed = t.editor, cf = ed.controlManager, c = cf.createListBox('classselect', {
                title : 'Class',
                onselect : function(v) {
					if ( v !== '' )
					{
						var node = t.classSelectAncestors[v].node,
							val = t.classSelectAncestors[v].val;
						if ( ed.dom.getAttrib(node, 'class') == val )
						{
							ed.dom.setAttrib(node, 'class', '');
						}
						else
						{
							ed.dom.setAttrib(node, 'class', val);
						}
					}
					c.selectByIndex(-1);
                }
            });
			
			

            if ( c ) {
				c.settings.ezPlugin = true;
                each(ed.getParam('soestyle_classes_per_tag', '', 'hash'), function(v, k) {
                    if (v)
					{
						var vals = v.split(',');
						t.classesPerTag[k] = [];
						each(vals, function(v){
							if ( ',xCenter,xLeft,xRight,xJustify,'.indexOf(v) < 0 )
								t.classesPerTag[k].push(v);
						})
					}
                });
            }
			t.classSelect = c;

            return c;
        },
		
		_createTextColorMenu : function() {
            var c, t = this, s = t.editor.settings, o = {}, v;

            if (s.theme_advanced_more_colors) {
                o.more_colors_func = function() {
                    t.editor.theme._mceColorPicker(0, {
                        color : c.value,
                        func : function(co) {
                            c.setColor(co);
                        }
                    });
                };
            }

            o.default_color = '';
			o.ezPlugin = true;
            o.title = 'Font colour';
            o.cmd = 'ForeColor';
            o.scope = this;
			o.colors ='000000,993300,333300,003300,003366,000080,333399,,800000,FF6600,808000,008000,008080,0000FF,666699,808080,FF0000,FF9900,99CC00,339966,33CCCC,3366FF,800080,999999,FF00FF,FFCC00,FFFF00,00FF00,00FFFF,00CCFF,993366,C0C0C0,FF99CC,FFCC99,FFFF99,CCFFCC,CCFFFF,99CCFF,CC99FF,FFFFFF';

            if (v = s.theme_advanced_text_colors)
                o.colors = v;

            t.foreColorControl = c = t.editor.controlManager.createColorSplitButton('forecolor', o);

            return c;
        },
		
		_createBackColorMenu : function() {
            var c, t = this, s = t.editor.settings, o = {}, v;

            if (s.theme_advanced_more_colors) {
                o.more_colors_func = function() {
                    t.editor.theme._mceColorPicker(0, {
                        color : c.value,
                        func : function(co) {
                            c.setColor(co);
                        }
                    });
                };
            }
			
            o.title = 'Background colour';
			o.ezPlugin = true;
            o.cmd = 'HiliteColor';
            o.scope = this;
			o.colors ='000000,993300,333300,003300,003366,000080,333399,,800000,FF6600,808000,008000,008080,0000FF,666699,808080,FF0000,FF9900,99CC00,339966,33CCCC,3366FF,800080,999999,FF00FF,FFCC00,FFFF00,00FF00,00FFFF,00CCFF,993366,C0C0C0,FF99CC,FFCC99,FFFF99,CCFFCC,CCFFFF,99CCFF,CC99FF,FFFFFF';

            if (v = s.theme_advanced_back_colors)
                o.colors = v;

            t.backColorControl = c = t.editor.controlManager.createColorSplitButton('backcolor', o);

            return c;
        },

		execCommand : function(cmd, ui, val) {
			var ed = this.editor, b;
			
			switch (cmd) {
				case "mceTextColor":
					this._mceTextColor();
					return true;
				case "ForeColor":
					this.ForeColor(ui, val);
					return true;
				case "HiliteColor":
					this.BackColor(ui, val);
					return true;
			}

			// Pass to next handler in chain
			return false;
		},
		
		ForeColor : function(ui, v)
		{
			var t = this, e = t.editor;
			var n = e.selection.getNode();
			if ( v == '#' )
				v = '';
			this._updateCustomAttribute(n, 'forecolor', v);
		},
		
		BackColor : function(ui, v)
		{
			var t = this, e = t.editor;
			var n = e.selection.getNode();
			if ( v == '#' )
				v = '';
			this._updateCustomAttribute(n, 'backcolor', v);
		},
		
		_getCustomAttribute : function(n, aname)
		{
			if ( !n || !aname )
				return false;
			
			var t = this, e = t.editor,
				attr_string = e.dom.getAttrib(n, 'customattributes'),
				attrs = attr_string.split('attribute_separation');
			
			for ( var i=0; i<attrs.length; i++ )
			{
				pair = attrs[i].split('|');
				if ( pair[0] == aname )
				{
					return pair[1] || '';
				}
			}
			
			return '';
		},
		
		_updateCustomAttribute : function(n, aname, v, toggleValue)
		{
			var t = this,
				e = t.editor,
				styleName = t.styleMap[aname],
				attr_string = e.dom.getAttrib(n, 'customattributes'),
				attrs = attr_string.split('attribute_separation'),
				done = false,
				pair,
				cancel = false;
			
			for ( var i=0; i<attrs.length; i++ )
			{
				pair = attrs[i].split('|');
				if ( pair[0] == aname )
				{
					if ( pair[1] == v & toggleValue !== false )
					{
						attrs[i] = pair[0] + '|';
						cancel = true;
					}
					else
					{
						attrs[i] = pair[0] + '|' + v;
					}
					done = true;
					break;
				}
			}
			
			if ( !done )
			{
				attrs.push(aname + '|' + v);
			}
			
			if ( styleName )
			{
				if ( cancel )
					e.dom.setStyle(n, styleName, '');
				else
					e.dom.setStyle(n, styleName, v);
			}
			
			attr_string = attrs.join('attribute_separation');
			e.dom.setAttrib(n, 'customattributes', attr_string);
			
			return !cancel;
		},
		

		getInfo : function() {
			return {
				longname : 'sOExtra (eZ Online Editor plugin)',
				author : 'STEVOLAND LTD',
				authorurl : 'http://www.stevoland.com',
				infourl : 'http://www.stevoland.com',
				version : tinymce.majorVersion + "." + tinymce.minorVersion
			};
		}

		// Private plugin internal methods
		/*_mceTextColor : function() {
            var t = this;
            this._mceColorPicker(0, {
                color: t.fgColor,
                func : function(co) {
                    t.editor.fgColor = co;
                    t.editor.execCommand('ForeColor', false, co);
                }
            });
        },

        _mceBgColor : function() {
            var t = this;

            this._mceColorPicker(0, {
                color: t.bgColor,
                func : function(co) {
                    t.editor.bgColor = co;
                    t.editor.execCommand('HiliteColor', false, co);
                }
            });
        },
		
		_mceColorPicker : function(ui, v) {
            var ed = this.editor;

            v = v || {};

            ed.windowManager.open({
                url : tinymce.baseURL + '/themes/ez/color_picker.htm',
                width : 375 + parseInt(ed.getLang('ez.colorpicker_delta_width', 0)),
                height : 250 + parseInt(ed.getLang('ez.colorpicker_delta_height', 0)),
                close_previous : false,
                inline : true
            }, {
                input_color : v.color,
                func : v.func,
                theme_url : this.url
            });
        }*/
	});

	// Register plugin
	tinymce.PluginManager.add('soextra', tinymce.plugins.sOExtra);
})();
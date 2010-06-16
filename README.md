# sOExtra #

If you worship at the altar of the separation of style and content then this extension isn't for you.
But if you've got a fussy client who doesn't understand why he can't make some text red then this might be of interest.

This is a collection of enhancements to the eZ Online Editor. They range from simple usability improvements to slightly mad hacks.
They were developed for a specfic client who thankfully is enamoured of Macs therefore Internet Explorer 7+ compatability is not
guaranteed and IE6 is never going to happen. In fact they haven't been tested much in anything other than Firefox 3.6.

I won't have much time for support and updates will be sporadic. Bug reports and (better!) contributors welcome.

Expert consultation available.


## Basic Installation ##

1. Clone or download the required branch ( oe5.0.4 for ez4.2, oe5.1.0 for ez4.3 ) to extension/_soextra
2. Activate the extension manually or through the admin.
3. Edit site.ini.append.php and move ActiveExtensions[]=_soextra to ABOVE ActiveExtensions[]=ezoe
4. The ezoe.ini.append.php and ezoe_attribute.ini.append.php files in _soextra must override those in ezoe. Because ezoe comes with
ezoe.ini and ezoe_attribute.ini these will override .ini.append.php in extensions. Either move these the ezoe .ini files to your siteaccess or
move the _soextra .ini.append.php files to settings/override.
4. Follow the instructions for the features you want
5. settings/content.ini.append.php.EXAMPLE and settings/ezoe.ini.append.php.EXAMPLE contain a setup with full functionality

Styling in the editor is done by configuring a file like this:

	#design.ini
	[StylesheetSettings]
	EditorCSSFileList[]=ezoe_content.css
	EditorDialogCSSFileList[]=ezoe_dialog.css
	


## Features ##

### Class select control ###

A dropdown box to select a class for a tag under the cursor.

	#content.ini:
	[paragraph]
	AvailableClasses[]=pRed
	AvailableClasses[]=pBlue
	ClassDescription[pRed]=Red paragraph
	ClassDescription[pBlue]=Bluey para
	

	#ezoe.ini:
	[EditorLayout]
	Buttons[]=soextra_class
	

	#ezoe_content.css:
	paragraph.pRed {color:#f00;}
	#...


---

### Style controls ###

Controls to select *font family*, *size*, *colour* and *background colour* configurable per tag.
The controls are enabled when a tag under the cursor can have the appropriate CustomAttribute.

Requires the following patch of ezoe:
	patch/ezoe-5.x.x/extension/ezoe/ezxmltext/handlers/input/ezoexmlinput.php > extension/ezoe/ezxmltext/handlers/input/ezoexmlinput.php

	#ezoe.ini:
	[EditorLayout]
	Buttons[]=soextra_fontclass
	Buttons[]=soextra_fontsize
	Buttons[]=soextra_forecolor
	Buttons[]=soextra_backcolor

	#content.ini:
	[paragraph]
	CustomAttributes[]=fontsize
	CustomAttributes[]=fontclass
	CustomAttributes[]=forecolor
	CustomAttributes[]=backcolor

	#ezoe_attribute.ini
	[CustomAttribute_fontclass]
	Name=Font family
	Default=
	Type=select
	Selection[]
	Selection[]=Default
	Selection[font-sansserif]=Sans-serif
	#...

	#soextra.ini
	[sOExtraSettings]
	FontSizes[Small]=10px
	FontSizes[Massive]=72px

Font family and sizes use classes instead of inline styles by default to allow overriding with CSS. Check design/standard/stylesheets/soextra_site.css for styling. Font sizes assume the YUI fonts css is used. This behaviour can be overriden by setting the global var $#use_inline_styles=true. Then the respective values in soextra.ini are used in inline style attributes.


---

### In editor per class styling ###

The following classes are added to the body of the document in the editor, allowing different styling of the editor content per class or attribute:

	ezcca-[CONTENT_CLASS_ATTRIBUTE_ID] ezcc-[CLASS_IDENTIFIER]


---

### Customisable toolbar buttons for inserting custom tags ###

Just by messing with .ini files you can add buttons to insert custom tags directly (for simple tags like underline, strike) or open the tag dialog.
More user friendly than 'Insert custom tag'.

	#soextra.ini
	[sOExtraSettings]
	CustomCreateButtons[]=soextra_create_quote
	
	[soextra_create_quote]
	# required...
	CustomTag=quote
	# optional...
	Title=Insert quote
	OpenDialog=disabled
	IsEmpty=false
	
	#ezoe.ini
	[EditorLayout]
	Buttons[]=soextra_create_quote

	#content.ini
	[CustomTagSettings]
	AvailableCustomTags[]=quote

	#ezoe_dialog.css
	# the button is given mce_BUTTON_NAME class for styling
	.o2k7Skin .mceButton span.mceIcon.mce_soextra_create_quote
		{background:url(../../../../ezoe/design/standard/javascript/themes/ez/img/icons.png) -820px -20px no-repeat;}


---

### Custom attributes in object preview ###

Requires the following patch of ezoe:
	patch/ezoe-5.x.x/extension/ezoe/modules/ezoe/view_embed.php > extension/ezoe/modules/ezoe/view_embed.php

---

### Enhanced Path bar ###

Adds 2 functions for the path bar
- An 'X' button to delete a tag but preserve it's contents
- '+' buttons to position the cursor before or after a tag (a fix for being unable to insert a paragraph after the last non-paragraph block tag)
- Also removes the 'custom.' (The only people who care if it's a custom tag are people who already know)

Requires the following patch of ezoe:
extension/_soextra/design/standard/javascript/themes/ez/editor_template.js > extension/ezoe/design/standard/javascript/themes/ez/editor_template.js

This can be done manually or with a rewrite rule:
	
	Rewriterule ^/extension/ezoe/design/standard/javascript/themes/ez/editor_template.js
		/extension/_soextra/design/standard/javascript/themes/ez/editor_template.js
		
---
	
### Manually resize images ###

When resizing an image in the editor, the dimensions are stored and used in the IMG's attributes.
The selected image alias is always used so scaling down (a bit) is better.
Of course it's best to have the right sized image aliases but this might be useful for small tweaks.

	#content.ini
	[embed]
	CustomAttributes[]=attr_width
	CustomAttributes[]=attr_height
	
	[embed-inline]
	CustomAttributes[]=attr_width
	CustomAttributes[]=attr_height
	

---
	
### Arbitrary HTML code area ###

Like a literal.html tag, any HTML code can be pasted in, so it's only for trusted users. The differences are:
- The content can be sized and positioned - floated left, right.
- Any height and width attributes in the pasted HTML are used to size the content area. This is a bit hacky but seems to work for Google maps, YouTube videos etc.
- A placeholder is shown in the editor the correct size and position.

	#content.ini
	[CustomTagSettings]
	AvailableCustomTags[]=htmlcode
	IsInline[htmlcode]=image
	
	[htmlcode]
	# required...
	CustomAttributes[]=htmlcontent
	CustomAttributes[]=attr_width
	CustomAttributes[]=attr_height
	CustomAttributes[]=align
	CustomAttributes[]=display_inline
	CustomAttributes[]=image_url

	#soextra.ini
	[sOExtraSettings]
	CustomCreateButtons[]=soextra_create_htmlcode
	
	[soextra_create_htmlcode]
	# required...
	CustomTag=htmlcode
	Title=Insert HTML
	OpenDialog=enabled
	IsEmpty=true

	#ezoe.ini
	[EditorLayout]
	Buttons[]=soextra_create_htmlcode


---

### Columns _(experimental!)_ ###

Simple columns. Only one row and pixel widths.

	#content.ini
	[CustomTagSettings]
	AvailableCustomTags[]=column

	#soextra.ini
	[sOExtraSettings]
	CustomCreateButtons[]=soextra_create_column
	
	[soextra_create_column]
	# required...
	CustomTag=column
	Title=Insert new column
	OpenDialog=enabled
	IsEmpty=false
	
	[column]
	CustomAttributes[]=width


---

### Layout blocks _(Very experimental!)_ ###

Editors can produce complex WYSIWYGish layouts in an xmlarea.
Based on [OOCSS](http://oocss.org)
Pure CSS layouts by default can be replaced automatically with tables in email newsletters etc.

Uses 'block' ('unit' in OOCSS) and 'newline' ('line' in OOCSS) custom tags.
blocks on a line should have fraction widths which add up to 1 eg: 1/3 + 2/3 or 1/5 + 3/5 + 1/5
The last block on the line should have 'last on line' custom attribute ticked.
Newline should be added after a line of blocks but is optional if there is no content after.

	#content.ini
	[CustomTagSettings]
	AvailableCustomTags[]=block
	AvailableCustomTags[]=newline
	
	[block]
	CustomAttributes[]
	CustomAttributes[]=size
	CustomAttributes[]=last

	#soextra.ini
	[sOExtraSettings]
	CustomCreateButtons[]=soextra_create_block
	CustomCreateButtons[]=soextra_create_newline
	
	[soextra_create_block]
	CustomTag=block
	Title=Insert new layout block
	OpenDialog=enabled
	IsEmpty=false
	
	[soextra_create_newline]
	CustomTag=newline
	Title=End line of layout blocks
	OpenDialog=disabled
	IsEmpty=true


	
To use inline styles and tables instead of external CSS for things like newsletters, output the content like this:

	{$node.object.data_map.body.content.input|ezxmloutput('htmlmail')}
	
or

	{$node.object.data_map.body.content.input|ezxmloutput('plainmail')}
	
This will render the content with the templates in:
	
	design/standard/templates/content/datatype/view/htmlmail


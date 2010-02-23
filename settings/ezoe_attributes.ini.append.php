<?php /*#?ini charset="utf-8"?

# DEFAULTS #############################################

[CustomAttribute_classification]
Name=Class
Default=
Type=select
Selection[]
AllowEmpty=true

[CustomAttribute_align]
Name=Align
Default=
Type=select
Selection[]
Selection[]=None
Selection[left]=Left
Selection[center]=Center
Selection[right]=Right
AllowEmpty=true

[CustomAttribute_display_inline]
Name=Inline
Title=
Type=checkbox
Default=true

[CustomAttribute_fontclass]
Name=Font family
Default=
Type=select
Selection[]
Selection[]=Default
Selection[font-sansserif]=Sans-serif
Selection[font-palatino]=Palatino
Selection[font-times]=Times
Selection[font-georgia]=Georgia
Selection[font-palatino]=Palatino
Selection[font-trebuchet]=Trebuchet
Selection[font-impact]=Impact
Selection[font-monospace]=Mono-spaced
AllowEmpty=true

[CustomAttribute_fontsize]
Name=Font size
Type=csssize
Default=
CssSizeType[]
CssSizeType[px]=px
CssSizeType[%]=%
CssSizeType[em]=em
AllowEmpty=true

[CustomAttribute_lineheight]
Name=Line height
Type=csssize
Default=
CssSizeType[]
CssSizeType[em]=em
AllowEmpty=true

[CustomAttribute_forecolor]
Name=Text color
Default=
Type=color
AllowEmpty=true

[CustomAttribute_backcolor]
Name=Background color
Default=
Type=color
AllowEmpty=true

[CustomAttribute_margin]
Name=Box margins
Default=
Type=csssize4
CssSizeType[]
CssSizeType[em]=em
CssSizeType[px]=px
AllowEmpty=true

[CustomAttribute_padding]
Name=Box padding
Default=
Type=csssize4
CssSizeType[]
CssSizeType[em]=em
CssSizeType[px]=px
AllowEmpty=true

[CustomAttribute_width]
Name=Width
Default=
Type=csssize
CssSizeType[]
CssSizeType[px]=px
CssSizeType[%]=%
AllowEmpty=true

[CustomAttribute_border_style]
Name=Border style
Default=
Type=select
Selection[]=None
Selection[solid]=Solid
Selection[dotted]=Dotted
Selection[dashed]=Dashed
Selection[double]=Double
Selection[groove]=Groove
Selection[ridge]=Ridge
Selection[inset]=Inset
Selection[outset]=Outset

[CustomAttribute_border_size]
Name=Border width
Default=
Type=csssize
CssSizeType[]
CssSizeType[px]=px
AllowEmpty=true

[CustomAttribute_border_color]
Name=Border color
Default=
Type=color
AllowEmpty=true




## EMBED #####################################################


[CustomAttribute_embed_attr_width]
Name=Width
Default=
Type=int
AllowEmpty=true

[CustomAttribute_embed_attr_height]
Name=Height
Default=
Type=int
AllowEmpty=true

[CustomAttribute_embed-inline_attr_width]
Name=Width
Default=
Type=int
AllowEmpty=true

[CustomAttribute_embed-inline_attr_height]
Name=Height
Default=
Type=int
AllowEmpty=true


## BLOCK #####################################################

[CustomAttribute_block_size]
Name=Size
Title=
Type=select
Selection[]
Selection[1of1]=1/1
Selection[1of2]=1/2
Selection[2of2]=2/2
Selection[1of3]=1/3
Selection[2of3]=2/3
Selection[3of3]=3/3
Selection[1of4]=1/4
Selection[2of4]=2/4
Selection[3of4]=3/4
Selection[4of4]=4/4
Selection[1of5]=1/5
Selection[2of5]=2/5
Selection[3of5]=3/5
Selection[4of5]=4/5
Selection[5of5]=5/5

[CustomAttribute_block_last]
Name=last block on row?
Title=
Type=checkbox
Default=true

## HTMLCODE #####################################################

[CustomAttribute_htmlcode_htmlcontent]
Name=Paste HTML code
Default=
Type=htmlcontent
AllowEmpty=false

[CustomAttribute_htmlcode_attr_width]
Name=Width
Default=
Type=int
AllowEmpty=true

[CustomAttribute_htmlcode_attr_height]
Name=Height
Default=
Type=int
AllowEmpty=true

[CustomAttribute_htmlcode_image_url]
Default=/extension/_soextra/design/standard/images/blank.gif
Type=hidden
AllowEmpty=false

## COLUMN #######################################################

[CustomAttribute_column_width]
Name=Width
Default=181
Type=csssize
CssSizeType[]
CssSizeType[px]=px
AllowEmpty=true

*/ ?>

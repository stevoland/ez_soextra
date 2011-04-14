<?php /*

[sOExtraSettings]

# used if var $use_inline_styles is true() when viewing ezxmltext
# otherwise use stylesheets
# [class or fontclass]=inline styles
ClassStyles[]

ClassStyles[font-sansserif]=font-family: Geneva, 'Helvetica Neue', Frutiger, 'Frutiger Linotype', Arial, Univers, Calibri, 'Gill Sans', 'Gill Sans MT', 'Myriad Pro', Myriad, 'DejaVu Sans Condensed', 'Liberation Sans', 'Nimbus Sans L', Tahoma, Helvetica, sans-serif;
}

ClassStyles[font-palatino]=font-family: 'Palatino Linotype', Palatino, Palladio, 'URW Palladio L', 'Book Antiqua', Baskerville, 'Bookman Old Style', 'Bitstream Charter', 'Nimbus Roman No9 L', Garamond, 'Apple Garamond', 'ITC Garamond Narrow', 'New Century Schoolbook', 'Century Schoolbook', 'Century Schoolbook L', Georgia, serif;

ClassStyles[font-times]=font-family: Cambria, 'Hoefler Text', Utopia, 'Liberation Serif', 'Nimbus Roman No9 L Regular', Times, 'Times New Roman', serif;

ClassStyles[font-georgia]=font-family: Constantia, 'Lucida Bright', Lucidabright, 'Lucida Serif', Lucida, 'DejaVu Serif', 'Bitstream Vera Serif', 'Liberation Serif', Georgia, serif;

ClassStyles[font-trebuchet]=font-family: 'Segoe UI', Candara, 'Bitstream Vera Sans', 'DejaVu Sans', 'Bitstream Vera Sans', 'Trebuchet MS', Verdana, 'Verdana Ref', sans-serif;

ClassStyles[font-monospace]=font-family: Consolas, 'Andale Mono WT', 'Andale Mono', 'Lucida Console', 'Lucida Sans Typewriter', 'DejaVu Sans Mono', 'Bitstream Vera Sans Mono', 'Liberation Mono', 'Nimbus Mono L', Monaco, 'Courier New', Courier, monospace;

ClassStyles[font-impact]=font-family: Impact, Haettenschweiler, 'Franklin Gothic Bold', Charcoal, 'Helvetica Inserat', 'Bitstream Vera Sans Bold', 'Arial Black', sans-serif;

# needs !important?
ClassStyles[nocolor]=color:inherit;

# [display]=value
FontSizes[]
#FontSizes[Default]=
FontSizes[10px]=10px
FontSizes[11px]=12px
FontSizes[13px]=13px
FontSizes[14px]=14px
FontSizes[15px]=15px
FontSizes[16px]=16px
FontSizes[17px]=17px
FontSizes[18px]=18px
FontSizes[19px]=19px
FontSizes[20px]=20px
FontSizes[22px]=22px
FontSizes[24px]=24px
FontSizes[26px]=26px
FontSizes[28px]=28px
FontSizes[30px]=30px
FontSizes[32px]=32px
FontSizes[34px]=34px
FontSizes[36px]=36px
FontSizes[38px]=38px
FontSizes[40px]=40px
FontSizes[44px]=44px
FontSizes[48px]=48px
FontSizes[52px]=52px
FontSizes[54px]=54px
FontSizes[58px]=56px
FontSizes[60px]=60px
FontSizes[64px]=64px
FontSizes[68px]=68px
FontSizes[72px]=72px

# Elements that can't have content inside them - not including inline image based embeds
EmptyElements[]
EmptyElements[]=pagebreak
EmptyElements[]=newline


CustomCreateButtons[]
CustomCreateButtons[]=soextra_create_block
CustomCreateButtons[]=soextra_create_newline
CustomCreateButtons[]=soextra_create_quote
CustomCreateButtons[]=soextra_create_htmlcode
CustomCreateButtons[]=soextra_create_column

[soextra_create_block]
#required
CustomTag=block

Title=Insert new layout block
OpenDialog=disabled
IsEmpty=false

[soextra_create_newline]
#required
CustomTag=newline

Title=End line of layout blocks
OpenDialog=disabled
IsEmpty=true

[soextra_create_quote]
#required
CustomTag=quote

Title=Insert quote
OpenDialog=disabled
IsEmpty=false

[soextra_create_htmlcode]
#required
CustomTag=htmlcode

Title=Insert HTML code
OpenDialog=enabled
IsEmpty=true


[soextra_create_column]
#required
CustomTag=column

Title=Insert new column
OpenDialog=enabled
IsEmpty=false


[literal]
#List of classes defined per tag as AvailableClasses content.ini that should be included
#in the select style toolbar button. If not defined, all AvailableClasses are used.
FavouriteClasses[]
FavouriteClasses[]=html
FavouriteClasses[]=javscript
FavouriteClasses[]=css

*/ ?>
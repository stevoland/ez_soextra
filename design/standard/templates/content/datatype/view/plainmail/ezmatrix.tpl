{let matrix=$attribute.content}

{section name=ColumnNames loop=$matrix.columns.sequential}{$ColumnNames:item.name}{delimiter} {/delimiter}{/section}

{section name=Rows loop=$matrix.rows.sequential}
{section name=Columns loop=$Rows:item.columns}{$Rows:Columns:item|wash(xhtml)}{delimiter} {/delimiter}{/section}{delimiter}
{/delimiter}{/section}

{/let}

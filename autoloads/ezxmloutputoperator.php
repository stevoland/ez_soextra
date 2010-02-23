<?php

class eZXMLOutputOperator
{
    function __construct()
    {
		$this->Operators = array( 'ezxmloutput');
        $this->Debug = false;
    }

    function operatorList()
    {
        return $this->Operators;
    }

    function namedParameterPerOperator()
    {
        return true;
    }

    function namedParameterList()
    {
        return array( 'ezxmloutput' => array( 'tpl_path' => array( 'type' => 'string', 'required' => false, 'default' => '' )
                                             )
					);
    }

    function modify( &$tpl, &$operatorName, &$operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        switch ( $operatorName )
        {
            case 'ezxmloutput':
            {
				$handler = new eZXHTMLXMLOutput($operatorValue->XMLData, false, $operatorValue->ContentObjectAttribute);
				$tpl_part = isset($namedParameters['tpl_path']) ? $namedParameters['tpl_path'] . '/' : '';
				$handler->TemplatesPath = 'design:content/datatype/view/' . $tpl_part . 'ezxmltags/';
				$ret = $handler->outputText();
            } break;
        }

        $operatorValue = $ret;

    }

    /// \privatesection

    /// \return The class variable 'Operators' which contains an array of available operators names.
    var $Operators;

    /// \privatesection
    /// \return The class variable 'Debug' to false.
    var $Debug;
    
}

?>

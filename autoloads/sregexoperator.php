<?php

class sRegexOperator
{
    function __construct()
    {
		$this->Operators = array( 'preg_replace' );
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
        return array( 'preg_replace' => array('search' => array( 'type' => 'string',
                                                                  'required' => true,
                                                                  'default' => '' ),
                                               'replace' => array( 'type' => 'string',
                                                                   'required' => true,
                                                                   'default' => '' )
                                            )
		);
    }

    function modify( &$tpl, &$operatorName, &$operatorParameters, &$rootNamespace, &$currentNamespace, &$operatorValue, &$namedParameters )
    {
        switch ( $operatorName )
        {
            case 'preg_replace':
            {
                $ret = preg_replace($namedParameters['search'], $namedParameters['replace'], $operatorValue);
            } break;
        }

        $operatorValue = $ret;

    }

    /// \privatesection
	
	static $isFirst = true;

    /// \return The class variable 'Operators' which contains an array of available operators names.
    var $Operators;

    /// \privatesection
    /// \return The class variable 'Debug' to false.
    var $Debug;
    
}

?>

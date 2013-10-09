<?php
/*
 * openNG is more free software. It is licensed under the WTFPL, which
 * allows you to do pretty much anything with it, without having to
 * ask permission. Commercial use is allowed, and no attribution is
 * required. We do politely request that you share your modifications
 * to benefit other developers, but you are under no enforced
 * obligation to do so :)
 * 
 * Please read the accompanying LICENSE document for the full WTFPL
 * licensing text.
 */

$_APP = true;
require("includes/base.php");

$sData = array();

$router = new CPHPRouter();

$router->ignore_query = true;
$router->allow_slash = true;

$router->routes = array(
	0 => array(
		"^/$"					=> "modules/index.php",
		"^/editor$"				=> "modules/editor.php",
		"^/intro$"				=> array(
			'target'	=> "modules/intro.php",
			'_json'		=> true
		),
		"^/nodes/create$"			=> array(
			'target'	=> "modules/nodes/create.php",
			'_json'		=> true
		),
		"^/nodes/([0-9a-f-]{36})$"		=> array(
			"target"	=> "modules/nodes/lookup.php",
			"_json"		=> true
		),
		"^/autocomplete/search$"		=> array(
			"target"	=> "modules/autocomplete/search.php",
			"_json"		=> true
		),
		"^/autocomplete/propertyname$"		=> array(
			"target"	=> "modules/autocomplete/propertyname.php",
			"_json"		=> true
		)
	)
);

$router->RouteRequest();

if(!empty($router->uVariables['json']))
{
	echo(json_encode($sData));
}

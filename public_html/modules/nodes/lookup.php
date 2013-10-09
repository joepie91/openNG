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

if(!isset($_APP)) { die("Unauthorized."); }

$uUuid = $router->uParameters[1];

try
{
	$sNode = new Node($uUuid);
	
	$sProperties = array();
	
	foreach(Property::CreateFromQuery("SELECT * FROM properties WHERE `NodeId` = :NodeId", array(
		"NodeId"	=> $sNode->sId
	)) as $sProperty)
	{
		$sProperties[] = array(
			"name"		=> $sProperty->sName,
			"value"		=> $sProperty->sValue,
			"source"	=> $sProperty->sSource,
			"reliability"	=> $sProperty->sReliability
		);
	}
	
	$sData = array(
		"contents"	=> NewTemplater::Render("nodes/lookup", $locale->strings, array(
			"name"		=> $sNode->sName,
			"notes"		=> $sNode->sNotes,
			"properties"	=> $sProperties
		))
	);
}
catch (NotFoundException $e)
{
	$sUuid = htmlspecialchars($uUuid);
	
	$sData = array(
		"contents"	=> "Could not find a node with ID {$sUuid}."
	);
}

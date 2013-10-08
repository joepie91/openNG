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

try
{
	$sNodes = Node::CreateFromQuery("SELECT * FROM nodes WHERE `LatestRevision` = 1 AND `Name` LIKE :Name LIMIT 5", array("Name" => "%{$_GET['q']}%"));
}
catch (NotFoundException $e)
{
	$sNodes = array();
}

$sData = array();

foreach($sNodes as $sNode)
{
	$sData[] = array(
		"name"		=> $sNode->sName,
		"description"	=> $sNode->sNotes,
		"value"		=> $sNode->sId,
		"created"	=> local_from_unix($sNode->sCreationDate, $locale->date_short)
	);
}

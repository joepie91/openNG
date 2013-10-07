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

$sOriginalData = array(
	array(
		"name" => "ChicagoVPS",
		"description" => "A VPS company.",
		"value" => "id-for-chicagovps",
		"created" => "2013-08-02"
	),
	array(
		"name" => "BuffaloVPS",
		"description" => "A VPS company.",
		"value" => "id-for-buffalovps",
		"created" => "2013-08-03"
	),
	array(
		"name" => "ColoCrossing",
		"description" => "A colocation provider.",
		"value" => "id-for-colocrossing",
		"created" => "2013-08-06"
	)
);

$sData = array();

foreach($sOriginalData as $sEntry)
{
	if(strpos(strtolower($sEntry['name']), strtolower($_GET['q'])) !== false)
	{
		$sData[] = $sEntry;
	}
}

sleep(1);

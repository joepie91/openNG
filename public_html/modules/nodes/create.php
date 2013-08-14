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

if($router->uMethod == "get")
{
	/* Display form */
	$sData = array(
		"contents"	=> NewTemplater::Render("nodes/create", $locale->strings, array())
	);
}
elseif($router->uMethod == "post")
{
	/* Process form */
	$sErrors = array();
	
	if(empty($_POST['name']))
	{
		$sErrors[] = "You must enter a name for the new node. This name does not have to be unique.";
	}
	
	if(empty($sErrors))
	{
		$sNode = new Node();
		
		$sNode->uName = $_POST['name'];
		$sNode->uNotes = $_POST['notes'];
		
		$sNode->uTypeId = 0;
		$sNode->uParentRevisionId = 0;
		$sNode->uFirstRevisionId = 0;
		$sNode->uUserId = 0;
		$sNode->uCreationDate = time();
		$sNode->uLatestRevision = true;
		
		$sNode->InsertIntoDatabase();
		
		/* Update the entry to refer to itself as the first revision */
		$sNode->uFirstRevisionId = $sNode->sId;
		$sNode->InsertIntoDatabase();
		
		$sData = array(
			"result"	=> "success",
			"message"	=> "Node '" . htmlspecialchars($_POST['name']) . "' created.",
			"node_id"	=> $sNode->sId
		);
	}
	else
	{
		$sErrorList = "";
		
		foreach($sErrors as $sError)
		{
			$sErrorList .= "<li>{$sError}</li>";
		}
		
		$sData = array(
			"result"	=> "error",
			"message"	=> "One or more form fields were not filled in correctly: <ul>{$sErrorList}</ul>"
		);
	}
}

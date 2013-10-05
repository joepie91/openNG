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
		$uNodeId = generate_uuid();
		
		$sNode = new Node();
		
		$sNode->uId = $uNodeId;
		$sNode->uName = $_POST['name'];
		$sNode->uNotes = $_POST['notes'];
		
		$sNode->uTypeId = "";
		$sNode->uParentRevisionId = "";
		$sNode->uFirstRevisionId = $uNodeId;
		$sNode->uUserId = 0;
		$sNode->uCreationDate = time();
		$sNode->uLatestRevision = true;
		
		$sNode->InsertIntoDatabase();
		
		/* Insert properties, if any */
		foreach(array_combine($_POST['property_name'], $_POST['property_value']) as $property_name => $property_value)
		{
			if(!empty($property_name))
			{
				$uPropertyId = generate_uuid();
				
				$sProperty = new Property();
				
				$sProperty->uId = $uPropertyId;
				$sProperty->uName = $property_name;
				$sProperty->uValue = $property_value;
				$sProperty->uSource = "";
				
				$sProperty->uTypeId = "";
				$sProperty->uParentRevisionId = "";
				$sProperty->uFirstRevisionId = $uPropertyId;
				$sProperty->uNodeId = $uNodeId;
				$sProperty->uRelationshipId = "";
				$sProperty->uReliability = 1; /* Normal */
				$sProperty->uCreationDate = time();
				$sProperty->uLatestRevision = true;
				
				$sProperty->InsertIntoDatabase();
			}
		}
		
		$sData = array(
			"result"	=> "success",
			"message"	=> "Node '" . htmlspecialchars($_POST['name']) . "' created.",
			"node_id"	=> $uNodeId
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

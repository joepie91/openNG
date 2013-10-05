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

class Property extends CPHPDatabaseRecordClass
{
	public $table_name = "properties";
	public $fill_query = "SELECT * FROM properties WHERE `Id` = :Id";
	public $verify_query = "SELECT * FROM properties WHERE `Id` = :Id";
	
	public $prototype = array(
		'string' => array(
			"Name"			=> "Name",
			"Value"			=> "Value",
			"Source"		=> "Source",
			"TypeId"		=> "TypeId",
			"ParentRevisionId"	=> "ParentRevisionId",
			"FirstRevisionId"	=> "FirstRevisionId",
			"NodeId"		=> "NodeId",
			"RelationshipId"	=> "RelationshipId"
		),
		'numeric' => array(
			"UserId"		=> "UserId",
			"Reliability"		=> "Reliability"
		),
		'timestamp' => array(
			"CreationDate"		=> "CreationDate"
		),
		'boolean' => array(
			"LatestRevision"	=> "LatestRevision"
		),
		'propertytype' => array(
			"Type"			=> "TypeId"
		),
		'property' => array(
			"ParentRevision"	=> "ParentRevisionId",
			"FirstRevision"		=> "FirstRevisionId"
		),
		'node' => array(
			"Node"			=> "NodeId"
		),
		'relationship' => array(
			"Relationship"		=> "RelationshipId"
		),
		'user' => array(
			"User"			=> "UserId"	
		)
	);
	
	public function SaveRevision($user)
	{
		/* Create a working copy of the current object */
		$this_copy = clone $this;
		
		/* Create a new object representing the new revision */
		$sNode = clone $this;
		$sNode->sId = 0;
		$sNode->uParentRevisionId = $this->sId;
		$sNode->uUserId = $user->sId;
		$sNode->uCreationDate = time();
		$sNode->InsertIntoDatabase(true);
		
		/* Clear out all changes to the working copy, and save the changed 'latest revision' flag */
		$this_copy->RefreshData();
		$this_copy->uLatestRevision = false;
		$this_copy->InsertIntoDatabase();
		
		/* Set the same flag on the current object, in case of further operations */
		$this->uLatestRevision = false;
	}
}

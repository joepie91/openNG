CREATE TYPE E_RELIABILITY AS ENUM(
	'low',
	'normal',
	'high'
);

CREATE TABLE nodes (
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	name				TEXT,
	type_id				UUID,		-- UUID
	mass_ingested		BOOLEAN,
	external_source		BOOLEAN,
	thumbnail_attribute	UUID,		-- UUID, refers to the attribute_type whose value should be used for thumbnail display
	PRIMARY KEY ( id )
);

CREATE INDEX nodes_perma_id_ix ON nodes ( perma_id ) WHERE deleted = false;
CREATE INDEX nodes_type_ix ON nodes ( type_id );

CREATE TABLE node_types (
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	name				TEXT,
	PRIMARY KEY ( id )
);

CREATE INDEX node_types_perma_id_ix ON node_types ( perma_id ) WHERE deleted = false;

CREATE TABLE node_tags (
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	name				TEXT,
	restricted			BOOLEAN,
	clearance_required	BOOLEAN,	-- Indicates that access to nodes carrying this tag is disallowed unless the user has
									-- explicitly received clearance for the tag - even if he already has clearance for
									-- other tags on the same node.
	PRIMARY KEY ( id )
);

CREATE INDEX node_tags_perma_id_ix ON node_tags ( perma_id ) WHERE deleted = false;

CREATE TABLE node_tag_associations (
	id					UUID,		-- UUID
	node_id				UUID,		-- UUID
	tag_id				UUID,		-- UUID
	PRIMARY KEY ( id )
);

CREATE INDEX node_tag_associations_ix ON node_tag_associations ( node_id, tag_id );

CREATE TABLE clearances (
	id					UUID,		-- UUID
	user_id				UUID,		-- UUID
	tag_id				UUID,		-- UUID
	expiry_date			TIMESTAMP,
	revoked				BOOLEAN,
	revocation_date		TIMESTAMP,
	PRIMARY KEY ( id )
);

CREATE INDEX clearances_user_id_tag_id_ix ON clearances ( user_id, tag_id ) WHERE revoked = false;

CREATE TABLE relationships (
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	source_node			UUID,		-- UUID
	destination_node	UUID,		-- UUID
	directional			BOOLEAN,
	type_id				UUID,		-- UUID
	reliability			E_RELIABILITY,
	PRIMARY KEY ( id )
);

CREATE INDEX relationships_perma_id_ix ON relationships ( perma_id ) WHERE deleted = false;
CREATE INDEX relationships_source_node_ix ON relationships ( source_node );
CREATE INDEX relationships_destination_node_ix ON relationships ( destination_node );

CREATE TABLE relationship_types (
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	name				TEXT,
	PRIMARY KEY ( id )
);

CREATE INDEX relationship_types_perma_id_ix ON relationship_types ( perma_id ) WHERE deleted = false;

CREATE TABLE relationship_sources (
	id					UUID,		-- UUID
	relationship_id		UUID,		-- UUID
	reference_id		UUID,		-- UUID
	PRIMARY KEY ( id )
);

CREATE INDEX relationship_sources_ix ON relationship_sources ( relationship_id, reference_id );

CREATE TABLE relationship_references (
	-- This table is used to store references on "nodes related to this relationship", when those nodes are not the source
	-- nor the destination. An example: Acme Corp. is a supplier of ABC Widgets Inc., and they have a relationship defined
	-- as such. However, there is also a node representing the contract between the two - this node would be listed as a
	-- reference on the 'supplier of' relationship.
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	relationship_id		UUID,		-- UUID
	node_id				UUID,		-- UUID
	remark				TEXT,		-- comments
	PRIMARY KEY ( id )
);

CREATE INDEX relationship_references_perma_id_ix ON relationship_references ( perma_id ) WHERE deleted = false;
CREATE INDEX relationship_references_node_id_ix ON relationship_references ( node_id );
CREATE INDEX relationship_references_relationship_id_ix ON relationship_references ( relationship_id );

CREATE TABLE attributes (
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	node_id				UUID,		-- UUID
	type_id				UUID,		-- UUID
	"value"				TEXT,		-- shush.
	reliability			E_RELIABILITY,
	attachment			BOOLEAN,
	PRIMARY KEY ( id )
);

CREATE INDEX attributes_perma_id_ix ON attributes ( perma_id ) WHERE deleted = false;
CREATE INDEX attributes_node_id_ix ON attributes ( node_id );

CREATE TABLE attribute_types (
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	name				TEXT,
	PRIMARY KEY ( id )
);

CREATE INDEX attribute_types_perma_id_ix ON attribute_types ( perma_id ) WHERE deleted = false;

CREATE TABLE attribute_sources (
	id					UUID,		-- UUID
	attribute_id		UUID,		-- UUID
	reference_id		UUID,		-- UUID
	PRIMARY KEY ( id )
);

CREATE INDEX attribute_sources_ix ON attribute_sources ( attribute_id, reference_id );

CREATE TABLE projects (
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	name				TEXT,
	user_id				UUID,		-- UUID
	PRIMARY KEY ( id )
);

CREATE INDEX projects_perma_id_ix ON projects ( perma_id ) WHERE deleted = false;
CREATE INDEX projects_user_id_ix ON projects ( user_id );

CREATE TABLE project_authorizations (
	id					UUID,		-- UUID
	project_id			UUID,		-- UUID
	user_id				UUID,		-- UUID
	expiry_date			TIMESTAMP,
	revoked				BOOLEAN,
	revocation_date		TIMESTAMP,
	PRIMARY KEY ( id )
);

CREATE INDEX project_authorizations_user_id_project_id_ix ON project_authorizations ( user_id, project_id ) WHERE revoked = false;

CREATE TABLE bins (
	id					UUID,		-- UUID
	perma_id			UUID,		-- UUID; this is the actual UUID that is refered to in other items, it stays consistent even across revisions
	revision_user_id	UUID,		-- UUID; the user that created this particular revision
	deleted				BOOLEAN,
	creation_date		TIMESTAMP,
	deletion_date		TIMESTAMP,
	user_id				UUID,		-- UUID
	name				TEXT,
	private				BOOLEAN,
	PRIMARY KEY ( id )
);

CREATE INDEX bins_perma_id_ix ON bins ( perma_id ) WHERE deleted = false;
CREATE INDEX bins_user_id_ix ON bins ( user_id );

CREATE TABLE bin_items (
	id					UUID,		-- UUID
	bin_id				UUID,		-- UUID
	node_id				UUID,		-- UUID
	PRIMARY KEY ( id )
);

CREATE INDEX bin_items_ix ON bin_items ( bin_id, node_id );

CREATE TABLE bin_authorizations (
	id					UUID,		-- UUID
	bin_id				UUID,		-- UUID
	user_id				UUID,		-- UUID
	expiry_date			TIMESTAMP,
	revoked				BOOLEAN,
	revocation_date		TIMESTAMP,
	PRIMARY KEY ( id )
);

CREATE INDEX bin_authorizations_user_id_bin_id_ix ON bin_authorizations ( user_id, bin_id ) WHERE revoked = false;

CREATE TABLE bin_project_associations (
	id					UUID,		-- UUID
	bin_id				UUID,		-- UUID
	project_id			UUID,		-- UUID
	PRIMARY KEY ( id )
);

CREATE INDEX bin_project_associations_ix ON bin_project_associations ( project_id, bin_id );

CREATE TABLE "references" (
	id					UUID,		-- UUID
	"source"			TEXT,		-- URL or textual reference (eg. bibliographical)
	archived			BOOLEAN,	-- Whether the source has been archived locally
	url					BOOLEAN,	-- Whether the source is a URL or not
	PRIMARY KEY ( id )
);

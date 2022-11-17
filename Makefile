PROJECT_ID=kolban-dw-demo
SCHEMA_ID=55f8ik8uk3jag
USER=kolban@kolban.altostrat.com
USER1=user1@kolban.altostrat.com
DOCUMENT_ID=6g75u1jguckeo
RULE_ID=5fit2b1e8lq08

# DocAI
PROCESSOR_ID=e022b4ee02ff80ff

####
AUTH_TOKEN=$(shell gcloud auth application-default print-access-token)
PROJECT_NUMBER=$(shell gcloud projects list --filter="$(PROJECT_ID)" --format="value(PROJECT_NUMBER)")
LOCATION=us
PROJECT_PART=projects/$(PROJECT_NUMBER)
PARENT=projects/$(PROJECT_NUMBER)/locations/$(LOCATION)


#
#
# Creating replicated properties
# A schema property can be flagged as "isReplicated = true" which means that it allows multiple values.  Tests
# of this can be found at:
#
# * make schema-create-replicated
# * make document-create-replicated
# 
# and the files:
# * schema-create-replicated.json     - CURL input to create a schema that supplies a replicated field
# * document-create-replicated-1.json - CURL input to create a document that uses replicated fields
#2

all:
	@echo "DocAI Warehouse!"
	@echo "----------------"
	@echo "schema-list       - List the existing schemas"
	@echo "schema-create     - Create an instance of the schema"
	@echo "schema-get        - Get the description of the schema"
	@echo "document-create   - Create a document"
	@echo "document-get      - Get the content of a document"
	@echo "document-search   - Search for documents"
	@echo "rules-create      - Create a rule"
	@echo "rules-list        - List the rules"
	@echo "rules-delete      - Delete a rule"
	@echo "rules-update      - Update a rule"
	@echo "docai-process-pdf - Pass a PDF through DocAI to generate the JSON"
	@echo "docai-build       - Run \"make docai-process-pdf\" and then build a JSON for DaW creation"
	@echo "document-docai-create - Create a document in DaW that contains DocAI output"


# Demo #1
# Make schema-create
# Make schema-list
# Make schema-get

# Demo #2
# Make document-create
# Make document-get

set-project:
	gcloud config set project $(PROJECT_ID)

# List all the schemas that exist.
schema-list:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-X GET https://contentwarehouse.googleapis.com/v1/$(PARENT)/documentSchemas

# Get the details of the schema identified by the SCHEMA_ID variable
schema-get:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-X GET https://contentwarehouse.googleapis.com/v1/$(PARENT)/documentSchemas/$(SCHEMA_ID)

# Create a new schema
schema-create:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @schema-create-invoice.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documentSchemas

schema-create-replicated:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @schema-create-replicated.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documentSchemas


# Create a new document
document-create:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-create-invoice-gcs-1.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents

document-create-replicated:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @document-create-replicated-1.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents

# Create a new document
document-create-user1:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-create-invoice-1-user1.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents

document-create-multi:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @document-create-invoice-multi.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents

# Create a all the document
document-create-all:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-create-invoice-gcs-1.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-create-invoice-gcs-2.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-create-invoice-gcs-3.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-create-invoice-gcs-4.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-create-invoice-gcs-5.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents								

document-docai-create:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/dw-docai.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents

document-get:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-get.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents/$(DOCUMENT_ID):get

document-linked-sources:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-linked-sources.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents/$(DOCUMENT_ID)/linkedSources

document-linked-targets:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-linked-targets.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents/$(DOCUMENT_ID)/linkedTargets

document-search-1:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-search-1.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents:search

document-search-2:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-search-2.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents:search

document-search-3:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-search-3.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents:search

document-search-4:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/document-search-4.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents:search


patch1:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @patch1.json \
		-X PATCH https://contentwarehouse.googleapis.com/v1/$(PARENT)/documents/2rqfhbdrhcs38

#https://contentwarehouse.googleapis.com/v1/projects/764337371079/locations/us/documentSchemas?page_size=10000

# Run a file through DocAI Invoice Parser and store the result as a JSON file
docai-process-pdf:
	@echo -n '{"document": {"mimeType": "application/pdf","content": "' > generated/o.txt
	@base64 --wrap=0 "data/SampleInvoice1.pdf" >> generated/o.txt
	@echo -n '"}}' >> generated/o.txt
	curl -X POST \
		-H "Authorization: Bearer "$(AUTH_TOKEN) \
		-H "Content-Type: application/json; charset=utf-8" \
		-d @generated/o.txt \
		https://$(LOCATION)-documentai.googleapis.com/v1beta3/projects/$(PROJECT_ID)/locations/$(LOCATION)/processors/$(PROCESSOR_ID):process > generated/docai-result.json
	@rm -f generated/o.txt
	@echo "DocAI Parse Result of PDF is in 'generated/docai-result.json'"

docai-process-png:
	echo -n '{"document": {"mimeType": "image/png","content": "' > generated/o.txt
	base64 --wrap=0 "data/SampleInvoice1.png" >> generated/o.txt
	echo -n '"}}' >> generated/o.txt
	curl -X POST \
		-H "Authorization: Bearer "$(AUTH_TOKEN) \
		-H "Content-Type: application/json; charset=utf-8" \
		-d @generated/o.txt \
		https://$(LOCATION)-documentai.googleapis.com/v1beta3/projects/$(PROJECT_ID)/locations/$(LOCATION)/processors/$(PROCESSOR_ID):process > generated/docai-result.json
	rm -f generated/o.txt

acl-project:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @generated/acl-project.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PROJECT_PART):fetchAcl
	
rules-create:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @rule-1.json \
		-X POST https://contentwarehouse.googleapis.com/v1/$(PARENT)/ruleSets

rules-update:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-d @rule-update-1.json \
		-X PATCH https://contentwarehouse.googleapis.com/v1/$(PARENT)/ruleSets/$(RULE_ID)

rules-list:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-X GET https://contentwarehouse.googleapis.com/v1/$(PARENT)/ruleSets

rules-delete:
	curl -H "Authorization: Bearer $(AUTH_TOKEN)" \
		-H "Content-Type: application/json" \
		-X DELETE https://contentwarehouse.googleapis.com/v1/$(PARENT)/ruleSets/$(RULE_ID)

docai-build: docai-process-pdf
	cat document-create-docai.json generated/docai-result.json | jq --slurp '.[0].document.cloudAiDocument += .[1].document | .[0].requestMetadata.user_info.id |= "user:$(USER)" | .[0].document.documentSchemaName|="projects/$(PROJECT_NUMBER)/locations/us/documentSchemas/$(SCHEMA_ID)" | .[0].document.rawDocumentPath|="gs://$(PROJECT_NUMBER)-data/SampleInvoice1.pdf" |.[0]' > generated/dw-docai.json
	@echo "Construction of document for loading into DocAI Warehouse is in 'generated/dw-docai.json'"
	@echo "Run 'make document-docai-create' to create the document in DocAI Warehouse"

bucket:
	gsutil mb gs://$(PROJECT_NUMBER)-data

copy-data-files:
	gsutil -m cp data/* gs://$(PROJECT_NUMBER)-data

# This rule expects that the 'jq' command is installed.  See: https://stedolan.github.io/jq/  and run 'sudo apt-get install jq'.
prep-data:
	cat document-create-invoice-gcs-1.json | jq '.document.documentSchemaName|="projects/$(PROJECT_NUMBER)/locations/us/documentSchemas/$(SCHEMA_ID)" | .document.rawDocumentPath|="gs://$(PROJECT_NUMBER)-data/SampleInvoice1.pdf" | .requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-create-invoice-gcs-1.json
	cat document-create-invoice-gcs-2.json | jq '.document.documentSchemaName|="projects/$(PROJECT_NUMBER)/locations/us/documentSchemas/$(SCHEMA_ID)" | .document.rawDocumentPath|="gs://$(PROJECT_NUMBER)-data/SampleInvoice2.pdf" | .requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-create-invoice-gcs-2.json
	cat document-create-invoice-gcs-3.json | jq '.document.documentSchemaName|="projects/$(PROJECT_NUMBER)/locations/us/documentSchemas/$(SCHEMA_ID)" | .document.rawDocumentPath|="gs://$(PROJECT_NUMBER)-data/SampleInvoice3.pdf" | .requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-create-invoice-gcs-3.json
	cat document-create-invoice-gcs-4.json | jq '.document.documentSchemaName|="projects/$(PROJECT_NUMBER)/locations/us/documentSchemas/$(SCHEMA_ID)" | .document.rawDocumentPath|="gs://$(PROJECT_NUMBER)-data/SampleInvoice4.pdf" | .requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-create-invoice-gcs-4.json
	cat document-create-invoice-gcs-5.json | jq '.document.documentSchemaName|="projects/$(PROJECT_NUMBER)/locations/us/documentSchemas/$(SCHEMA_ID)" | .document.rawDocumentPath|="gs://$(PROJECT_NUMBER)-data/SampleInvoice5.pdf" | .requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-create-invoice-gcs-5.json
	cat document-create-invoice-1-user1.json | jq '.document.documentSchemaName|="projects/$(PROJECT_NUMBER)/locations/us/documentSchemas/$(SCHEMA_ID)" | .requestMetadata.user_info.id |= "user:$(USER1)"' > generated/document-create-invoice-1-user1.json
	cat document-search-1.json | jq '.requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-search-1.json	
	cat document-search-2.json | jq '.documentQuery.propertyFilter[0].documentSchemaName|="projects/$(PROJECT_NUMBER)/locations/us/documentSchemas/$(SCHEMA_ID)" | .requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-search-2.json
	cat document-search-4.json | jq '.requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-search-4.json
	cat document-get.json | jq ' .requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-get.json
	cat acl-project.json | jq ' .requestMetadata.user_info.id |= "user:$(USER)"' > generated/acl-project.json
	cat document-linked-sources.json | jq ' .requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-linked-sources.json
	cat document-linked-targets.json | jq ' .requestMetadata.user_info.id |= "user:$(USER)"' > generated/document-linked-targets.json

clean:
	rm generated/*
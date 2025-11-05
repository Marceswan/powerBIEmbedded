# Power BI Embedded Reports - Salesforce Project

This Salesforce DX project contains a Lightning Web Component for embedding Power BI reports in Salesforce.

## Components Included

### Lightning Web Component
- **powerBIreports** - LWC component for displaying Power BI reports with search and selection functionality

### Apex Classes
- **PowerBIreportsController.cls** - Controller class that retrieves active Power BI reports from the database
- **PowerBIreportsControllerTest.cls** - Test class for the controller

## Prerequisites & Dependencies

### Required Custom Object
This project requires the `Power_BI_reports__c` custom object to be created in your target org with the following fields:

1. **Object Name:** `Power_BI_reports__c`
2. **Required Fields:**
   - `Name` (Text, Standard)
   - `Report_Link__c` (URL field or Text(255))
   - `Active__c` (Checkbox)

### Field Details
- **Report_Link__c**: Should store the full Power BI report embed URL
- **Active__c**: When checked, the report will appear in the component dropdown

## Deployment Instructions

1. **Create the Custom Object** (if not already present):
   ```bash
   # Create the custom object and fields in your target org through Setup UI or using metadata
   ```

2. **Deploy the components**:
   ```bash
   # Authorize your org
   sf org login web -a YourOrgAlias

   # Deploy the metadata
   sf project deploy start -o YourOrgAlias
   ```

3. **Add sample data**:
   - Navigate to the Power BI reports tab in your org
   - Create new records with Name, Report Link, and mark as Active

## Usage

The component can be added to:
- Lightning Record Pages
- Lightning App Pages
- Lightning Home Pages
- Lightning Tabs

### Configuration
- **Initial Selection (optional)**: Specify the name of a report to display by default when the component loads

## Features

- Dropdown selector for available reports
- Search functionality to filter reports by name
- Reload button to refresh the iframe
- Open in new tab button
- Responsive design

## Salesforce DX Resources

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)

# Power BI Embedded Reports - Salesforce Lightning Web Components

A comprehensive solution for embedding Power BI reports directly in Salesforce Lightning pages. Choose between a single-report component for quick deployment or a multi-report component for scalable report catalogs.

## Quick Navigation

- **Want a quick start?** → [Quick Start Guide](#quick-start-guide)
- **Deciding which component?** → [Component Comparison](#component-comparison--which-should-i-use)
- **Single Report (15 min setup)?** → [powerBiReport_Single](#powerbireport_single-single-report-component)
- **Multiple Reports (scalable)?** → [powerBiReportList](#powerbireportlist-multi-report-component)
- **Deploy instructions?** → [Deployment Instructions](#deployment-instructions)
- **Need help?** → [Troubleshooting](#troubleshooting)

---

## Overview

This Salesforce DX project provides two complementary Lightning Web Components for embedding Power BI reports:

### Available Components

| Component | Purpose | Setup Time | Best For |
|-----------|---------|-----------|----------|
| **powerBiReport_Single** | Single report with configurable URL | 15 min | 1-3 reports, record pages, dynamic filtering |
| **powerBiReportList** | Multiple reports with search/navigation | 2-3 hours | 5+ reports, scalable catalogs, admin-managed |

### Key Features (Both Components)

✅ Embed Power BI reports directly in Lightning pages  
✅ Responsive design (mobile, tablet, desktop)  
✅ Report reload with automatic cache-busting  
✅ Open in new tab functionality  
✅ Loading spinners and error handling  
✅ Power BI URL filtering support  
✅ No additional Salesforce licenses required  

---

## Quick Start Guide

### Scenario 1: Add One Report ASAP (15 minutes)

**Use:** powerBiReport_Single

```bash
1. Get Power BI embed URL from Power BI Service (File → Embed report)
2. Add component to Lightning page
3. Set reportUrl property to embed URL
4. Set reportName property (optional)
5. Save and activate page
Done!
```

### Scenario 2: Add Multiple Reports (2-3 hours initial)

**Use:** powerBiReportList

```bash
1. Deploy custom object PowerBI_Report__c
2. Deploy PowerBIreportsController Apex class
3. Deploy powerBiReportList component
4. Create PowerBI_Report__c records for your reports
5. Add component to Lightning page
6. Activate page
Done! Future reports take 5 minutes each to add.
```

---

## Component Comparison – Which Should I Use?

### Decision Matrix

| Need | powerBiReport_Single | powerBiReportList |
|------|:----:|:----:|
| **1-3 reports** | ✅ | ✓ |
| **5+ reports** | ⚠️ | ✅ |
| **Fast setup** | ✅ | ⚠️ |
| **Scalable** | ❌ | ✅ |
| **Search functionality** | ❌ | ✅ |
| **Requires Apex** | ❌ | ✅ |
| **Requires custom object** | ❌ | ✅ |
| **Dynamic URL filtering** | ✅ | ⚠️ |
| **Admin-managed** | ❌ | ✅ |

### Quick Decision Guide

**Choose powerBiReport_Single if:**
- You have 1-3 reports
- You need to deploy today
- Reports are on record pages (Account, Opportunity, etc.)
- You want to filter by Salesforce record data
- No DBAs available

**Choose powerBiReportList if:**
- You have 5+ reports
- You're building a report catalog
- You want users to search for reports
- Reports will grow over time
- You have Salesforce admins available

**Effort Comparison:**
```
Setting up 5 reports:
  powerBiReport_Single: 75 minutes (15 min each)
  powerBiReportList: 145 minutes (120 min setup + 25 min for 5 reports)

Setting up 10 reports:
  powerBiReport_Single: 150 minutes (15 min each)
  powerBiReportList: 170 minutes (120 min setup + 50 min for 10 reports)

Setting up 20 reports:
  powerBiReport_Single: 300 minutes (15 min each) ⚠️ Gets painful
  powerBiReportList: 220 minutes (120 min setup + 100 min for 20 reports) ✅ Easy
```

**Breakeven Point:** powerBiReportList becomes faster and easier after 4 reports

---

## powerBiReport_Single – Single Report Component

### Overview

A lightweight component for embedding a single Power BI report. Perfect for record pages where each record needs its own filtered view of Power BI data.

### Files

```
powerBiReport_Single/
├── powerBiReport_Single.html       # Template (63 lines)
├── powerBiReport_Single.js         # Controller (51 lines)
├── powerBiReport_Single.css        # Styling (37 lines)
└── powerBiReport_Single.js-meta.xml # Configuration (19 lines)
Total: 170 lines of code
```

### Configuration Properties

#### reportUrl (Required for display)

**Type:** String  
**Description:** The complete Power BI embed URL

**Where to Get:**
1. Open Power BI Service (app.powerbi.com)
2. Open your report
3. Click **File** → **Embed report** → **Website or portal**
4. Copy the Embed URL
5. Paste into App Builder property

**Example:**
```
https://app.powerbi.com/reportEmbed?reportId=12345678-abcd-1234-abcd-123456789012&groupId=87654321-dcba-4321-dcba-210987654321&autoAuth=true
```

#### reportName (Optional)

**Type:** String  
**Default:** "Power BI Report"

**Description:** Display name shown in component header

**Examples:**
- "Sales Performance Dashboard"
- "Account Revenue Analysis"
- "Pipeline Velocity"

#### urlParameters (Optional, Advanced)

**Type:** String

**Description:** Additional Power BI filters (URL query parameters)

**Format:**
```
filter=Table/Field eq 'value'
```

**Examples:**
```
filter=Accounts/Territory eq 'West'
filter=Sales/Date gt 2025-01-01
filter=Opportunities/Amount gt 50000
```

### Configuration Examples

#### Example 1: Static Report on App Page

```
Component: powerBiReport_Single
reportUrl = https://app.powerbi.com/reportEmbed?reportId=abc123...
reportName = "Sales Dashboard"
```

#### Example 2: Account-Specific Report (Dynamic)

**Step 1: Create Formula Field on Account**

```
Field Name: Power_BI_Report_URL__c
Type: Formula (Text)

Formula:
"https://app.powerbi.com/reportEmbed?reportId=abc123..." &
"&filter=Accounts/Id eq '" & Id & "'"
```

**Step 2: Add Component to Account Record Page**

```
Component: powerBiReport_Single
reportUrl = {!Account.Power_BI_Report_URL__c}
reportName = "Account Performance"
```

**Result:** Each Account page automatically shows filtered data for that account

#### Example 3: Territory-Filtered Report

```
Field: User.Territory_Report_URL__c

Formula:
"https://app.powerbi.com/reportEmbed?reportId=sales123..." &
"&filter=Sales/Territory eq '" & Territory_Name__c & "'"
```

### Public Methods

**reload()**
- Force refresh the Power BI report
- Clears browser cache via timestamp parameter

**openInNewTab()**
- Opens the report in a new browser tab
- Uses native window.open()

### Use Cases

✅ Account record pages with account-specific metrics  
✅ Opportunity pages with deal-specific analytics  
✅ Contact pages with interaction history  
✅ Quick reporting needs (POC, pilot)  
✅ Experience Cloud/Community Cloud portals  
✅ Fixed dashboards for team pages  

### Setup Checklist

- [ ] Get Power BI embed URL
- [ ] Add component to Lightning page
- [ ] Configure reportUrl property
- [ ] Configure reportName property (optional)
- [ ] Configure urlParameters (if using filters)
- [ ] Save and activate page
- [ ] Test on a record

---

## powerBiReportList – Multi-Report Component

### Overview

A feature-rich component for managing multiple Power BI reports in one location. Users can search for and select reports from a sidebar dropdown.

### Files

```
powerBiReportList/
├── powerBiReportList.html       # Template (154 lines)
├── powerBiReportList.js         # Controller (154 lines)
├── powerBiReportList.css        # Styling (122 lines)
└── powerBiReportList.js-meta.xml # Configuration (16 lines)
Total: 446 lines of code
```

### Required: Custom Object (PowerBI_Report__c)

**Purpose:** Central repository for all Power BI reports

**Setup:**
```
Setup → Object Manager → Create

Label: Power BI Report
Plural: Power BI Reports
Object Name: PowerBI_Report__c
```

**Required Fields:**

| Field | Type | Purpose |
|-------|------|---------|
| Display_Name__c | Text(255) | User-friendly report name |
| URL__c | URL or Text(255) | Power BI embed URL |
| Is_Active__c | Checkbox | Controls visibility (default: True) |
| Sort_Order__c | Number(3,0) | Display order (lower first) |

**Optional Fields:**

| Field | Type | Purpose |
|-------|------|---------|
| Category__c | Picklist | Future: grouping by department |
| Description__c | Long Text Area | Admin notes |

**Field Details:**

- **Display_Name__c:** User-friendly name shown in sidebar (e.g., "Sales Pipeline")
- **URL__c:** Complete Power BI embed URL
- **Is_Active__c:** Checked = visible in component, Unchecked = hidden
- **Sort_Order__c:** Display order (10, 20, 30... allows easy reordering)

### Required: Apex Controller

**Class Name:** PowerBIreportsController

**Deploy:** This class is included in the project

**Key Method:**
```apex
@AuraEnabled(cacheable=true)
public static List<ReportPowerBI> getActiveReports()
```

**Features:**
- Retrieves only active reports from PowerBI_Report__c
- Results cached for 30 minutes (improves performance)
- Excludes reports without URLs
- Sorted by Sort_Order__c, then Display_Name__c
- Test class with 100% code coverage

### Configuration Property

#### initialSelection (Optional)

**Type:** String  
**Description:** Display Name of report to show on component load

**Example:**

If you have reports:
- "Sales Dashboard" (Sort Order 10)
- "Marketing ROI" (Sort Order 20)
- "Finance Overview" (Sort Order 30)

```
initialSelection = "Marketing ROI"
→ Marketing ROI loads when component opens (instead of Sales Dashboard)
```

**If not set:** First report by Sort Order loads

### Creating Report Records

**Option 1: Data Loader (Bulk)**

```csv
Display_Name__c,URL__c,Is_Active__c,Sort_Order__c
"Sales Dashboard","https://app.powerbi.com/reportEmbed?reportId=abc123",TRUE,10
"Marketing ROI","https://app.powerbi.com/reportEmbed?reportId=def456",TRUE,20
"Finance Overview","https://app.powerbi.com/reportEmbed?reportId=ghi789",TRUE,30
```

**Option 2: Salesforce UI**

1. Navigate to PowerBI_Report__c tab
2. Click New
3. Fill in fields
4. Save

**Option 3: Anonymous Apex**

```apex
List<PowerBI_Report__c> reports = new List<PowerBI_Report__c>();
reports.add(new PowerBI_Report__c(
    Display_Name__c = 'Sales Dashboard',
    URL__c = 'https://app.powerbi.com/reportEmbed?reportId=...',
    Is_Active__c = true,
    Sort_Order__c = 10
));
insert reports;
```

### Public Methods

**refreshList()**
- Reload reports from Apex
- Clears cached report list

**reload()**
- Refresh currently displayed report

**openInNewTab()**
- Open current report in new browser tab

### Component Features

✅ **Sidebar Navigation** - Click to switch between reports  
✅ **Search Functionality** - Filter reports by name (real-time)  
✅ **Report Count Badge** - Shows "X Reports Available"  
✅ **Reload Button** - Refresh the current report  
✅ **Open in New Tab** - View in full window  
✅ **Loading Spinner** - During initial load  
✅ **Empty State** - Helpful message when no reports  

### Use Cases

✅ Executive report portal (10+ reports)  
✅ Department-specific dashboards  
✅ Scalable report catalogs  
✅ Admin-managed report libraries  
✅ Role-based report access (via sharing rules)  

### Setup Checklist

- [ ] Create PowerBI_Report__c custom object
- [ ] Create required custom fields
- [ ] Deploy PowerBIreportsController Apex class
- [ ] Deploy PowerBIreportsControllerTest Apex class
- [ ] Deploy powerBiReportList component
- [ ] Create PowerBI_Report__c records (one per report)
- [ ] Verify reports appear in component
- [ ] Add component to Lightning page
- [ ] Configure initialSelection (optional)
- [ ] Activate page

---

## Deployment Instructions

### Prerequisites

1. **Salesforce CLI installed** - [Install Salesforce CLI](https://developer.salesforce.com/tools/sfdxcli)
2. **Project cloned** - Clone this repository
3. **Org authenticated** - Authorize your target org

### Step 1: Authenticate Your Org

```bash
sf org login web --alias myorg
```

### Step 2: Deploy Components

**For powerBiReport_Single (only):**
```bash
sf project deploy start --source-dir force-app/main/default/lwc/powerBiReport_Single
```

**For powerBiReportList (requires more):**
```bash
# Deploy custom object
sf project deploy start --source-dir force-app/main/default/objects/PowerBI_Report__c

# Deploy Apex classes
sf project deploy start --source-dir force-app/main/default/classes

# Deploy component
sf project deploy start --source-dir force-app/main/default/lwc/powerBiReportList
```

**Deploy all components:**
```bash
sf project deploy start -o myorg
```

### Step 3: Verify Deployment

```bash
sf project deploy report
```

Look for successful deployment with no errors.

### Step 4: Configure Remote Site Settings

1. Go to **Setup → Security → Remote Site Settings**
2. Click **New Remote Site**
3. Configure:
   - **Remote Site Name:** PowerBI_Service
   - **Remote Site URL:** https://app.powerbi.com
   - **Disable Protocol Security:** Unchecked
4. Click **Save**

### Step 5: Add Component to Lightning Page

1. Navigate to **Lightning App Builder**
2. Edit desired Lightning page
3. Search for "powerBi" in Components panel
4. Drag component onto page
5. Configure properties:
   - **powerBiReport_Single:** Set reportUrl and reportName
   - **powerBiReportList:** Set initialSelection (optional)
6. Click **Save**
7. Click **Activate**

### Step 6: Assign Permissions (if using powerBiReportList)

1. Navigate to **Setup → Permission Sets**
2. Create new permission set named "Power_BI_Reports_User"
3. Configure:
   - Object Settings → PowerBI_Report__c → Read ✓
   - Apex Class Access → PowerBIreportsController ✓
4. Assign to users who need access

---

## Usage Examples

### Example 1: Add Report to Account Page (5 minutes)

**Goal:** Show Power BI metrics for each Account

```
1. Get Power BI embed URL
2. Add powerBiReport_Single to Account Record Page
3. reportUrl = https://...
4. reportName = "Account Metrics"
5. Save and activate
Done!
```

### Example 2: Executive Dashboard Portal (2 hours)

**Goal:** 20+ reports accessible from one dashboard

```
1. Deploy powerBiReportList component (done via deployment)
2. Deploy PowerBIreportsController Apex class (done)
3. Create PowerBI_Report__c records:
   - Sales Dashboard (Sort 10)
   - Marketing ROI (Sort 20)
   - Finance Overview (Sort 30)
   ... etc for 20 reports
4. Add component to App Page
5. Activate page
Done! Users can search and switch between all 20 reports.
```

### Example 3: Territory Sales Dashboard (30 minutes)

**Goal:** Sales reps see their territory's Power BI data

**Step 1: Create Formula Field on User**

```apex
// Field: Territory_Report_URL__c

"https://app.powerbi.com/reportEmbed?reportId=sales123..." &
"&filter=Sales/Territory eq '" & Territory_Name__c & "'"
```

**Step 2: Add Component to User Dashboard**

```
Component: powerBiReport_Single
reportUrl = {!$User.Territory_Report_URL__c}
reportName = "My Territory Sales"
```

**Result:** Each user sees their territory data

### Example 4: Multiple Fixed Reports on Dashboard (45 minutes)

**Goal:** Show 3 reports on team dashboard (fixed layout)

```
Layout: Three columns

Column 1:
  powerBiReport_Single
  reportName = "Sales Pipeline"

Column 2:
  powerBiReport_Single
  reportName = "Forecast"

Column 3:
  powerBiReport_Single
  reportName = "Territory Analysis"

Why this instead of powerBiReportList?
  - Only 3 reports (fixed needs)
  - Team knows which reports they want
  - No need to search
  - Simpler to understand and maintain
```

---

## Advanced Configuration

### Dynamic Filtering with Multiple Fields

```apex
// Field: Opportunity.Sales_Report_URL__c
// Filter by stage AND owner AND amount

"https://app.powerbi.com/reportEmbed?reportId=opp123..." &
"&filter=Opportunities/StageName eq '" & StageName & 
"' and Opportunities/OwnerId eq '" & OwnerId & 
"' and Opportunities/Amount gt " & Amount
```

### Combining Reports from Separate Workspaces

If your reports are spread across multiple Power BI workspaces, you can still manage them in one PowerBI_Report__c object:

```sql
INSERT INTO PowerBI_Report__c (
  Display_Name__c,
  URL__c,
  Sort_Order__c
) VALUES (
  'Sales Dashboard',
  'https://app.powerbi.com/reportEmbed?reportId=xxx&groupId=aaa...',
  10
), (
  'Marketing ROI',
  'https://app.powerbi.com/reportEmbed?reportId=yyy&groupId=bbb...',
  20
);
```

Each URL includes its own groupId, so reports can come from different workspaces.

### Row-Level Security (Power BI)

If you need users to see different data in the same report:

1. Create roles in Power BI Desktop
2. Define DAX filters on roles
3. Publish to Power BI Service
4. Assign users to roles
5. Add URL parameter with username:

```apex
"&filter=Users/Email eq '" & $User.Email & "'"
```

### Scaling from 5 to 50+ Reports

**Best Practice Setup:**

```
Organization by Category:

Sales (Sort 10-49):
  10 - Sales Pipeline
  20 - Sales Forecast
  30 - Territory Analysis
  ... etc

Marketing (Sort 50-99):
  50 - Campaign Performance
  60 - Lead Generation
  ... etc

Finance (Sort 100-149):
  100 - Revenue Overview
  110 - Budget Analysis
  ... etc
```

Using increments of 10 allows easy insertion of new reports without renumbering.

---

## Troubleshooting

### Problem: Report Not Loading

**Checklist:**
- [ ] Is embed URL correct? (Test in browser)
- [ ] Does URL include &autoAuth=true?
- [ ] Is reportId correct? (Match Power BI Service)
- [ ] Is groupId correct? (Match report's workspace)
- [ ] Is Remote Site Settings configured? (Setup → Remote Site Settings)

**Solution:**
1. Copy embed URL from component property
2. Paste into new browser tab
3. Does it load? 
   - YES → Issue is Salesforce configuration
   - NO → Issue is Power BI URL

### Problem: Component Not Appearing

**Checklist:**
- [ ] Is component deployed? (Setup → Lightning Components)
- [ ] Is page activated? (App Builder shows "Active")
- [ ] Do you have permission set? (For powerBiReportList)
- [ ] Is page target correct? (AppPage vs RecordPage)

**Solution:**
1. Go to Setup → Lightning Components
2. Search for "powerBi"
3. Verify component appears in list
4. Go to App Builder
5. Verify page status is "Active"

### Problem: Search Not Working (powerBiReportList)

**Checklist:**
- [ ] Are reports in PowerBI_Report__c? (Check records)
- [ ] Are they marked Is_Active = true? (Check checkbox)
- [ ] Did Apex deploy successfully? (Check debug logs)
- [ ] Check browser console for errors (F12)

**Solution:**
1. Open browser DevTools (F12)
2. Go to Console tab
3. Check for JavaScript errors
4. Verify Apex method returned data (Network tab)

### Problem: Cache Not Refreshing

**Checklist:**
- [ ] Are you waiting 30+ minutes? (Apex cache duration)
- [ ] Did you hard-refresh browser? (Cmd+Shift+R)
- [ ] Is the record actually updated? (Check in Salesforce)

**Solution:**
1. Hard refresh browser (Cmd+Shift+R on Mac, Ctrl+Shift+R on Windows)
2. Wait for Apex cache to expire (30 minutes)
3. Or modify PowerBIreportsController.cls and redeploy to flush cache

### Accessing Debug Logs

```bash
# Fetch debug logs via CLI
sf apex log list

# Stream debug logs
sf apex log stream
```

Check logs for "Apex error" messages if Apex method fails.

---

## Performance Optimization

### powerBiReport_Single

- Uses pure LWC (no Apex) = fast
- Single iframe = minimal overhead
- Cache-busting via timestamp = always fresh

**No optimization needed** - component is inherently fast

### powerBiReportList

- Apex method uses `cacheable=true` = 30-min cache
- Results cached at platform level = very fast after first load
- Query limited to active reports only = efficient

**Optimization tips:**
- Create index on Is_Active__c and Sort_Order__c fields
- Limit PowerBI_Report__c to essential reports (prune inactive)
- Use Power BI Premium for faster embed loading

---

## Security Considerations

### Embed URL Protection

⚠️ Embed URLs contain sensitive identifiers (reportId, groupId)

**Best Practices:**
- Store URLs in custom object (not static resources)
- Apply Salesforce sharing rules to PowerBI_Report__c
- Don't commit URLs to version control
- Use HTTPS only (automatic with Power BI Service)
- Consider Row-Level Security in Power BI if showing sensitive data

### Permissions

**For powerBiReport_Single:**
- Users need access to the Lightning page
- No additional Salesforce object access required
- Power BI handles authentication via autoAuth parameter

**For powerBiReportList:**
- Users need access to the Lightning page
- Users need READ access to PowerBI_Report__c object
- Assign "Power_BI_Reports_User" permission set
- Use sharing rules to control which reports visible

### Row-Level Security

If reports contain sensitive data that should be user-specific:

1. Configure Row-Level Security in Power BI Service
2. Add filter parameter to URL:
   ```
   &filter=Users/Email eq '{!$User.Email}'
   ```
3. Ensure Power BI RLS roles are assigned correctly

---

## File Structure

```
powerBIEmbedded/
├── force-app/main/default/
│   ├── classes/
│   │   ├── PowerBIreportsController.cls       # Apex controller
│   │   ├── PowerBIreportsController.cls-meta.xml
│   │   ├── PowerBIreportsControllerTest.cls   # Apex tests (100% coverage)
│   │   └── PowerBIreportsControllerTest.cls-meta.xml
│   ├── lwc/
│   │   ├── powerBiReportList/                 # Multi-report component
│   │   │   ├── powerBiReportList.html
│   │   │   ├── powerBiReportList.js
│   │   │   ├── powerBiReportList.css
│   │   │   └── powerBiReportList.js-meta.xml
│   │   └── powerBiReport_Single/              # Single report component
│   │       ├── powerBiReport_Single.html
│   │       ├── powerBiReport_Single.js
│   │       ├── powerBiReport_Single.css
│   │       └── powerBiReport_Single.js-meta.xml
│   └── objects/
│       └── PowerBI_Report__c/                 # Custom object (powerBiReportList only)
│           └── fields/
│               ├── Display_Name__c.field-meta.xml
│               ├── URL__c.field-meta.xml
│               ├── Is_Active__c.field-meta.xml
│               ├── Sort_Order__c.field-meta.xml
│               ├── Category__c.field-meta.xml
│               └── Description__c.field-meta.xml
├── sfdx-project.json
├── package.json
└── README.md                                   # This file
```

---

## Support & Resources

### External Resources

- [Power BI Embed URLs - Microsoft Learn](https://learn.microsoft.com/en-us/power-bi/developer/embedded/embedding-content)
- [Power BI URL Filters - Microsoft Learn](https://learn.microsoft.com/en-us/power-bi/collaborate-share/service-url-filters)
- [Lightning Web Components - Salesforce Developer](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [Apex Developer Guide - Salesforce Developer](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/)
- [Salesforce CLI - Salesforce Developer](https://developer.salesforce.com/tools/sfdxcli)

### Getting Help

For issues or questions:

1. Check the **Troubleshooting** section above
2. Check browser console for JavaScript errors (F12)
3. Check Salesforce debug logs for Apex errors
4. Verify all prerequisites are met
5. Try hard-refreshing your browser (Cmd+Shift+R)

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 2.0 | November 18, 2025 | Complete rewrite with consolidated documentation, detailed component guides, decision framework, and troubleshooting |
| 1.0 | Original | Initial implementation |

---

## License

This project is provided as-is for use in Salesforce environments.

---

## Summary

### You Have Two Choices:

**powerBiReport_Single** (Fast & Simple)
```
Setup: 15 minutes per report
Best: 1-3 reports, record pages, dynamic filtering
Example: Show sales metrics on each Account page
```

**powerBiReportList** (Scalable & Admin-Friendly)
```
Setup: 120 minutes initial + 5 minutes per report
Best: 5+ reports, catalogs, search/discovery
Example: Executive portal with 20+ reports
```

### Start Here:

1. Decide which component fits your needs (use comparison above)
2. Deploy the component(s) via Salesforce CLI
3. Configure properties in Lightning App Builder
4. Test on a Lightning page
5. Share with your users

**Questions?** See [Troubleshooting](#troubleshooting) or review the detailed documentation files.

---

**Last Updated:** November 18, 2025  
**Documentation Version:** 2.0

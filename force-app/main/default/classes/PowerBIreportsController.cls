/**
* @Name 			:   	PowerBIreportsController
* @Description 		:   	This class is used to return the Power BI reports for the LWC Power BI reports component
* @Test Class 		:   	PowerBIreportsControllerTest
* @Author 			:   	Kelley Austin
*==============================================================================
* Ver         Date                     Author      		      Modification
*==============================================================================
* 1.0 	09.03.2025 	              Kelley Austin 		       Initial Build
**/
public with sharing class PowerBIreportsController {
    public class ReportPowerBI {
        @AuraEnabled public String name;
        @AuraEnabled public String url;
        public ReportPowerBI(String n, String u) { name = n; url = u; }
    }

    @AuraEnabled(cacheable=true)
    public static List<ReportPowerBI> getActiveReports() {

        List<Power_BI_reports__c> rows = [
            SELECT Name, Report_Link__c, Active__c
            FROM Power_BI_reports__c
            WHERE Active__c = true AND Report_Link__c != null
            ORDER BY Name
            LIMIT 2000
        ];

        List<ReportPowerBI> out = new List<ReportPowerBI>();
        for (Power_BI_reports__c r : rows) {
            out.add(new ReportPowerBI(r.Name, r.Report_Link__c));
        }
        return out;
    }
}
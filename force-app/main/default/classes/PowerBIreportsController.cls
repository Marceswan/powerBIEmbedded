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

        List<PowerBI_Report__c> rows = [
            SELECT Display_Name__c, URL__c, Sort_Order__c
            FROM PowerBI_Report__c
            WHERE Is_Active__c = true AND URL__c != null
            ORDER BY Sort_Order__c ASC NULLS LAST, Display_Name__c ASC
            LIMIT 2000
        ];

        List<ReportPowerBI> out = new List<ReportPowerBI>();
        for (PowerBI_Report__c r : rows) {
            out.add(new ReportPowerBI(r.Display_Name__c, r.URL__c));
        }
        return out;
    }
}
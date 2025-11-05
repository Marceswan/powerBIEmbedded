@IsTest
private class PowerBIreportsControllerTest {

    // Helper to create test rows
    private static Power_BI_reports__c makeRow(String name, Boolean isActive, String link) {
        Power_BI_reports__c rec = new Power_BI_reports__c();
        rec.Name = name;
        rec.Active__c = isActive;
        rec.Report_Link__c = link;
        return rec;
    }

    @IsTest
    static void testGetActiveReports_filtersAndOrdering() {
        // Arrange
        List<Power_BI_reports__c> rows = new List<Power_BI_reports__c>{
            // Should be INCLUDED (active + has link)
            makeRow('Alpha Report', true,  'https://alpha.example.com'),
            makeRow('Zulu Report',  true,  'https://zulu.example.com'),
            makeRow('Beta Report',  true,  'https://beta.example.com'),
            // Should be EXCLUDED
            makeRow('Inactive Report', false, 'https://inactive.example.com'),
            makeRow('Null Link Report', true, null)
        };
        insert rows;

        // Act
        Test.startTest();
        List<PowerBIreportsController.ReportPowerBI> out =
            PowerBIreportsController.getActiveReports();
        Test.stopTest();

        // Assert
        // Expect only the 3 active records that have a non-null link
        System.assertEquals(3, out.size(), 'Only active reports with non-null links should be returned.');

        // Assert ordering by Name ascending: Alpha, Beta, Zulu
        System.assertEquals('Alpha Report', out[0].name, 'First should be Alpha by Name ordering.');
        System.assertEquals('Beta Report',  out[1].name, 'Second should be Beta by Name ordering.');
        System.assertEquals('Zulu Report',  out[2].name, 'Third should be Zulu by Name ordering.');

        // Assert URL mapping (DTO fields)
        System.assertEquals('https://alpha.example.com', out[0].url, 'Alpha URL should map correctly.');
        System.assertEquals('https://beta.example.com',  out[1].url, 'Beta URL should map correctly.');
        System.assertEquals('https://zulu.example.com',  out[2].url, 'Zulu URL should map correctly.');
    }

}
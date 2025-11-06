@IsTest
private class PowerBIreportsControllerTest {

    // Helper to create test rows
    private static PowerBI_Report__c makeRow(String displayName, Boolean isActive, String url, Decimal sortOrder) {
        PowerBI_Report__c rec = new PowerBI_Report__c();
        rec.Display_Name__c = displayName;
        rec.Is_Active__c = isActive;
        rec.URL__c = url;
        rec.Sort_Order__c = sortOrder;
        return rec;
    }

    @IsTest
    static void testGetActiveReports_filtersAndOrdering() {
        // Arrange
        List<PowerBI_Report__c> rows = new List<PowerBI_Report__c>{
            // Should be INCLUDED (active + has URL) - note Sort_Order determines final order
            makeRow('Alpha Report', true,  'https://alpha.example.com', 30),
            makeRow('Zulu Report',  true,  'https://zulu.example.com', 10),
            makeRow('Beta Report',  true,  'https://beta.example.com', 20),
            // Should be EXCLUDED
            makeRow('Inactive Report', false, 'https://inactive.example.com', 40),
            makeRow('Null URL Report', true, null, 50)
        };
        insert rows;

        // Act
        Test.startTest();
        List<PowerBIreportsController.ReportPowerBI> out =
            PowerBIreportsController.getActiveReports();
        Test.stopTest();

        // Assert
        // Expect only the 3 active records that have a non-null URL
        System.assertEquals(3, out.size(), 'Only active reports with non-null URLs should be returned.');

        // Assert ordering by Sort_Order__c ascending: Zulu (10), Beta (20), Alpha (30)
        System.assertEquals('Zulu Report',  out[0].name, 'First should be Zulu (Sort_Order__c = 10).');
        System.assertEquals('Beta Report',  out[1].name, 'Second should be Beta (Sort_Order__c = 20).');
        System.assertEquals('Alpha Report', out[2].name, 'Third should be Alpha (Sort_Order__c = 30).');

        // Assert URL mapping (DTO fields)
        System.assertEquals('https://zulu.example.com',  out[0].url, 'Zulu URL should map correctly.');
        System.assertEquals('https://beta.example.com',  out[1].url, 'Beta URL should map correctly.');
        System.assertEquals('https://alpha.example.com', out[2].url, 'Alpha URL should map correctly.');
    }

}
@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here
    static testMethod void positiveResultTest(){
        //Creation of Account
        Account acc = new Account();
        acc.Name = 'Some Account';
        insert acc;
        //Creation of Contact
        Contact con = new Contact();
        con.FirstName = 'Some';
        con.LastName = 'Contact';
        con.Email = 'somecontact@email.com';
        con.Phone = '782777222';
        con.AccountId = acc.Id;
        insert con;
        //Creation of vehicule
        Vehicle__c vehic = new Vehicle__c();
        vehic.Name = 'VEH 0001'; 
        insert vehic;
        //Creation of equipment
        List<Product2> lstEquipments = new List<Product2>();
        Product2 equipment = new Product2();
        equipment.Name = 'Generator 1000 kW';
        equipment.IsActive = true;
        equipment.Cost__c = 100;
        equipment.Current_Inventory__c = 20;
        equipment.Lifespan_Months__c = 20;
        equipment.Maintenance_Cycle__c = 10;
        equipment.Replacement_Part__c = true;
        equipment.Warehouse_SKU__c = '100003';
        lstEquipments.add(equipment);
        Product2 equipment2 = new Product2();
        equipment2.Name = 'Generator 1000 kW1';
        equipment2.IsActive = true;
        equipment2.Cost__c = 100;
        equipment2.Current_Inventory__c = 20;
        equipment2.Lifespan_Months__c = 20;
        equipment2.Maintenance_Cycle__c = 5;
        equipment2.Replacement_Part__c = true;
        equipment2.Warehouse_SKU__c = '100004';
        lstEquipments.add(equipment2);
        insert lstEquipments;
        //Creation of Maintenance Request
        Case newMr = new Case();
        newMr.Vehicle__c = vehic.Id;
        newMr.Status = 'New';
        newMr.Type = 'Routine Maintenance';
        newMr.Subject = 'Some subject';
        newMr.Priority = 'Low';
        newMr.Equipment__c = equipment.Id;
        newMr.ContactId = con.Id;
        newMr.AccountId = acc.Id;
        newMr.Origin = 'Web';
        newMr.Reason = 'Equipment Design';
        newMr.Date_Reported__c = System.now().date().addMonths(-1) ; 
        insert newMr;
        //Creation of related Work Part
        List<Work_Part__c> lstWorkParts = new List<Work_Part__c>();
        Work_Part__c wp = new Work_Part__c();
        wp.Equipment__c = equipment.Id;
        wp.Quantity__c = 1;
        wp.Maintenance_Request__c = newMr.Id;
        Work_Part__c wp2 = new Work_Part__c();
        wp2.Equipment__c = equipment2.Id;
        wp2.Quantity__c = 1;
        wp2.Maintenance_Request__c = newMr.Id;
        lstWorkParts.add(wp);
        lstWorkParts.add(wp2);
        insert lstWorkParts;
        //Beggining of test
        Test.startTest();
        newMr.Status = 'Closed';
        update newMr;
        List<Case> lstMaintenanceRequests = new List<Case>([SELECT Id,Vehicle__c,Equipment__c,Date_Due__c FROM Case ORDER BY Date_Reported__c DESC LIMIT 1]);
        System.assertEquals(1, lstMaintenanceRequests.size() );
        System.assertEquals(newMr.Vehicle__c, lstMaintenanceRequests.get(0).Vehicle__c );
        System.assertEquals(newMr.Equipment__c, lstMaintenanceRequests.get(0).Equipment__c );
        System.assertEquals( System.now().date().addDays(5) , lstMaintenanceRequests.get(0).Date_Due__c );
        Test.stopTest();
    }

    static testMethod void negativeResultTest(){
        //Creation of Account
        Account acc = new Account();
        acc.Name = 'Some Account';
        insert acc;
        //Creation of Contact
        Contact con = new Contact();
        con.FirstName = 'Some';
        con.LastName = 'Contact';
        con.Email = 'somecontact@email.com';
        con.Phone = '782777222';
        con.AccountId = acc.Id;
        insert con;
        //Creation of vehicule
        Vehicle__c vehic = new Vehicle__c();
        vehic.Name = 'VEH 0001'; 
        insert vehic;
        //Creation of equipment
        List<Product2> lstEquipments = new List<Product2>();
        Product2 equipment = new Product2();
        equipment.Name = 'Generator 1000 kW';
        equipment.IsActive = true;
        equipment.Cost__c = 100;
        equipment.Current_Inventory__c = 20;
        equipment.Lifespan_Months__c = 20;
        equipment.Maintenance_Cycle__c = 10;
        equipment.Replacement_Part__c = true;
        equipment.Warehouse_SKU__c = '100003';
        lstEquipments.add(equipment);
        Product2 equipment2 = new Product2();
        equipment2.Name = 'Generator 1000 kW1';
        equipment2.IsActive = true;
        equipment2.Cost__c = 100;
        equipment2.Current_Inventory__c = 20;
        equipment2.Lifespan_Months__c = 20;
        equipment2.Maintenance_Cycle__c = 5;
        equipment2.Replacement_Part__c = true;
        equipment2.Warehouse_SKU__c = '100004';
        lstEquipments.add(equipment2);
        insert lstEquipments;
        //Creation of Maintenance Request
        Case newMr = new Case();
        newMr.Vehicle__c = vehic.Id;
        newMr.Status = 'New';
        newMr.Type = 'Routine Maintenance';
        newMr.Subject = 'Some subject';
        newMr.Priority = 'Low';
        newMr.Equipment__c = equipment.Id;
        newMr.ContactId = con.Id;
        newMr.AccountId = acc.Id;
        newMr.Origin = 'Web';
        newMr.Reason = 'Equipment Design';
        newMr.Date_Reported__c = System.now().date().addMonths(-1) ; 
        insert newMr;
        //Creation of related Work Part
        List<Work_Part__c> lstWorkParts = new List<Work_Part__c>();
        Work_Part__c wp = new Work_Part__c();
        wp.Equipment__c = equipment.Id;
        wp.Quantity__c = 1;
        wp.Maintenance_Request__c = newMr.Id;
        Work_Part__c wp2 = new Work_Part__c();
        wp2.Equipment__c = equipment2.Id;
        wp2.Quantity__c = 1;
        wp2.Maintenance_Request__c = newMr.Id;
        lstWorkParts.add(wp);
        lstWorkParts.add(wp2);
        insert lstWorkParts;
        //Beggining of test
        Test.startTest();
        newMr.Type = 'Repair';
        update newMr;
        List<Case> lstMaintenanceRequests = new List<Case>([SELECT Id,Vehicle__c,Equipment__c,Date_Due__c FROM Case WHERE Date_Reported__c = TODAY LIMIT 1]);
        System.assertEquals(0, lstMaintenanceRequests.size() );
        Test.stopTest();
    }

    static testMethod void bulkResultTest(){
        //Creation of Account
        Account acc = new Account();
        acc.Name = 'Some Account';
        insert acc;
        //Creation of Contact
        Contact con = new Contact();
        con.FirstName = 'Some';
        con.LastName = 'Contact';
        con.Email = 'somecontact@email.com';
        con.Phone = '782777222';
        con.AccountId = acc.Id;
        insert con;
        //Creation of vehicule
        Vehicle__c vehic = new Vehicle__c();
        vehic.Name = 'VEH 0001'; 
        insert vehic;
        //Creation of equipment
        List<Product2> lstEquipments = new List<Product2>();
        Product2 equipment = new Product2();
        equipment.Name = 'Generator 1000 kW';
        equipment.IsActive = true;
        equipment.Cost__c = 100;
        equipment.Current_Inventory__c = 20;
        equipment.Lifespan_Months__c = 20;
        equipment.Maintenance_Cycle__c = 10;
        equipment.Replacement_Part__c = true;
        equipment.Warehouse_SKU__c = '100003';
        lstEquipments.add(equipment);
        insert lstEquipments;
        //Creation of Maintenance Request
        List<Case> lstNewMR = new List<Case>();
        for( Integer i=0; i<300 ;i++ ){
            Case newMr = new Case();
            newMr.Vehicle__c = vehic.Id;
            newMr.Status = 'New';
            newMr.Type = 'Routine Maintenance';
            newMr.Subject = 'Some subject';
            newMr.Priority = 'Low';
            newMr.Equipment__c = equipment.Id;
            newMr.ContactId = con.Id;
            newMr.AccountId = acc.Id;
            newMr.Origin = 'Web';
            newMr.Reason = 'Equipment Design';
            newMr.Date_Reported__c = System.now().date().addMonths(-1) ; 
            lstNewMR.add(newMr);
        }
        insert lstNewMR;
        //Beggining of test
        Test.startTest();
        for( Integer i=0;i<lstNewMR.size();i++ ){
            lstNewMR.get(i).Status='Closed';
        }
        update lstNewMR;
        List<Case> lstMaintenanceRequests = new List<Case>([SELECT Id FROM Case WHERE Date_Reported__c = TODAY]);
        System.assertEquals(300, lstMaintenanceRequests.size() );
        Test.stopTest();
    }

    static testMethod void calloutResultTest(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        Test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();
        List<Product2> lstProductsInCallout = new List<Product2>([ SELECT Id,Name FROM Product2 WHERE Name = 'Generator 1000 kW 123' ]);
        System.assertEquals(1, lstProductsInCallout.size() );
    }

    static testMethod void syncScheduledResultTest(){
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        WarehouseSyncSchedule wss = new WarehouseSyncSchedule();
        String sch = '0 0 1 * * ?';
        String jobID = System.schedule('Scheduled service 1:00 AM test', sch, wss);
        Test.startTest();
        System.assertNotEquals(null, jobID);
        Test.stopTest();
    }

}

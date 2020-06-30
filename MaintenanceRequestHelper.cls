public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders( List<Case> lstMaintanceRequest  ) {
        // TODO: Complete the method to update workorders
        //Creation of variables that we will use in the whole process
        Map<Id,Case> mapNewMaintanceRequest = new Map<Id,Case>();
        Map<Id,List<Work_Part__c>> mapWorkPartsByMaintenance = new Map<Id,List<Work_Part__c>>();
        Set<Id> setAllRMIds = new Set<Id>();

        for(Case mr : lstMaintanceRequest){
            setAllRMIds.add(mr.Id);
        }

        //Creation of the new Maintenance Request
        for( Case mr : [SELECT Id,Vehicle__c,Type,Status,Subject,Priority,AccountId,Origin,Reason,ContactId,Equipment__c FROM Case WHERE Id IN :setAllRMIds ] ){
            if( (mr.Type == 'Repair' || mr.Type == 'Routine Maintenance') && mr.Status == 'Closed'  ){
                Case newMr = new Case();
                newMr.Vehicle__c = mr.Vehicle__c;
                newMr.Status = 'New';
                newMr.Type = 'Routine Maintenance';
                newMr.Subject = mr.Subject;
                newMr.Priority = mr.Priority;
                newMr.Equipment__c = mr.Equipment__c;
                newMr.ContactId = mr.ContactId;
                newMr.AccountId = mr.AccountId;
                newMr.Origin = mr.Origin;
                newMr.Reason = mr.Reason;
                newMr.Date_Reported__c = System.now().date() ;
                mapNewMaintanceRequest.put(mr.Id,newMr);
            }
        }

        //Validate if we have some new Maintenance request
        if( mapNewMaintanceRequest.size() >0 ){
            //Get the work parts related to the Maintenance Request
            List<Work_Part__c> lstWorkParts = new List<Work_Part__c>([  SELECT Id,Maintenance_Request__c,Quantity__c,Equipment__c,Equipment__r.Lifespan_Months__c,Equipment__r.Maintenance_Cycle__c  
                                                                        FROM Work_Part__c 
                                                                        WHERE Maintenance_Request__c IN :mapNewMaintanceRequest.keySet() ]);
            
            //Obtain the shortest Maintenance Cycle
            //Create the new Work Parts records
            for( Id idMR : mapNewMaintanceRequest.keySet()  ){
                mapWorkPartsByMaintenance.put(idMR,new List<Work_Part__c>() );
                Integer shortestMaintanceCycle = 0;
                Integer flag = 0;
                for( Work_Part__c wp : lstWorkParts ){
                    if( idMR == wp.Maintenance_Request__c ){
                        Integer equipmentMaintenanceCycle = Integer.valueOf(wp.Equipment__r.Maintenance_Cycle__c);
                        if( flag == 0 ){
                            shortestMaintanceCycle = equipmentMaintenanceCycle;
                            flag++;
                        }else{
                            if( equipmentMaintenanceCycle < shortestMaintanceCycle ){
                                shortestMaintanceCycle = equipmentMaintenanceCycle;
                            }
                        }
                        Work_Part__c newWP = new Work_Part__c();
                        newWP.Equipment__c = wp.Equipment__c;
                        newWP.Quantity__c = wp.Quantity__c;   
                        mapWorkPartsByMaintenance.get(idMR).add(newWP);                  
                    }
                }
                mapNewMaintanceRequest.get(idMR).Date_Due__c = System.now().date().addDays(shortestMaintanceCycle);
            }

            //Insertion of the New Maintenance Request
            insert mapNewMaintanceRequest.values();

            //Add the Id to the work parts records
            List<Work_Part__c> lstNewWorkParts = new List<Work_Part__c>();
            for( Id idOldMR : mapNewMaintanceRequest.keySet() ){
                Integer lstWPSize = mapWorkPartsByMaintenance.get(idOldMR).size();
                if( lstWPSize>0 ){
                    Id idNewMR = mapNewMaintanceRequest.get(idOldMR).Id;
                    for( Integer i=0; i<lstWPSize ;i++ ){
                        mapWorkPartsByMaintenance.get(idOldMR).get(i).Maintenance_Request__c = idNewMR;
                        lstNewWorkParts.add( mapWorkPartsByMaintenance.get(idOldMR).get(i) );
                    }
                }
            }

            if( lstNewWorkParts.size()>0 ){
                insert lstNewWorkParts;
            }
        }
        
    }        
    
}

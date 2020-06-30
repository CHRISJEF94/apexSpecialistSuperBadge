public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    public class Equipment {
        public String id;
        public Boolean replacement;
        public Integer quantity;
        public String name;
        public Integer maintenanceperiod;
        public Integer lifespan;
        public Double cost;
        public String sku;
    }

    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        //ToDo: complete this method to make the callout (using @future) to the
        //      REST endpoint and update equipment on hand.
        List<Product2> lstFinalEquipments = new List<Product2>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            String dataResponse = response.getBody().replace('_id', 'id');
            List<Equipment> lstEquipments = (List<Equipment>)JSON.deserialize(dataResponse, List<Equipment>.class );
            for(Equipment eqp : lstEquipments){
                Product2 finalEquipment = new Product2();
                finalEquipment.ExternalId = eqp.id;
                finalEquipment.Name = eqp.name;
                finalEquipment.Replacement_Part__c = true;
                finalEquipment.Cost__c = eqp.cost ;
                finalEquipment.Current_Inventory__c = eqp.quantity ;
                finalEquipment.Lifespan_Months__c = eqp.lifespan ;
                finalEquipment.Maintenance_Cycle__c = eqp.maintenanceperiod ;
                finalEquipment.Warehouse_SKU__c = eqp.sku;
                lstFinalEquipments.add(finalEquipment);
            }
            if( lstFinalEquipments.size()>0 ){
                List<Database.UpsertResult> results = Database.upsert(lstFinalEquipments, Product2.Warehouse_SKU__c, false);
            }
        }
    }
}

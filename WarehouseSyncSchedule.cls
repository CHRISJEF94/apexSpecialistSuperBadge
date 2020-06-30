global class WarehouseSyncSchedule Implements Schedulable {
    // implement scheduled code here
    global void execute(SchedulableContext ctx) {
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }
}

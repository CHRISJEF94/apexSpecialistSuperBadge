trigger MaintenanceRequest on Case (before update, after update) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    if( trigger.isUpdate ){
        if( trigger.isAfter ){
            MaintenanceRequestHelper.updateWorkOrders( trigger.new );
        }
    }
}

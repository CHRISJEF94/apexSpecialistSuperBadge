global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    // implement http mock callout
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"Generator 1000 kW 123","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"100003"}]');
        res.setStatusCode(200);
        return res;
    }

}

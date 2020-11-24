public with sharing class EventController {

    @AuraEnabled
    public static void getFields() {
        System.debug('logic here');
    }
}

@IsTest
public with sharing class EventControllerTest {

    private static String INVALID_AMOUNT = 'Actual amount does not equal to expected.';
    private static String INVALID_ID = 'Actual Id does not equal to expected.';

    @IsTest
    static void getFieldsTest(){
        //The value depends on the FieldSet.
        List<FieldWrapper> fields = EventController.getFields();
        for(Integer i=0; i<fields.size(); i++){
            if(fields[i].Type == 'BOOLEAN'){
                SObject sobj;
                fields[i].Value = sobj;
            }
        }
        System.assertEquals(8, fields.size(), INVALID_AMOUNT);
    }

    @IsTest
    static void getEventTest(){
        Datetime start = Datetime.valueOf('2020-02-02 01:00:00');
        Datetime finish = Datetime.valueOf('2020-02-03 01:00:00');
        Event newEvent = new Event(StartDateTime = start, EndDateTime = finish);
        insert newEvent;

        Event event = EventController.getEvent(newEvent.Id);
        System.assertEquals(newEvent.Id, event.Id, INVALID_ID);
    }

    @IsTest
    static void testUpdate(){
        Datetime start = Datetime.valueOf('2020-02-02 01:00:00');
        Datetime finish = Datetime.valueOf('2020-02-03 01:00:00');
        Date date1 = Date.valueOf('2020-10-10');
        Event newEvent = new Event(StartDateTime = start, EndDateTime = finish, Custom_Number__c = 1,
        Custom_Text__c = 'text', Custom_Date__c = date1, Custom_Checkbox__c = false, Custom_Picklist__c = 'value 1');
        insert newEvent;

        List<String> namesInfo = new List<String>{'EndDateTime', 'Custom_Number__c', 'Custom_Text__c', 'Custom_Date__c', 'Custom_Checkbox__c', 'Custom_Picklist__c'};
        List<String> valuesInfo = new List<String>{'2020-02-04 01:00:00', '2', 'text1' , '2020-10-11', 'true', 'value 2'};
        List<String> typesInfo = new List<String>{'datetime', 'number', 'text', 'date', 'checkbox', 'COMBOBOX'};

        EventController.updateEvent(newEvent.Id, namesInfo, valuesInfo, typesInfo);
        List<Event> events = [SELECT Id, EndDateTime FROM Event];
        Datetime dt = Datetime.valueOf('2020-02-04 01:00:00');
        System.assertEquals(dt, events[0].EndDateTime, INVALID_AMOUNT);
    }

    @IsTest
    static void testInsert(){
        List<String> namesInfo = new List<String>{'StartDateTime', 'EndDateTime'};
        List<String> valuesInfo = new List<String>{'2020-02-02 01:00:00', '2020-02-03 01:00:00'};
        List<String> typesInfo = new List<String>{'datetime', 'datetime'};

        String newId = EventController.insertEvent(namesInfo, valuesInfo, typesInfo);
        List<Event> events = [SELECT Id FROM Event];
        System.assertEquals(1, events.size(), INVALID_AMOUNT);
    }
}

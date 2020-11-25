public with sharing class EventController {

    @AuraEnabled
    public static List<FieldWrapper> getFields() {
        //hardcode CustomFieldSet name
        List<FieldWrapper> fields = new List<FieldWrapper>();
        List<Schema.FieldSetMember> fieldSetMembers = SObjectType.Event.FieldSets.CustomFieldSet.getFields();

        for(Schema.FieldSetMember field: fieldSetMembers){
            Schema.DescribeFieldResult fieldDescribe = field.getSObjectField().getDescribe();
            String fieldName = fieldDescribe.getName();
            String fieldLabel = fieldDescribe.getLabel();
            String fieldType = fieldDescribe.getType().name();
            
            FieldWrapper newFiled = new FieldWrapper(fieldName, fieldLabel, fieldType);
            fields.add(newFiled);
        }

        return fields;
    }

    @AuraEnabled
    public static Event getEvent(Id recordId) {
        Event ev = [SELECT Id, StartDateTime, EndDateTime, Custom_Currency__c, 
                           Custom_Date__c, Custom_Number__c, Custom_Picklist__c, Custom_Text__c
                    FROM Event
                    WHERE Id = :recordId];
        return ev;
    }

    @AuraEnabled
    public static void updateEvent(Id recordId, List<String> namesInfo, List<String> valuesInfo, List<String> typesInfo){
        
        String soqlFields = '';
        for(String st: namesInfo){
            soqlFields = soqlFields + st + ' , ';
        }
        soqlFields = soqlFields.removeEnd(' , ');
        String query = 'SELECT Id, ' + soqlFields + ' FROM Event WHERE Id = :recordId';
        Event eventForUpdate = Database.query(query);

        SObjectType objType = Schema.getGlobalDescribe().get('Event');
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();
        
        Integer count = 0;
        for(String key: namesInfo){
            for(String field: fieldMap.keyset()){
                String fieldName = fieldMap.get(field).getDescribe().getName();
                if(key == fieldName){
                    String currType = typesInfo[count];
                    switch on currType{
                        when 'datetime' {
                            String str = valuesInfo[count].removeEnd('.000Z');
                            String str1 = str.replace('T', ' ');
                            Datetime newDT = Datetime.valueOf(str1);
                            eventForUpdate.put(fieldName, newDT);
                        }
                        when 'date' {
                            Date newDate = Date.valueOf(valuesInfo[count]);
                            eventForUpdate.put(fieldName, newDate);
                        }
                        when 'number' {
                            Integer newInt = Integer.valueOf(valuesInfo[count]);
                            eventForUpdate.put(fieldName, newInt);
                        }
                        when 'text' {
                            eventForUpdate.put(fieldName, valuesInfo[count]);
                        }
                        when else {
                            System.debug('unknown type');
                            //return
                        }
                    }
                }
            }
            count++;
        }
        update eventForUpdate;
    }

    @AuraEnabled
    public static void insertEvent(List<String> namesInfo, List<String> valuesInfo, List<String> typesInfo){
        Event newEvent = new Event();

        SObjectType objType = Schema.getGlobalDescribe().get('Event');
        Map<String, Schema.SObjectField> fieldMap = objType.getDescribe().fields.getMap();

        Integer count = 0;
        for(String key: namesInfo){
            for(String field: fieldMap.keyset()){
                String fieldName = fieldMap.get(field).getDescribe().getName();
                if(key == fieldName){
                    String currType = typesInfo[count];
                    switch on currType{
                        when 'datetime' {
                            String str = valuesInfo[count].removeEnd('.000Z');
                            String str1 = str.replace('T', ' ');
                            Datetime newDT = Datetime.valueOf(str1);
                            newEvent.put(fieldName, newDT);
                        }
                        when 'date' {
                            Date newDate = Date.valueOf(valuesInfo[count]);
                            newEvent.put(fieldName, newDate);
                        }
                        when 'number' {
                            Integer newInt = Integer.valueOf(valuesInfo[count]);
                            newEvent.put(fieldName, newInt);
                        }
                        when 'text' {
                            newEvent.put(fieldName, valuesInfo[count]);
                        }
                        when else {
                            System.debug('unknown type');
                            //return
                        }
                    }
                }
            }
            count++;
        }
        insert newEvent;
    }
}

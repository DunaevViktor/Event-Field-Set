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
    public static void updateEvent(Id recordId, List<Object> fieldsInfo){
        //update logic here
        System.debug(recordId);
        System.debug(fieldsInfo);
    }
}

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
        List<FieldWrapper> fileds = getFields();
        String soqlFields = '';
        for(Integer i=0; i<fileds.size(); i++){
            soqlFields = soqlFields + fileds[i].Name + ' , ';
        }
        soqlFields = soqlFields.removeEnd(' , ');
        String query = 'SELECT Id, ' + soqlFields + ' FROM Event WHERE Id = :recordId';
        Event ev = Database.query(query);
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

        Event event = makeEvent(eventForUpdate, namesInfo, valuesInfo, typesInfo);
        update event;
    }

    @AuraEnabled
    public static String insertEvent(List<String> namesInfo, List<String> valuesInfo, List<String> typesInfo){
        Event newEvent = new Event();

        Event event = makeEvent(newEvent, namesInfo, valuesInfo, typesInfo);
        insert event;
        return event.Id;
    }

    public static Event makeEvent(Event newEvent, List<String> namesInfo, List<String> valuesInfo, List<String> typesInfo){

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
                        when 'checkbox'{
                            Boolean newCheckbox = Boolean.valueOf(valuesInfo[count]);
                            newEvent.put(fieldName, newCheckbox);
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
        return newEvent;
    }
}
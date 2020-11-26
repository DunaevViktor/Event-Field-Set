public with sharing class FieldWrapper {

    @AuraEnabled public String Name {get;set;}
    @AuraEnabled public String Label {get;set;}
    @AuraEnabled public String Type {get;set;}
    @AuraEnabled public SObject Value {get;set;}
    @AuraEnabled public Boolean Required {get;set;}
    @AuraEnabled public Map<String, Object> picklistValues;

    public FieldWrapper(String Name, String Label, String Type, Map<String, Object> picklistValues) {
        this.Name = Name;
        this.Label = Label;
        this.Type = Type;
        this.picklistValues = picklistValues;

        if(Type == 'BOOLEAN'){
            this.Required = false;
        }
        else{
            this.Required = true;
        } 
    }
}
public with sharing class FieldWrapper {

    @AuraEnabled public String Name {get;set;}
    @AuraEnabled public String Label {get;set;}
    @AuraEnabled public String Type {get;set;}
    @AuraEnabled public SObject Value {get;set;}

    public FieldWrapper(String Name, String Label, String Type) {
        this.Name = Name;
        this.Label = Label;
        this.Type = Type;
    }
}

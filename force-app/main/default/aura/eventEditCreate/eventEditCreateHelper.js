({
    helperInit: function(component){
        var action = component.get("c.getEvent");
        
        var recordId = component.get("v.recordId");
        action.setParams({
            recordId: recordId
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.CurrentEvent", response.getReturnValue());
            }
            else{
                console.log("Failed with state: " + state);
            }
        });

        $A.enqueueAction(action);
    },

    helperEdit: function(component) {
        var curEvent = component.get("v.CurrentEvent");
        var objKeys = Object.keys(curEvent);
        var objValues = Object.values(curEvent);

        var action = component.get("c.getFields");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var obj = response.getReturnValue();
                for(var i=0; i<obj.length; i++){

                    var newType = this.convertDatatype(obj[i].Type);
                    obj[i].Type = newType;

                    for(var j=0; j<objKeys.length; j++){
                        if(obj[i].Name == objKeys[j]){
                            obj[i].Value = objValues[j];
                        }
                    }
                }
                component.set("v.FieldsInfo", obj);
            }
            else{
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    helperCreate: function(component) {
        console.log('create logic');
    },

    helperUpdate: function(component) {
        var fields = component.get("v.FieldsInfo");
        var listNewValues = component.find("inputId");

        var listNames = [];
        var listValues = [];
        var listTypes = [];
        for(var i=0; i<listNewValues.length; i++){
            for(var j=0; j<fields.length; j++){
                var label = listNewValues[i].get("v.label");
                if(label == fields[j].Label){
                    var value = listNewValues[i].get("v.value");
                    listValues.push(value);
                    listNames.push(fields[j].Name);
                    listTypes.push(fields[j].Type);
                }
            }
        }

        var recordId = component.get("v.recordId");
        var action = component.get("c.updateEvent");
        action.setParams({
            recordId: recordId,
            namesInfo: listNames,
            valuesInfo: listValues,
            typesInfo: listTypes
        });
        $A.enqueueAction(action);
    },

    convertDatatype: function(datatype) {
        //new logic for picklist, checkbox, text area, text area(long) + required
        switch(datatype) {
            case 'INTEGER': return 'number';
            case 'DOUBLE': return 'number';
            case 'CURRENCY': return 'number';
            case 'DATETIME': return 'datetime';
            case 'DATE': return 'date';
            case 'TEXTAREA': return 'text';
            case 'STRING': return 'text';
            case 'PICKLIST': return 'text';
            case 'BOOLEAN': return 'checkbox';
            default: return datatype;
        }
    },

})
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

                    if(obj[i].Type == 'COMBOBOX'){
                        obj[i].isPickList = true;
                        var pickListOptions = [];
                        for (var key in obj[i].picklistValues){
                            pickListOptions.push({label: key, value: obj[i].picklistValues[key]});
                        }
                        obj[i].option = pickListOptions;
                    }
                    else{
                        obj[i].isPickList = false;
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
        var action = component.get("c.getFields");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var obj = response.getReturnValue();
                for(var i=0; i<obj.length; i++){
                    var newType = this.convertDatatype(obj[i].Type);
                    obj[i].Type = newType;

                    if(obj[i].Type == 'COMBOBOX'){
                        obj[i].isPickList = true;
                        var pickListOptions = [];
                        for (var key in obj[i].picklistValues){
                            pickListOptions.push({label: key, value: obj[i].picklistValues[key]});
                        }
                        obj[i].option = pickListOptions;
                    }
                    else{
                        obj[i].isPickList = false;
                    }
                }
                component.set("v.NewFieldsInfo", obj);
            }
            else{
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
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
                    if(fields[j].Type == 'checkbox'){
                        var valueCheckbox = listNewValues[i].get("v.checked");
                        listValues.push(valueCheckbox);
                    }
                    else{
                        var value = listNewValues[i].get("v.value");
                        listValues.push(value);
                    }
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

    helperInsert: function(component) {
        var currBoolean = false;
        var listNewValues = component.find("newId");
        for(var j=0; j<listNewValues.length; j++){
            if(listNewValues[j].get("v.type") == 'checkbox'){
                currBoolean = listNewValues[j].get("v.checked");
            }
        }

        var newFields = component.get("v.NewFieldsInfo");
        var listNames = [];
        var listValues = [];
        var listTypes = [];
        
        for(var i=0; i<newFields.length; i++){
            if(newFields[i].Type == 'checkbox'){
                listValues.push(currBoolean);
            }
            else{
                listValues.push(newFields[i].Value);
            }
            listNames.push(newFields[i].Name);
            listTypes.push(newFields[i].Type);
        }
        
        var action = component.get("c.insertEvent");
        action.setParams({
            namesInfo: listNames,
            valuesInfo: listValues,
            typesInfo: listTypes
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.recordId", response.getReturnValue());
                this.helperRedirect(component);
            }
            else{
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },

    helperRedirect: function(component) {
        var record = component.get("v.recordId");
        var redirect = $A.get("e.force:navigateToSObject");
        redirect.setParams({
            "recordId": record
        });
        redirect.fire();
    },

    convertDatatype: function(datatype) {
        switch(datatype) {
            case 'INTEGER': return 'number';
            case 'DOUBLE': return 'number';
            case 'CURRENCY': return 'number';
            case 'DATETIME': return 'datetime';
            case 'DATE': return 'date';
            case 'STRING': return 'text';
            case 'BOOLEAN': return 'checkbox';
            //case 'TEXTAREA': return 'text';
            default: return datatype;
        }
    },

})
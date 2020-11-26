({
    doInit: function(component, event, helper) {
        helper.helperInit(component);
    },

    handleEdit: function(component, event, helper) {
        component.set("v.showCreateForm", false);
        component.set("v.showEditForm", true);
        helper.helperEdit(component);
    },

    handleCreate: function(component, event, helper) {
        component.set("v.showEditForm", false);
        component.set("v.showCreateForm", true);
        helper.helperCreate(component);
    },

    handleUpdate: function(component, event, helper) {
        var fieldsToValidate = component.find('inputId');

        const allValid = fieldsToValidate.reduce(function (correctValid, inputCmp) {
            inputCmp.reportValidity();
            return correctValid && inputCmp.checkValidity();
        }, true);

        if(!allValid) {
            return;
        }

        component.set("v.showEditForm", false);
        helper.helperUpdate(component);
        helper.helperRedirect(component);
    },

    handleInsert: function(component, event, helper) {
        var fieldsToValidate = component.find('newId');

        const allValid = fieldsToValidate.reduce(function (correctValid, inputCmp) {
            inputCmp.reportValidity();
            return correctValid && inputCmp.checkValidity();
        }, true);

        if(!allValid) {
            return;
        }

        component.set("v.showCreateForm", false);
        helper.helperInsert(component);
    },

    handleCancel: function(component, event, helper) {
        helper.helperInit(component);
        component.set("v.showEditForm", false);
    },

    handleNewCancel: function(component, event, helper) {
        component.set("v.showCreateForm", false);
    },

})
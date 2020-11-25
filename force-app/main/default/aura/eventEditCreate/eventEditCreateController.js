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
        component.set("v.showEditForm", false);
        helper.helperUpdate(component);
        helper.helperInit(component);
    },

    handleInsert: function(component, event, helper) {
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
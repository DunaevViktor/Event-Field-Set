({
    doInit: function(component, event, helper) {
        helper.helperInit(component);
    },

    handleEdit: function(component, event, helper) {
        //reRender
        component.set("v.showEditForm", true);
        helper.helperEdit(component);
    },

    handleCreate: function(component, event, helper) {
        helper.helperCreate(component);
    },

    handleUpdate: function(component, event, helper) {
        //reRender
        component.set("v.showEditForm", false);
        helper.helperUpdate(component);
    },

    handleCancel: function(component, event, helper) {
        //reRender
        component.set("v.showEditForm", false);
    },

})
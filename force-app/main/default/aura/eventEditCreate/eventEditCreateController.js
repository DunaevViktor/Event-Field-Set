({
    handleClick : function(component, event, helper) {
        var action = component.get("c.getFields");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                console.log(response.getReturnValue());
            }
            else{
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    }
})
fn handle(ctx) {
    let intent = agent_intent();
    let error = intent.context.rework.error;
    #{
        summary: "Stage failed: " + error,
        events: [
            #{ type: "stage.failed", error: error }
        ]
    }
}

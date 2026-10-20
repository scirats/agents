fn handle(ctx) {
    let intent = agent_intent();
    #{
        summary: "Approval event received.",
        events: [
            #{ type: "approval", decision: intent.decision }
        ]
    }
}

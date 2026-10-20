fn handle(ctx) {
    let intent = agent_intent();
    #{
        summary: "Run completed.",
        events: [
            #{ type: "run.complete", task_id: intent.task_id }
        ]
    }
}

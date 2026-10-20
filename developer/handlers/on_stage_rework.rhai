fn handle(ctx) {
    let intent = agent_intent();
    let rework = intent.context.rework;
    let prompt = "A later stage failed. Rework the work in this workspace.\n\nFailure: " + rework.error + "\n\nPrevious summary:\n" + rework.summary;
    let reply = agent_model(#{
        messages: [
            #{ role: "user", content: prompt }
        ]
    });
    let summary = "";
    if reply.content != () {
        summary = reply.content;
    }
    #{
        summary: summary,
        events: [
            #{ type: "stage.rework", content: summary }
        ]
    }
}

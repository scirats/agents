fn handle(ctx) {
    let intent = agent_intent();
    let rework = intent.context.rework;
    let prompt = "A later stage failed after your review. Re-check the current workspace and update your review findings.\n\nFailure: " + rework.error + "\n\nPrevious summary:\n" + rework.summary;
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
            #{ type: "review.rework", content: summary }
        ]
    }
}

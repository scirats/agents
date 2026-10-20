fn handle(ctx) {
    let intent = agent_intent();
    let rework = intent.context.rework;
    let prompt = "A later stage failed after your test run. Re-run the relevant checks against the current workspace and update your test report.\n\nFailure: " + rework.error + "\n\nPrevious summary:\n" + rework.summary;
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
            #{ type: "test.rework", content: summary }
        ]
    }
}

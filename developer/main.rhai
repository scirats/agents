// Developer agent. The host injects task/model/tool functions and runs this
// file inside the agent sandbox.
fn run(ctx) {
    let task = agent::task();
    let readme = tools::workspace_read("README.md");

    let reply = agent::model(#{
        task: task,
        context: readme,
    });

    if reply.tool_calls.len() > 0 {
        for call in reply.tool_calls {
            tools::dispatch(call);
        }
    }

    #{
        summary: reply.content,
    }
}

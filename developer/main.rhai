// Developer agent. The host injects task/model/tool functions and runs this
// file inside the agent sandbox.
fn run(ctx) {
    let task = agent_task();
    let readme = tools_workspace_read("README.md");

    let reply = agent_model(#{
        task: task,
        context: readme,
    });

    if reply.tool_calls.len() > 0 {
        for tool_call in reply.tool_calls {
            tools_dispatch(tool_call);
        }
    }

    #{
        summary: reply.content,
    }
}

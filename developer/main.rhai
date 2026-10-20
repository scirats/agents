// Developer agent. The host injects task/model/tool functions and runs this
// file inside the agent sandbox.
fn run(ctx) {
    let task = agent_task();
    let readme = if tools_workspace_exists("README.md") {
        tools_workspace_read("README.md")
    } else {
        ""
    };

    let reply = agent_model(#{
        task: task,
        context: readme,
    });

    if reply.content != () {
        tools_workspace_write("agent-output.md", reply.content);
    }

    #{
        summary: reply.content,
    }
}

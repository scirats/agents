fn handle(ctx) {
    let intent = agent_intent();
    let task = intent.task;
    let readme = "";
    if tools_workspace_exists("README.md") {
        readme = tools_workspace_read("README.md");
    }

    let prompt = "Task: " + task.title + "\n\n" + task.spec + "\n\nWorkspace notes:\n" + readme;
    let reply = agent_model(#{
        messages: [
            #{ role: "user", content: prompt }
        ],
        tools: intent.tools
    });

    let summary = "";
    if reply.content != () {
        summary = reply.content;
    }

    if reply.tool_calls.len() > 0 {
        for call in reply.tool_calls {
            let result = execute_tool(call);
            agent_emit(#{
                type: "tool_result",
                name: call.name,
                result: result
            });
        }
        let followup = agent_model(#{
            messages: [
                #{ role: "user", content: prompt },
                #{ role: "user", content: "The requested tools were executed. Return the final summary." }
            ]
        });
        if followup.content != () {
            summary = followup.content;
        }
    }

    if summary != "" {
        tools_workspace_write("agent-output.md", summary);
    }

    #{
        summary: summary,
        events: [
            #{ type: "message", content: summary }
        ]
    }
}

fn execute_tool(call) {
    let name = call.name;
    let args = call.arguments;
    if name == "workspace.read" || name == "workspace_read" {
        return tools_workspace_read(args.path);
    }
    if name == "workspace.write" || name == "workspace_write" {
        tools_workspace_write(args.path, args.content);
        return #{ status: "ok" };
    }
    if name == "artifact.write" || name == "artifact_write" {
        tools_artifact_write(args.path, args.content);
        return #{ status: "ok" };
    }
    if name == "check.run" || name == "check_run" {
        return tools_check_run(args.command);
    }
    return #{ status: "unknown_tool", name: name };
}

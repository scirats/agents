fn handle(ctx) {
    let intent = agent_intent();
    let task = intent.task;
    let readme = "";
    if tools_workspace_exists("README.md") {
        readme = tools_workspace_read("README.md");
    }

    let prompt = "Task: " + task.title + "\n\n" + task.spec + "\n\nWorkspace notes:\n" + readme;
    let messages = [
        #{ role: "user", content: prompt }
    ];
    let summary = "";
    let step = 0;

    while step < 8 {
        let reply = agent_model(#{
            messages: messages,
            tools: intent.tools
        });

        if reply.tool_calls.len() == 0 {
            if reply.content != () {
                summary = reply.content;
            }
            break;
        }

        messages.push(#{
            role: "assistant",
            content: reply.content,
            tool_calls: reply.tool_calls
        });

        for tool in reply.tool_calls {
            let result = execute_tool(tool);
            agent_emit(#{
                type: "tool_result",
                name: tool.name,
                result: result
            });
            messages.push(#{
                role: "tool",
                tool_call_id: tool.id,
                content: result
            });
        }
        step += 1;
    }

    if summary == "" {
        summary = "Executed agent tools.";
    }

    #{
        summary: summary,
        events: [
            #{ type: "message", content: summary }
        ]
    }
}

fn execute_tool(tool) {
    let name = tool.name;
    let args = tool.arguments;
    if name == "workspace_read" {
        return tools_workspace_read(args.path);
    }
    if name == "workspace_write" {
        tools_workspace_write(args.path, args.content);
        return "ok";
    }
    if name == "artifact_write" {
        tools_artifact_write(args.path, args.content);
        return "ok";
    }
    if name == "check_run" {
        return tools_check_run(args.command);
    }
    return "unknown tool: " + name;
}
